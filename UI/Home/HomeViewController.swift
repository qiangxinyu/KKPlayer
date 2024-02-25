//
//  HomeVC.swift
//  KKPlayer_new
//
//  Created by 强新宇 on 2024/2/15.
//

import UIKit

fileprivate let searchBarHeight: CGFloat = 50
fileprivate let navigationBarHeight = searchBarHeight + kNavigationHeight
fileprivate let tableViewContentInsertTop = navigationBarHeight
fileprivate let CellKey = "CellKey"

class HomeViewController: ViewController {
    static let shared = HomeViewController()
    
    var status = Status.default {
        didSet { statusChange() }
    }
    
    override var title: String? {
        didSet { navigationBar.title = title }
    }
    
    private(set) var selectList = [AudioModel]()
    
    private let navigationBar = NaviBar()
    
    private let headerView = HeaderView()
    private let tableView = UITableView()
    
    private let feedbackGenerator = UISelectionFeedbackGenerator()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        refreshScreenInfo()
  
        observer()
        HomeDataSource.refreshItems()
        
        initList()
        initNavigationBar()
    }
}



// MARK: Status

extension HomeViewController {
    enum Status {
        case `default`
        case select
    }
    
    private func statusChange() {
        navigationBar.status = status
        notSelectAllItems()
        title = ""
    }
    
    func selectAllItems() {
        selectList = HomeDataSource.items
        selectListChange()
    }
    
    func notSelectAllItems() {
        selectList = []
        selectListChange()
    }
    
    private func selectListChange() {
        tableView.reloadData()
        title = "已选中 \(selectList.count) 首"
        navigationBar.allSelectButton.isSelected = HomeDataSource.items.count > 0 && selectList.count == HomeDataSource.items.count
        navigationBar.moreButton.isEnable = !selectList.isEmpty
    }
}



// MARK: NavigationBar

extension HomeViewController {
    
    private func initNavigationBar() {
        view.addSubview(navigationBar)
        navigationBar.snp.makeConstraints { make in
            make.top.left.right.equalToSuperview()
            make.height.equalTo(navigationBarHeight)
        }
    }
}


