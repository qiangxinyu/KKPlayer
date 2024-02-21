//
//  EditAudioInfo.swift
//  KKPlayer_new
//
//  Created by 强新宇 on 2024/2/20.
//

import UIKit


class EditAudioInfoViewController: ViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    
    var list = [AudioModel]()
    
    
    private let lineView = UIView.presentLine
    private let artowkImageView = Button(style: .image)
    
    
    private let artistInput = InputView()
    private let albumInput = InputView()
    
    
    private let itemHeight: CGFloat = 72

    private lazy var artistMenu = {
        EditAudioMenuView(list: allAudio.filter {$0.artist != nil}.map { $0.artist! })
    }()
    
    private lazy var albumMenu = {
        EditAudioMenuView(list: allAudio.filter {$0.album != nil}.map { $0.album! })
    }()
    
    private lazy var allAudio = {
        (try? CoreDataContext.fetch(AudioModel.fetchRequest())) ?? []
    }()
    
    
    override func viewDidLoad() {
        layoutSubviews()
        handleModels()
    }
    
    
    
    private func handleModels() {
        if list.count == 1 {
            artowkImageView.image = list[0].originalArtworkImage
        } else {
            let size = artowkImageView.frame.size
            artowkImageView.image = UIGraphicsImageRenderer(size: size).image {[weak self] _ in
                guard let list = self?.list else { return }
                
                let images = list.filter { $0.originalArtworkImage != nil }.map {$0.originalArtworkImage!}
                
                let rows: CGFloat = ceil(sqrt(Double(images.count)))
                let cols: CGFloat = rows
                
                let itemWidth = size.width / cols
                let itemHeight = size.height / rows
                
                var row: CGFloat = 0
                var col: CGFloat = 0
                
                for image in images {
                    if col == cols {
                        col = 0
                        row += 1
                    }
                    if row > rows {
                        return
                    }
                    image.draw(in: .init(x: col * itemWidth, y: row * itemHeight, width: itemWidth, height: itemHeight))
                    col += 1
                }
                
                
            }
        }
    }
    
    
    private func layoutSubviews() {
        view.backgroundColor = .white
        
        view.addSubview(lineView)
        lineView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(Theme.marginOffset)
            make.width.equalTo(lineView.width)
            make.height.equalTo(lineView.height)
        }
        
        view.addSubview(artowkImageView)
        
        artowkImageView.layer.borderColor = UIColor.HEXA("AAAAAA").cgColor
        artowkImageView.layer.borderWidth = 0.5
        artowkImageView.layer.masksToBounds = true
        artowkImageView.layer.cornerRadius = 12
        artowkImageView.backgroundColor = .P01
        artowkImageView.snp.makeConstraints { make in
            make.aspectRatio(1, view: artowkImageView)
            make.left.equalToSuperview().offset(Theme.marginOffset)
            make.right.equalToSuperview().offset(-Theme.marginOffset)
            make.top.equalTo(lineView.snp.bottom).offset(Theme.marginOffset)
        }
        
        
        artowkImageView.layoutIfNeeded()
        
        
        view.addSubview(artistInput)
        view.addSubview(albumInput)
        
        
        artistInput.touchMenu = {[weak self] ges in
            self?.artistMenu.show(ges: ges)
        }
        artistInput.title = "歌手"
        artistInput.snp.makeConstraints { make in
            make.top.equalTo(artowkImageView.snp.bottom).offset(20)
            make.left.equalTo(Theme.marginOffset)
            make.right.equalTo(-Theme.marginOffset)
            make.height.equalTo(itemHeight)
        }
        
        albumInput.title = "专辑"
        albumInput.snp.makeConstraints { make in
            make.top.equalTo(artistInput.snp.bottom).offset(Theme.marginOffset)
            make.left.equalTo(Theme.marginOffset)
            make.right.equalTo(-Theme.marginOffset)
            make.height.equalTo(itemHeight)
        }
    }
}



// MARK: Input View

fileprivate class InputView: View, UITextFieldDelegate {
    private let titleLabel = UILabel()
    private let textInput = UITextField()
    private let menuButton = Button(imageName: "icon_down_arrow")
    
    var title: String? {
        set {
            titleLabel.text = newValue
        }
        get {
            titleLabel.text
        }
    }
    
    var placeholder: String? {
        set {
            textInput.placeholder = newValue
        }
        get {
            textInput.placeholder
        }
    }
    
    var touchMenu: ((UIGestureRecognizer) -> Void)? = nil
    
    func closeMenu() {
        UIView.animate(withDuration: 0.4) {[weak self] in
            self?.menuButton.transform = CGAffineTransformMakeRotation(0)
        }
    }
    
    
    override func initSelf() {
        addSubview(titleLabel)
        addSubview(textInput)
        addSubview(menuButton)
        
        titleLabel.font = .pingFang(name: .medium, size: 20)
        titleLabel.snp.makeConstraints { make in
            make.left.equalToSuperview()
            make.top.equalToSuperview()
            make.height.equalTo(20)
        }
        
        textInput.font = .pingFang(size: 16)
        textInput.backgroundColor = .B04
        textInput.layer.cornerRadius = 6
        textInput.layer.masksToBounds = true
        textInput.leftViewMode = .always
        textInput.leftView = .init(frame: .init(x: 0, y: 0, width: 8, height: 0))
        textInput.rightViewMode = .always
        textInput.rightView = .init(frame: .init(x: 0, y: 0, width: 44, height: 0))
        textInput.delegate = self
        textInput.snp.makeConstraints { make in
            make.left.right.bottom.equalToSuperview()
            make.height.equalTo(44)
        }
        
        menuButton.touchUpInside { [weak self] ges in
            UIView.animate(withDuration: 0.4) {
                self?.menuButton.transform = CGAffineTransformMakeRotation(.pi / 2)
            }
            self?.touchMenu?(ges)
        }
        menuButton.imageEdgeInserts = .init(edges: 10)
        menuButton.backgroundColor = .clear
        menuButton.snp.makeConstraints { make in
            make.width.height.equalTo(44)
            make.right.equalToSuperview()
            make.bottom.equalToSuperview()
        }
    }
    
    
    func textFieldDidEndEditing(_ textField: UITextField) {
//            change?(textField.text)
    }
}

// MARK: Menu
fileprivate let CellKey = "CellKey"
fileprivate class EditAudioMenuView: MenuView, UITableViewDelegate, UITableViewDataSource {
    private let tableView = UITableView()
    private var datas = [String]()
    
    init(list: [String]) {
        super.init(frame: .zero)
        datas = list
        initSelf()
    }
    
    
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func initSelf() {
        super.initSelf()
    
        contentView.addSubview(tableView)
        
        let itemWidth: CGFloat = 200
        
        contentView.frame = .init(x: 0, y: 0, width: itemWidth, height: 44 * 6)
        
        tableView.register(Cell.self, forCellReuseIdentifier: CellKey)

        tableView.delegate = self
        tableView.dataSource = self
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return datas.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: CellKey) as? Cell ?? Cell()

        cell.label.text = datas[indexPath.row]
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)

    }
}


fileprivate class Cell: UITableViewCell {
    let label = UILabel()
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = .white
        contentView.addSubview(label)
        label.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    required init?(coder: NSCoder) {
        super.init(style: .default, reuseIdentifier: CellKey)
    }
}
