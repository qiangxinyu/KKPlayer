//
//  EditAudioInfo.swift
//  KKPlayer_new
//
//  Created by 强新宇 on 2024/2/20.
//

import UIKit


class EditAudioInfoViewController: PresentViewController {
    
    var list = [AudioModel]()
    
    private let artworkImageView = Button(style: .image)
    
    private let nameInput = InputView()
    private let artistInput = InputView()
    private let albumInput = InputView()
    
    private let saveButton = SaveButton(title: "保存")
    
    
    private let itemHeight: CGFloat = 72

    private lazy var artistMenu = {
        var artistList = allAudio.filter {$0.artist?.isEmpty == false }.map { $0.artist! }
        artistList = Array(Set(artistList))
        return EditAudioMenuView(list: artistList)
    }()
    
    private lazy var albumMenu = {
        var albumList = allAudio.filter {$0.album?.isEmpty == false }.map { $0.album! }
        albumList = Array(Set(albumList))
        return EditAudioMenuView(list: albumList)
    }()
    
    private lazy var allAudio = {
        (try? CoreDataContext.fetch(AudioModel.fetchRequest())) ?? []
    }()
    
    
    private var newArtwork: UIImage? = nil
    private var newName: String? = nil
    private var newArtist: String? = nil
    private var newAlbum: String? = nil {
        didSet {
            albumInput.value = newAlbum
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        layoutSubviews()
        handleModels()
        handleLogical()
    }
    
    
    private func handleModels() {
        if list.count == 1 {
            artworkImageView.image = list[0].originalArtworkImage
            nameInput.value = list[0].name
            artistInput.value = list[0].artist
            albumInput.value = list[0].album
        } else {
            var loading: UIActivityIndicatorView? = nil
            if list.count > 50 {
                loading = UIActivityIndicatorView()
                artworkImageView.addSubview(loading!)
                loading?.snp.makeConstraints { make in
                    make.center.equalToSuperview()
                }
                loading?.startAnimating()
            }
            
            let size = artworkImageView.frame.size
            DispatchQueue.global().async { [weak self]  in
                let image = UIGraphicsImageRenderer(size: size).image {_ in
                    guard let list = self?.list else { return }
                    
                    let models = list.filter { $0.originalArtworkImage != nil }
                    
                    let rows: CGFloat = ceil(sqrt(Double(models.count)))
                    let cols: CGFloat = rows
                    
                    let images = models.map { rows >= 4 ? $0.artworkImage! : $0.originalArtworkImage! }
                
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
                
                DispatchQueue.main.async {
                    self?.artworkImageView.image = image
                    loading?.removeFromSuperview()
                }
            }
        }
        
        
        nameInput.placeholder = "内容会拼接到所有歌名之后!"
    }
    
    
    private func handleLogical() {
       
        artistInput.showMenu {[weak self] ges in
            self?.artistMenu.show(ges: ges) { newArtist in
                self?.newArtist = newArtist
            } closeCall: {
                self?.artistInput.closeMenuButtonAnimate()
            }
        } 
    
        albumInput.showMenu {[weak self] ges in
            self?.albumMenu.show(ges: ges) { newAlbum in
                self?.newAlbum = newAlbum
            } closeCall: {
                self?.albumInput.closeMenuButtonAnimate()
            }
        }
        
        nameInput.valueChange = {[weak self] newValue in
            if newValue?.isEmpty == true {
                UIAlertController.show(title: "歌名不能为空")
                return
            }
            self?.newName = newValue
        }
        
        artistInput.valueChange = {[weak self] newValue in
            self?.newArtist = newValue
        }
        
        albumInput.valueChange = {[weak self] newValue in
            self?.newAlbum = newValue
        }
        
        saveButton.touchUpInside {[weak self] in
            self?.save()
        }
    }
    
    private func save() {
        if newName == nil, newArtist == nil,
            newArtwork == nil, newAlbum == nil {
            dismiss(animated: true)
            return
        }
        
        if list.count == 1 {
            list[0].update(
                name: newName,
                artist: newArtist,
                artwork: newArtwork,
                album: newAlbum
            )
            HomeDataSource.itemsChangesPost()
            PlayerManager.playListChangesPost()
            dismiss(animated: true)
        } else {
            view.isUserInteractionEnabled = false
            
            let loading = UIActivityIndicatorView()
            loading.color = .white
            saveButton.addSubview(loading)
            saveButton.backgroundColor = .gray
            saveButton.title = ""
            loading.snp.makeConstraints { make in
                make.center.equalToSuperview()
            }
            loading.startAnimating()

            
            DispatchQueue.global().async {[weak self] in
                guard let self = self else {return}
                
                self.list.forEach { model in
                    autoreleasepool {
                        model.update(
                            name: model.name! + (self.newName ?? ""),
                            artist: self.newArtist,
                            artwork: self.newArtwork,
                            album: self.newAlbum,
                            autoSaveCoreData: false
                        )
                    }
                }
                
                try? CoreDataContext.save()
                
                DispatchQueue.main.async {
                    HomeDataSource.itemsChangesPost()
                    PlayerManager.playListChangesPost()
                    self.dismiss(animated: true)
                }
            }
        }
    }
    
    private func layoutSubviews() {
        
        view.addSubview(artworkImageView)
        artworkImageView.touchUpInside {[weak self] in
            UIImagePickerController.openPhotos(viewConroller: self)
        }
        artworkImageView.contentMode = .scaleAspectFill
        artworkImageView.layer.borderColor = UIColor.HEX("AAAAAA").cgColor
        artworkImageView.layer.borderWidth = 0.5
        artworkImageView.layer.masksToBounds = true
        artworkImageView.layer.cornerRadius = 12
        artworkImageView.backgroundColor = .P01
        artworkImageView.snp.makeConstraints { make in
            make.aspectRatio(1, view: artworkImageView)
            make.left.equalToSuperview().offset(Theme.marginOffset)
            make.right.equalToSuperview().offset(-Theme.marginOffset)
            make.top.equalTo(lineView.snp.bottom).offset(Theme.marginOffset)
        }
        
        
        artworkImageView.layoutIfNeeded()
        
        view.addSubview(nameInput)
        view.addSubview(artistInput)
        view.addSubview(albumInput)
        
        
        nameInput.placeholder = "请输入歌名"
        nameInput.title = "歌名"
        nameInput.snp.makeConstraints { make in
            make.top.equalTo(artworkImageView.snp.bottom).offset(20)
            make.left.equalTo(Theme.marginOffset)
            make.right.equalTo(-Theme.marginOffset)
            make.height.equalTo(itemHeight)
        }
        
        artistInput.placeholder = "请输入歌手"
        artistInput.title = "歌手"
        artistInput.snp.makeConstraints { make in
            make.top.equalTo(nameInput.snp.bottom).offset(Theme.marginOffset)
            make.left.equalTo(Theme.marginOffset)
            make.right.equalTo(-Theme.marginOffset)
            make.height.equalTo(itemHeight)
        }
        
        albumInput.placeholder = "请输入专辑名"
        albumInput.title = "专辑"
        albumInput.snp.makeConstraints { make in
            make.top.equalTo(artistInput.snp.bottom).offset(Theme.marginOffset)
            make.left.equalTo(Theme.marginOffset)
            make.right.equalTo(-Theme.marginOffset)
            make.height.equalTo(itemHeight)
        }
        
        
        view.addSubview(saveButton)
        saveButton.snpMake()
    }
    
}



// MARK: Input View

fileprivate class InputView: View, UITextFieldDelegate {
    private let titleLabel = UILabel()
    private let textInput = UITextField()
    private lazy var menuButton = {Button(imageName: "icon_down_arrow")}()
    
    var title: String? {
        set { titleLabel.text = newValue }
        get { titleLabel.text }
    }
    
    var placeholder: String? {
        set { textInput.placeholder = newValue }
        get { textInput.placeholder }
    }
    
    var value: String? {
        set { textInput.text = newValue }
        get { textInput.text }
    }
    
    private var touchMenu: ((UIGestureRecognizer) -> Void)? = nil
    
    func closeMenuButtonAnimate() {
        UIView.animate(withDuration: 0.4) {[weak self] in
            self?.menuButton.transform = CGAffineTransformMakeRotation(0)
        }
    }
    
    func showMenu(callback: @escaping (UIGestureRecognizer) -> Void) {
        touchMenu = callback
        
        addSubview(menuButton)
        menuButton.touchUpInside { [weak self] ges in
            UIView.animate(withDuration: 0.4) {
                self?.menuButton.transform = CGAffineTransformMakeRotation(-.pi / 2)
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
    
    override func initSelf() {
        addSubview(titleLabel)
        addSubview(textInput)
        
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
        
        
    }
    
    var valueChange: ((String?) -> Void)? = nil
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        valueChange?(textField.text)
    }
}

// MARK: Image Picker Controller
extension EditAudioInfoViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true)
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let image = info[.editedImage] as? UIImage {
            artworkImageView.image = image
            newArtwork = image
            
        }
        
        picker.dismiss(animated: true)
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
    
    private var closeBlock: (() -> Void)? = nil
    private var selectBlock: ((String) -> Void)? = nil
    func show(ges: UIGestureRecognizer, selectCall: @escaping (String) -> Void, closeCall: @escaping () -> Void) {
        super.show(ges: ges)
        closeBlock = closeCall
        selectBlock = selectCall
    }
    override func hidden() {
        super.hidden()
        closeBlock?()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func initSelf() {
        super.initSelf()
        contentView.addSubview(tableView)
        
        let itemWidth: CGFloat = 200
        
        contentView.frame = .init(x: 0, y: 0, width: itemWidth, height: 44 * 6)
        tableView.frame = contentView.bounds
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
        
        let cell = tableView.dequeueReusableCell(withIdentifier: CellKey) as! Cell

        cell.label.text = datas[indexPath.row]
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        selectBlock?(datas[indexPath.row])
        hidden()
    }
}


fileprivate class Cell: UITableViewCell {
    let label = UILabel()
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = .white
        contentView.addSubview(label)
        label.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview()
            make.left.equalTo(Theme.marginOffset)
            make.right.equalTo(-Theme.marginOffset)
        }
    }
    required init?(coder: NSCoder) {
        super.init(style: .default, reuseIdentifier: CellKey)
    }
}
