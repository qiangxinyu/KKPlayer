//
//  AudioCollectViewController.swift
//  KKPlayer_new
//
//  Created by 强新宇 on 2024/3/1.
//

import UIKit

fileprivate let CellKey = "CellKey"

class AudioCollectViewController: PresentViewController, UITableViewDelegate, UITableViewDataSource {
    private(set) var type: CollectDataSource.Types
    private let titleLabel = UILabel()
    private let tableView = UITableView()
    private let headerView = CountHeaderView()

    private let backgroundView = UIVisualEffectView(effect: UIBlurEffect(style: .light))

    init(type: CollectDataSource.Types) {
        self.type = type
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        
        initList()

        headerView.countString = "数量"
        headerView.count = CollectDataSource.shared.getList(with: type).count
        view.addSubview(backgroundView)
        
        super.viewDidLoad()
        
        
        view.addSubview(titleLabel)
        
        backgroundView.snp.makeConstraints { make in
            make.top.left.right.equalToSuperview()
            make.bottom.equalTo(titleLabel.snp.bottom)
        }
        
        
        titleLabel.text = type.name
        titleLabel.textColor = .T01
        titleLabel.font = .pingFang(name: .medium, size: 26)
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(lineView.snp.bottom)
            make.left.equalTo(Theme.marginOffset)
            make.height.equalTo(60)
        }
    }
    
    
    private func initList() {
        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        tableView.estimatedRowHeight = 0
        tableView.estimatedSectionFooterHeight = 0
        tableView.estimatedSectionHeaderHeight = 0
        
        tableView.contentInsetAdjustmentBehavior = .never
        tableView.contentInset = .init(
            top: 70,
            left: 0,
            bottom: kMainWindow.safeAreaInsets.bottom,
            right: 0)

        tableView.register(Cell.self, forCellReuseIdentifier: CellKey)
        
        tableView.layoutIfNeeded()
        
        tableView.showsVerticalScrollIndicator = false
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.tableHeaderView = headerView
    }
 
   
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }

    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return CollectDataSource.shared.getList(with: type).count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: CellKey) as! Cell
        cell.model = CollectDataSource.shared.getList(with: type)[indexPath.row]

        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)

        let vc = AudioCollectDetailViewController()
        vc.model = CollectDataSource.shared.getList(with: type)[indexPath.row]
        self.present(vc, animated: true)
        
    }
}


fileprivate class Cell: UITableViewCell {
    var type: CollectDataSource.Types = .Album

    var model: CollectModel = ArtistModel() {
        didSet {
            icon.image = model.iconImage ?? UIImage(named: "icon_album")
            name.text = model.name
        }
    }
    
    private let icon = UIImageView()
    private let name = UILabel()
    private let arrow = UIImageView(image: .init(named: "edit／rightarrow／normat"))
    private let line = UIView()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = .white

        contentView.addSubview(icon)
        contentView.addSubview(name)
        contentView.addSubview(arrow)
        contentView.addSubview(line)

        icon.layer.cornerRadius = 4
        icon.layer.masksToBounds = true
        icon.backgroundColor = .P01
        icon.snp.makeConstraints { make in
            make.left.equalTo(Theme.marginOffset)
            make.top.equalTo(2)
            make.bottom.equalTo(-2)
            make.aspectRatio(1, view: icon)
        }
        
        name.font = .pingFang(name: .medium, size: 16)
        name.adjustsFontSizeToFitWidth = true
        name.minimumScaleFactor = 0.1
        name.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalTo(icon.snp.right).offset(5)
            make.right.equalTo(arrow.snp.left).offset(-5)
        }
        
        
        arrow.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.right.equalToSuperview().offset(-Theme.marginOffset)
        }
        
        line.backgroundColor = .T02
        line.snp.makeConstraints { make in
            make.bottom.equalToSuperview()
            make.right.equalToSuperview()
            make.left.equalTo(icon.snp.right).offset(4)
            make.height.equalTo(0.5)
        }
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("")
    }
}