fileprivate class NaviBar: View, UISearchBarDelegate, UIDocumentPickerDelegate {
    fileprivate var status = HomeViewController.Status.default {
        didSet { changeStatus() }
    }
    
    private let backgroundView = UIVisualEffectView(effect: UIBlurEffect(style: .light))
    
    private let label = UILabel()
    private let myButton = MainThemeButton(imageName: "icon_my")
    let lineView = UIView()
    
    private let searchBar = UISearchBar()
    private let importButton = MainThemeButton(imageName: "icon_import")
    private let sortButton = MainThemeButton(imageName: "icon_sort")
    
    
    var title: String? {
        didSet {  label.text = title }
    }
    
    private lazy var sortMenuView = {SortMenuView()}()
    private(set) lazy var moreButton = {
        let btn = MainThemeButton(imageName: "icon_more")
        self.addSubview(btn)
        btn.imageEdgeInserts = .init(edges: 10)
        btn.backgroundColor = .clear
        btn.snp.makeConstraints { make in
            make.centerY.equalTo(myButton)
            make.right.equalTo(sortButton.snp.left)
            make.height.equalTo(myButton)
        }
        btn.touchUpInside {
            AudioMenuView.show(ges: $0, list: HomeViewController.shared.selectList)
        }
        return btn
    }()
    private lazy var exitButton = {
        let btn = MainThemeButton(title: "退出")
        self.addSubview(btn)
        btn.backgroundColor = .clear
        btn.snp.makeConstraints { make in
            make.centerY.equalTo(myButton)
            make.left.equalTo(allSelectButton.snp.right)
            make.width.height.equalTo(myButton)
        }
        
        btn.touchUpInside {
            HomeViewController.shared.status = .default
        }
        return btn
    }()
    
    private(set) lazy var allSelectButton = {
        let btn = MainThemeSelectButton(title: "全选", selectTitle: "取消全选")
        self.addSubview(btn)
        btn.backgroundColor = .clear
        btn.snp.makeConstraints { make in
            make.centerY.equalTo(myButton)
            make.height.equalTo(myButton)
            make.left.equalTo(Theme.marginOffset)
            make.width.equalTo(70)
        }
        btn.touchUpInside {
            btn.isSelected = !btn.isSelected
            if btn.isSelected {
                HomeViewController.shared.selectAllItems()
            } else {
                HomeViewController.shared.notSelectAllItems()
            }
        }
        return btn
    }()
    
    override func initSelf() {
        addSubview(backgroundView)
        addSubview(label)
        addSubview(myButton)
        addSubview(searchBar)
        addSubview(importButton)
        addSubview(sortButton)

        
        label.font = .pingFang(size: 14)
        label.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalTo(myButton)
        }
        
        backgroundView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        myButton.touchUpInside {
            HomeViewController.shared.present(SettingViewController.shared, animated: true)
        }
        
        myButton.backgroundColor = .clear
        myButton.snp.makeConstraints { make in
            make.width.height.equalTo(44)
            make.bottom.equalTo(searchBar.snp.top)
        }
        
        
        sortButton.touchUpInside {
            self.sortMenuView.show(ges: $0)
        }
        sortButton.backgroundColor = .clear
        sortButton.imageEdgeInserts = .init(edges: 10)
        sortButton.snp.makeConstraints { make in
            make.width.height.equalTo(44)
            make.centerY.equalTo(myButton)
            make.right.equalToSuperview()
        }
        
        importButton.touchUpInside {
            let controller = UIDocumentPickerViewController(documentTypes: ["public.mp3"], in: .import)
            controller.delegate = self
            controller.allowsMultipleSelection = true
            

            HomeViewController.shared.present(controller,animated: true) {
                controller.allowsMultipleSelection = true
            }
        }
        importButton.backgroundColor = .clear
        importButton.imageEdgeInserts = .init(edges: 10)
        importButton.snp.makeConstraints { make in
            make.width.height.equalTo(44)
            make.right.equalTo(sortButton.snp.left)
            make.centerY.equalTo(myButton)
        }
        
        searchBar.delegate = self
        searchBar.placeholder = "搜索歌名、歌手、专辑"
        searchBar.backgroundImage = .init()
        searchBar.tintColor = .Main
        searchBar.snp.makeConstraints { make in
            make.bottom.equalToSuperview()
            make.left.right.equalToSuperview()
            make.height.equalTo(searchBarHeight)
        }
        
        
        addSubview(lineView)
        lineView.isHidden = true
        lineView.backgroundColor = .HEX("AEAEAE")
        lineView.snp.makeConstraints { make in
            make.height.equalTo(0.5)
            make.left.right.equalToSuperview()
            make.bottom.equalToSuperview()
        }
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.setShowsCancelButton(true, animated: true)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        HomeDataSource.keyword = searchText
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        endEditing(true)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.setShowsCancelButton(false, animated: true)
        endEditing(true)
        
        HomeDataSource.keyword = nil
        searchBar.text = ""
    }
    
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        AudioFileQueue.push(audioList: urls)
    }
    
    private func changeStatus() {
        switch status {
        case .default:
            myButton.isHidden = false
        case .select:
            myButton.isHidden = true
        }
        
        importButton.isHidden = myButton.isHidden
        moreButton.isHidden = !myButton.isHidden
        exitButton.isHidden = !myButton.isHidden
        allSelectButton.isHidden = !myButton.isHidden
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
        
        tableView.contentInsetAdjustmentBehavior = .never
        tableView.contentInset = .init(top: navigationBarHeight, left: 0, bottom: kMainWindow.safeAreaInsets.bottom + 60 + 10, right: 0)

        tableView.register(Cell.self, forCellReuseIdentifier: CellKey)
        
        tableView.layoutIfNeeded()
        
        tableView.showsVerticalScrollIndicator = false
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.sectionIndexColor = .Main
        tableView.tableHeaderView = headerView
    }
 
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.y > -tableViewContentInsertTop, navigationBar.lineView.isHidden {
            navigationBar.lineView.isHidden = false
        }

        if  scrollView.contentOffset.y <= -tableViewContentInsertTop, navigationBar.lineView.isHidden == false {
            navigationBar.lineView.isHidden = true
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }

    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return HomeDataSource.items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: CellKey) as! Cell

        cell.status = status
        if indexPath.row < HomeDataSource.items.count {
            cell.model = HomeDataSource.items[indexPath.row]
        }
        
        if status == .select {
            cell.isSelect = selectList.contains(cell.model)
        }
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)

        let model = HomeDataSource.items[indexPath.row]
        switch status {
        case .default:
            PlayerManager.play(model: model, list: HomeDataSource.items)

        case .select:
            if let index = selectList.firstIndex(of: model) {
                selectList.remove(at: index)
            } else {
                selectList.append(model)
            }
            selectListChange()
        }
    }
    
    func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        return HomeDataSource.sortKeys
    }

    func tableView(_ tableView: UITableView, sectionForSectionIndexTitle title: String, at index: Int) -> Int {
        feedbackGenerator.selectionChanged()
        tableView.scrollToRow(at: .init(row: HomeDataSource.sortIndexs[index], section: 0), at: .top, animated: true)
        return index
    }
}

