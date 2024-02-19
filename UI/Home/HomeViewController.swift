//
//  HomeVC.swift
//  KKPlayer_new
//
//  Created by 强新宇 on 2024/2/15.
//

import UIKit


class HomeViewController: ViewController {
    static let shared = HomeViewController()
    
    fileprivate override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    internal required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    private convenience init() {
        self.init(nibName: nil, bundle: nil)
    }
    
    fileprivate var status = Status.default {
        didSet { typeChange() }
    }
    
    fileprivate let navigationBar = NaviBar()
    
    
    fileprivate let headerView = HeaderView()
    fileprivate let tableView = UITableView()
    
    fileprivate let miniControl = PlayerMiniControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        refreshScreenInfo()
        HomeDataSource.refreshItems()
  
       
        observer()
        
        initList()


        initNavigationBar()

        initMiniControl()
    }
}



// MARK: Status

extension HomeViewController {
    fileprivate enum Status {
        case `default`
        case select
    }
    
    fileprivate func typeChange() {
        
    }
}



// MARK: NavigationBar

extension HomeViewController {
    
    
    fileprivate func initNavigationBar() {
        view.addSubview(navigationBar)
        navigationBar.snp.makeConstraints { make in
            make.top.left.right.equalToSuperview()
            make.height.equalTo(kNavigationHeight)
        }
    }
}


fileprivate class NaviBar: View {
    fileprivate var status = HomeViewController.Status.default {
        didSet { changeStatus() }
    }
    
    private let backgroundView = UIVisualEffectView(effect: UIBlurEffect(style: .light))
    
    let label = UILabel()
    let myButton = Button(imageName: "icon_my")
    
    override func initSelf() {
        addSubview(backgroundView)
        addSubview(myButton)
        
        
        backgroundView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        myButton.touchUpInside {
            SettingView.show()
        }
        
        myButton.snp.makeConstraints { make in
            make.width.height.equalTo(44)
            make.bottom.equalToSuperview()
        }
    }
    
    private func changeStatus() {
        switch status {
        case .default:
            myButton.isHidden = false
            
        case .select:
            myButton.isHidden = true
        }
    }
    
}


// MARK: List
extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    
    fileprivate func initList() {
        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        tableView.estimatedRowHeight = 0
        tableView.estimatedSectionFooterHeight = 0
        tableView.estimatedSectionHeaderHeight = 0
        
        tableView.contentInset = .init(top: kNavigationBarHeight, left: 0, bottom: kMainWindow.safeAreaInsets.bottom + 30, right: 0)

        
        
        tableView.layoutIfNeeded()
        
        tableView.showsVerticalScrollIndicator = false
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.sectionIndexColor = .Main
        tableView.tableHeaderView = headerView
        
       
        
        
        HomeDataSource.itemChange {
            self.headerView.count = HomeDataSource.items.count
            self.tableView.reloadData()
        }
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    

    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return HomeDataSource.items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = Cell()
        cell.model = HomeDataSource.items[indexPath.row]

        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)

        PlayerManager.play(model: HomeDataSource.items[indexPath.row], list: HomeDataSource.items)
    }
    
//    func sectionIndexTitles(for tableView: UITableView) -> [String]? {
//        switch sort {
//        case .name, .artist: return keys
//        case .time, .length, .count: return nil
//        }
//    }

//    func tableView(_ tableView: UITableView, sectionForSectionIndexTitle title: String, at index: Int) -> Int {
//        feedbackGenerator.selectionChanged()
//
//        var row = 0
//
//        for (i, key) in keys.enumerated() {
//            if i == index {
//                var y = CGFloat(50 * (row + 1))
//                let maxY = tableView.contentSize.height - tableView.height
//
//                if y > maxY {
//                    y = maxY
//                }
//
//                tableView.setContentOffset(.init(x: 0, y: y), animated: false)
//                return index
//            }
//            row += (ids[key]?.count ?? 0)
//        }
//
//        return index
//    }
    
    
    
    fileprivate class HeaderView: Label {
        
        var count: Int = 0 {
            didSet {
                text = "歌曲数：\(count)"
            }
        }
       
        
        override func initSelf() {
            height = 30
            textColor = .T02
            font = .pingFang(size: 12)
            
        }

        open override func drawText(in rect: CGRect) {
            super.drawText(
                in: rect.inset(
                    by: .init(
                        top: 0,
                        left: Theme.marginOffset,
                        bottom: 0,
                        right: 0)
                )
            )
        }
    }
}


fileprivate class Cell: UITableViewCell {
    
    let itemView = AudioItemView()
    
    var model = AudioModel() {
        didSet { itemView.model = model }
    }
    
    init() {
        super.init(style: .default, reuseIdentifier: nil)
        backgroundColor = .white
        contentView.backgroundColor = .white
        contentView.addSubview(itemView)
        itemView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    required init?(coder: NSCoder) {
        super.init(style: .default, reuseIdentifier: nil)
    }
}



// MARK: PlayerMiniControl

extension HomeViewController {
    fileprivate func initMiniControl() {
        miniControl.touchUpInside {
            PlayerControl.show()
        }
        
        view.addSubview(miniControl)
        miniControl.snp.makeConstraints { make in
            make.bottom.equalToSuperview().offset(-kMainWindow.safeAreaInsets.bottom)
            make.left.equalToSuperview().offset(20)
            make.right.equalToSuperview().offset(-20)
            make.height.equalTo(60)
        }
    }
}


// MARK: Observer

extension HomeViewController {
    private func observer() {
        PlayerManager.currentModelChange {
            self.tableView.scrollTo(item: PlayerManager.currentModel, list: HomeDataSource.items)
        }
    }
}
