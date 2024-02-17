//
//  HomeVC.swift
//  KKPlayer_new
//
//  Created by 强新宇 on 2024/2/15.
//

import UIKit


class HomeViewController: ViewController {
    static let shared = HomeViewController()
    
    private override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    internal required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    private convenience init() {
        self.init(nibName: nil, bundle: nil)
    }
    
    private var type = Type.default {
        didSet { typeChange() }
    }
    
    private let navigationBar = NaviBar()
    
    
    private let headerView = HeaderView()
    private let tableView = UITableView()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        refreshScreenInfo()
  
       
        
        initList()



        initNavigationBar()


        headerView.count = PlayerManager.main.items.count
    }
    
  
    
}



// MARK: Type

extension HomeViewController {
    private enum `Type` {
        case `default`
        case select
    }
    
    private func typeChange() {
        
    }
}



// MARK: NavigationBar

extension HomeViewController {
    
    
    private func initNavigationBar() {
        view.addSubview(navigationBar)
        navigationBar.snp.makeConstraints { make in
            make.top.left.right.equalToSuperview()
            make.height.equalTo(kNavigationHeight)
        }
    }
 
    
    
    private class NaviBar: UIVisualEffectView {
        override init(effect: UIVisualEffect? = nil) {
            super.init(effect: UIBlurEffect(style: .light))
            layout()
        }
        
        required init?(coder: NSCoder) {
            super.init(coder: coder)
        }
        
        func layout() {
            
        }
    }
}




// MARK: List
extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    
    private func initList() {
        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        tableView.estimatedRowHeight = 0
        tableView.estimatedSectionFooterHeight = 0
        tableView.estimatedSectionHeaderHeight = 0
        
        tableView.contentInset = .init(top: kNavigationBarHeight, left: 0, bottom: 0, right: 0)

        
        tableView.layoutIfNeeded()
        
        tableView.showsVerticalScrollIndicator = false
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.sectionIndexColor = .Main
        tableView.tableHeaderView = headerView
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return PlayerManager.main.items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = Cell()
        cell.model = PlayerManager.main.items[indexPath.row]
//        let iv = UIImageView(frame: .zero)
//        iv.image = PlayerManager.main.items[indexPath.row].artworkImage
//        cell.addSubview(iv)
//        iv.snp.makeConstraints { make in
//            make.edges.equalToSuperview()
//        }
        return cell
    }
    
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)

        print("didsetletct", indexPath)
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
    
    
    
    private class HeaderView: Label {
        
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


extension HomeViewController {
    class Cell: UITableViewCell {
        
        let itemView = AudioItemView()
        
        var model = AudioModel() {
            didSet { itemView.model = model }
        }
        
        init() {
            super.init(style: .default, reuseIdentifier: nil)
            contentView.addSubview(itemView)
            itemView.snp.makeConstraints { make in
                make.edges.equalToSuperview()
            }
        }
        
        required init?(coder: NSCoder) {
            super.init(style: .default, reuseIdentifier: nil)
        }
    }
}