fileprivate class HeaderView: Label {
    
    var count: Int = 0 {
        didSet {  text = "歌曲数：\(count)" }
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

fileprivate class Cell: UITableViewCell {
    
    fileprivate var status = HomeViewController.Status.default {
        didSet {
            itemView.status = status
        }
    }
    
    /// 不要用系统的 isSelected
    var isSelect: Bool = false {
        didSet {
            itemView.isSelected = isSelect
        }
    }
    
    var itemView = AudioItemView()
    
    var model = AudioModel() {
        didSet { itemView.model = model }
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = .white
        contentView.addSubview(itemView)
        itemView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("")
    }
}


// MARK: Observer

extension HomeViewController {
    private func observer() {
        PlayerManager.currentModelChange {
            self.tableView.scrollTo(item: PlayerManager.currentModel, list: HomeDataSource.items)
        }
        
        HomeDataSource.itemsChange {
            self.headerView.count = HomeDataSource.items.count
            self.tableView.reloadData()
        }
    }
}


// MARK: Sort Menu View

fileprivate class SortMenuView: MenuView {
    
    private var lastSelectView: SelectButton? = nil
    
    override func initSelf() {
        super.initSelf()
        
        let itemWidth: CGFloat = 200
        let itemHeight: CGFloat = 44
        
        contentView.width = itemWidth
        
        
        var y: CGFloat = 0
        
        let selectButton = createButton(title: "选择")
        contentView.addSubview(selectButton)
        selectButton.frame = .init(x: 0, y: y, width: itemWidth, height: itemHeight)

        selectButton.touchUpInside {
            HomeViewController.shared.status = .select
            self.hidden()
        }
        
        HomeDataSource.Sort.list.forEach { sort in
            y += (itemHeight + 1)
            let item = createButton(title: sort.name + (sort.ascending ? "↑" : "↓"))
            item.frame = .init(x: 0, y: y, width: itemWidth, height: itemHeight)
            contentView.addSubview(item)
            
            if sort == HomeDataSource.sort {
                item.isSelected = true
                self.lastSelectView = item
            }
            
            item.touchUpInside {
                if HomeDataSource.sort == sort {
                    self.hidden()
                    return
                }
                
                HomeDataSource.sort = sort
                self.lastSelectView?.isSelected = false
                item.isSelected = true
                self.lastSelectView = item
                self.hidden()
            }
        }
        
        contentView.height = y - 1
    }
    
    private func createButton(title: String) -> SelectButton {
        let button = SelectButton()
        button.imageView = MainThemeImageView()
        button.backgroundColor = .white
        button.style = .imageLeft
        button.selectedImage = UIImage(named: "icon_yes")
        button.label?.textAlignment = .left
        button.imageEdgeInserts = .init(edges: 10)
        button.title = title
        button.selectedTitle = title
        
        
        return button
    }
}
