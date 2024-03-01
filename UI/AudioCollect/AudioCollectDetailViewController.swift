//
//  AudioCollectDetailViewController.swift
//  KKPlayer_new
//
//  Created by 强新宇 on 2024/3/1.
//

import UIKit

fileprivate let CellKey = "CellKey"

class AudioCollectDetailViewController: PresentViewController, UITableViewDelegate, UITableViewDataSource {
    var model: CollectModel = ArtistModel() {
        didSet {
            headerView.iconIV.image = model.originIconImage ?? UIImage(named: CollectDataSource.Types.init(rawValue: model.type.rawValue)!.defaultIcon)
            headerView.nameLabel.text = model.name
            headerView.count = model.list.count
        }
    }
    
    private let headerView = HeaderView()
    
    private let tableView = UITableView()

    
    override func viewDidLoad() {
        
        view.addSubview(tableView)

        super.viewDidLoad()
        
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        tableView.estimatedRowHeight = 0
        tableView.estimatedSectionFooterHeight = 0
        tableView.estimatedSectionHeaderHeight = 0
        
        tableView.contentInsetAdjustmentBehavior = .never
        tableView.contentInset = .init(
            top: 40,
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
        return model.list.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: CellKey) as! Cell
        cell.model = model.list[indexPath.row]
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)

        
        PlayerManager.play(model: model.list[indexPath.row], list: model.list)

    }
  
    class HeaderView: View {
        let iconIV = UIImageView()
        let nameLabel = UILabel()
        let countLabel = UILabel()
        
        var count: Int = 0 {
            didSet { countLabel.text = "歌曲数：\(count)" }
        }
        
        override func initSelf() {
            
            addSubview(iconIV)
            addSubview(nameLabel)
            addSubview(countLabel)
            
            height = 180
            
            iconIV.layer.cornerRadius = 12
            iconIV.layer.masksToBounds = true
            
            iconIV.snp.makeConstraints { make in
                make.width.height.equalTo(120)
                make.centerX.equalToSuperview()
                make.top.equalToSuperview()
            }
            
            nameLabel.textColor = .T01
            nameLabel.font = .pingFang(name: .medium, size: 30)
            nameLabel.textAlignment = .center
            nameLabel.snp.makeConstraints { make in
                make.top.equalTo(iconIV.snp.bottom)
                make.bottom.equalToSuperview().offset(-10)
                make.left.equalTo(60)
                make.right.equalTo(-60)
            }
            
            countLabel.textColor = .T02
            countLabel.font = .pingFang(size: 12)
            countLabel.snp.makeConstraints { make in
                make.bottom.equalToSuperview()
                make.left.equalTo(Theme.marginOffset)
            }
        }
    }
    
}

fileprivate class Cell: UITableViewCell {
    
    
    var itemView = AudioItemView()
    
    var model = AudioModel() {
        didSet { itemView.model = model }
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = .white
        contentView.addSubview(itemView)
        itemView.more.isHidden = true
        itemView.more.snp.updateConstraints { make in
            make.width.equalTo(0)
            make.right.equalTo(0)
        }
        itemView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("")
    }
}
