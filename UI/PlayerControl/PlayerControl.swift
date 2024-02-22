//
//  PlayerControl.swift
//  KKPlayer_new
//
//  Created by 强新宇 on 2024/2/15.
//

import UIKit

fileprivate let CellKey = "CellKey"


class PlayerControl: View, HomePopViewAnimate {
    
    static let shared = PlayerControl()
    
    private let contentView = ContentView()
    private let contentY: CGFloat = 70
    private let contentHeight = kScreenHeight - 70
    private var begainY: CGFloat = 0

    
    private let backgroundImageView = UIImageView()
    private let backgroundView = UIVisualEffectView(effect: UIBlurEffect(style: .light))
    
    
    private let lineView = UIView.presentLine
    
    private let audioItemView = TouchAudioItemView(hasLine: false)
    
    
    private let titleLabel = UILabel()
    private let fromLabel = UILabel()
    private let loopButton = Button(imageName: PlayerManager.loop.image)

    
    private var list: [AudioModel] {
        PlayerManager.playerList.items
    }
    private var tableView = UITableView()
    
    private let notLyricsLabel = UILabel()
    private let lyricsEditButton = Button(imageName: "icon_edit")
    private let lyricsTV = TV()
    
    
    private var isSliderTouchDown = false
    private let backward = MainThemeButton(imageName: "icon_fallback")
    private let forward = MainThemeButton(imageName: "icon_forward")
    private let slider = UISlider()
    private let currentTimeLabel = UILabel()
    private let durationLabel = UILabel()
    
    
    let nextBtn = MainThemeButton(imageName: "icon_next")
    let playPauseBtn = MainThemeSelectButton(imageName: "icon_play", selectImageName: "icon_pause")
    let previousBtn = MainThemeButton(imageName: "icon_previous")
    
    
    override func initSelf() {
        kMainWindow.addSubview(self)
        
        observer()
        
        frame = .init(x: 0, y: 0, width: kScreenWidth, height: kScreenHeight)
        alpha = 0


        
        initContentView()
        initBackground()
        initHeader()
        initLyrcs()
        initTableView()
        initTimeControl()
        initPlayerStateControl()
        
        
        refreshAudioModel()
    }
    
    
    
    
    
    static func show() {
        shared.moveAnimate(isShow: true) { _ in
            shared.contentView.y = kScreenHeight - shared.contentHeight
        }
    }
    
    static func hidden() {
        shared.moveAnimate(isShow: false) { _ in
            shared.contentView.y = kScreenHeight
        }
    }
    
    
    private func refreshAudioModel() {
        if let model = PlayerManager.currentModel {
            backgroundImageView.image = model.originalArtworkImage
            audioItemView.model = model
            
            if model.album?.isEmpty == false {
                fromLabel.text = "来自：\(model.album!)"
            } else {
                fromLabel.text = ""
            }
        }
    }
    
    
}


// MARK: Observer

extension PlayerControl {
    private func observer() {
        PlayerManager.currentModelChange {
            self.refreshAudioModel()
            
            self.tableViewScrollToPlayItem()
            
            self.loadLyrics(text: PlayerManager.currentModel?.lyrics)
        }
        
        PlayerManager.currentPlayerTimeChange {
            if !self.isSliderTouchDown {
                self.slider.value = Float(PlayerManager.currentPlayerTime)
                self.currentTimeLabel.text = PlayerManager.currentPlayerTime.minutesSecond
            }
        }
        
        /// 因为在更改current model 之前执行，所以可以相当于 will change current model 的功能
        PlayerManager.durationChange {
            self.slider.maximumValue = Float(PlayerManager.duration)
            self.durationLabel.text = PlayerManager.duration.minutesSecond
            
            self.lyricsTV.endEditing(true)
        }
        
        PlayerManager.isPlayingChange {
            self.playPauseBtn.isSelected = PlayerManager.isPlaying
        }
        
        PlayerManager.playListChange {
            self.tableView.reloadData()
            self.tableViewScrollToPlayItem()
        }
    }
}


// MARK: Background
extension PlayerControl {
    private func initBackground() {
        backgroundImageView.backgroundColor = .white
        backgroundImageView.layer.cornerRadius = 16
        backgroundImageView.layer.masksToBounds = true
        contentView.addSubview(backgroundImageView)
        backgroundImageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        backgroundView.layer.cornerRadius = 16
        backgroundView.layer.masksToBounds = true
        contentView.addSubview(backgroundView)
        backgroundView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}




// MARK: Content View

extension PlayerControl {
    private func initContentView() {
        kMainWindow.addSubview(contentView)

        contentView.pan { p in
            if let pan = p as? UIPanGestureRecognizer {
                self.handlePan(pan: pan)
            }
        }
        contentView.frame = .init(x: 0, y: kScreenHeight, width: kScreenWidth, height: contentHeight)

    }
    
    private func handlePan(pan: UIPanGestureRecognizer) {
        
        let point = pan.translation(in: kMainWindow)
        let moveY = point.y - begainY

        switch pan.state {
        case .began:
            begainY = point.y
        case .changed:
            
            if moveY > 0 {
                contentView.y = moveY + contentY
                handMovePopView(scale: moveY / contentView.height)
            }

        default:
            if moveY > contentView.height / 3 {
                PlayerControl.hidden()
            } else {
                PlayerControl.show()
            }
        }
    }
    
    private class ContentView: UIView, PanProtocol {}
}




// MARK: Header


extension PlayerControl {
    private func initHeader() {
        contentView.addSubview(lineView)
        lineView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(Theme.marginOffset)
            make.width.equalTo(lineView.width)
            make.height.equalTo(lineView.height)
        }
        
        
        audioItemView.backgroundColor = .clear
        contentView.addSubview(audioItemView)
        audioItemView.touchUpInside {
            self.exchangeListAndLyric()
        }
        audioItemView.snp.makeConstraints { make in
            make.top.equalTo(lineView.snp.bottom)
            make.left.right.equalToSuperview()
            make.height.equalTo(70)
        }
        
        titleLabel.text = "播放列表"
        contentView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(
                Theme.marginOffset)
            make.top.equalTo(audioItemView.snp.bottom)
            make.height.equalTo(30)
        }
        
        formatShadowLabel(label: fromLabel)
        contentView.addSubview(fromLabel)
        fromLabel.snp.makeConstraints { make in
            make.centerY.equalTo(titleLabel)
            make.left.greaterThanOrEqualTo(titleLabel.snp.right).offset(10)
        }
        
        loopButton.touchUpInside {
            PlayerManager.loop.next()
            self.loopButton.image = UIImage(named: PlayerManager.loop.image)
            
            if PlayerManager.loop == .single {
                self.showLyrics()
            }
        }
        loopButton.backgroundColor = .clear
        loopButton.imageEdgeInserts = .init(edges: 10)
        contentView.addSubview(loopButton)
        loopButton.snp.makeConstraints { make in
            make.width.height.equalTo(44)
            make.right.equalToSuperview()
            make.centerY.equalTo(titleLabel)
            make.left.equalTo(fromLabel.snp.right).offset(5)
        }
        
    }
}




// MARK: Lyrcs

extension PlayerControl: UITextViewDelegate {
    private func initLyrcs() {
        contentView.addSubview(lyricsTV)
        contentView.addSubview(lyricsEditButton)
        contentView.addSubview(notLyricsLabel)

        
        lyricsTV.textAlignment = .center
        lyricsTV.textColor = .T01
        lyricsTV.font = Theme.titleFont
        lyricsTV.isEditable = false
        lyricsTV.backgroundColor = .clear
        lyricsTV.delegate = self
        lyricsTV.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(5)
            make.left.right.equalToSuperview()
        }
        
        lyricsEditButton.backgroundColor = .clear
        lyricsEditButton.touchUpInside {
            self.lyricsTV.isEditable = true
            self.lyricsTV.becomeFirstResponder()
        }
        
        lyricsEditButton.imageEdgeInserts = .init(edges: 10)
        lyricsEditButton.snp.makeConstraints { make in
            make.top.right.equalTo(lyricsTV)
            make.width.height.equalTo(44)
        }
        
        notLyricsLabel.text = "暂无歌词"
        notLyricsLabel.textColor = .T02
        notLyricsLabel.textAlignment = .center
        notLyricsLabel.font = .pingFang(name: .medium, size: 32)
        notLyricsLabel.snp.makeConstraints { make in
            make.centerX.equalTo(lyricsTV)
            make.centerY.equalTo(lyricsTV).offset(-20)
        }
    }
    
    private func lyrcisEndEdit() {
        self.lyricsTV.isEditable = false
        self.lyricsTV.endEditing(true)
    }
    
    private func loadLyrics(text: String?) {
        guard let t = text else {
            lyricsTV.attributedText = nil
            notLyricsLabel.isHidden = false
            return
        }
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 10
        paragraphStyle.alignment = .center
        
        let arrt = NSMutableAttributedString(
            string: t,
            attributes:
                [
                    .font : UIFont.pingFang(size: 17),
                    .paragraphStyle: paragraphStyle
                ]
        )
        
        
        lyricsTV.attributedText = arrt
        
        notLyricsLabel.isHidden = true
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        textView.isEditable = false
        if textView.text.isEmpty {
            notLyricsLabel.isHidden = false
        } else {
            notLyricsLabel.isHidden = true
            PlayerManager.currentModel?.update(lyrics: textView.text)
        }
    }
    
  

    
    private class TV: UITextView {
        override func caretRect(for position: UITextPosition) -> CGRect {
            var superRect = super.caretRect(for: position)
            guard let font = self.font else { return superRect }

            superRect.size.height = font.pointSize - font.descender + 1
            return superRect
        }
    }
}




// MARK: TableView


extension PlayerControl: UITableViewDelegate, UITableViewDataSource {
    func initTableView() {
        contentView.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(5)
            make.left.right.equalToSuperview()
        }
        tableView.estimatedRowHeight = 0
        tableView.estimatedSectionFooterHeight = 0
        tableView.estimatedSectionHeaderHeight = 0
        tableView.alpha = 0
        
        tableView.layoutIfNeeded()
        tableView.register(Cell.self, forCellReuseIdentifier: CellKey)

        tableView.showsVerticalScrollIndicator = false
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.sectionIndexColor = .Main
        tableView.backgroundColor = .clear
        tableView.automaticallyAdjustsScrollIndicatorInsets = false
        tableView.contentInsetAdjustmentBehavior = .never
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return list.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        let cell = tableView.dequeueReusableCell(withIdentifier: CellKey, for: indexPath) as! Cell
       
        if indexPath.row < list.count {
            cell.model = list[indexPath.row]
        }

        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)

        PlayerManager.play(model: list[indexPath.row])
    }
}

fileprivate class Cell: UITableViewCell {
    
    let itemView = AudioItemView()
    
    var model = AudioModel() {
        didSet { itemView.model = model }
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(itemView)
        backgroundColor = .clear
        itemView.backgroundColor = .clear
        itemView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
  
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}





// MARK: Player Time Control

extension PlayerControl {
    private func initTimeControl() {
        contentView.addSubview(backward)
        contentView.addSubview(forward)
        contentView.addSubview(slider)
        contentView.addSubview(currentTimeLabel)
        contentView.addSubview(durationLabel)

        slider.tintColor = .Main


        slider.maximumValue = Float(PlayerManager.duration)
        slider.addTarget(self, action: #selector(sliderChange), for: .valueChanged)
        slider.addTarget(self, action: #selector(sliderEndChange), for: .touchUpInside)
        slider.addTarget(self, action: #selector(sliderEndChange), for: .touchUpOutside)

        slider.snp.makeConstraints { make in
            make.top.equalTo(tableView.snp.bottom).offset(5)
            make.top.equalTo(lyricsTV.snp.bottom).offset(5)
        }
        
        backward.touchUpInside {
            PlayerManager.backward(second: 15)
        }
        backward.backgroundColor = .clear
        backward.snp.makeConstraints { make in
            make.centerY.equalTo(slider)
            make.left.equalToSuperview().offset(Theme.marginOffset)
            make.width.height.equalTo(44)
            make.right.equalTo(slider.snp.left).offset(-2)
        }
        
        forward.touchUpInside {
            PlayerManager.forward(second: 15)
        }
        forward.backgroundColor = .clear
        forward.snp.makeConstraints { make in
            make.centerY.equalTo(slider)
            make.right.equalToSuperview().offset(-Theme.marginOffset)
            make.width.height.equalTo(44)
            make.left.equalTo(slider.snp.right).offset(2)
        }
        
        currentTimeLabel.text = PlayerManager.currentPlayerTime.minutesSecond
        formatShadowLabel(label: currentTimeLabel)
        currentTimeLabel.snp.makeConstraints { make in
            make.left.equalTo(slider.snp.left)
            make.top.equalTo(slider.snp.bottom).offset(5)
        }
        
        durationLabel.text = PlayerManager.duration.minutesSecond
        formatShadowLabel(label: durationLabel)
        durationLabel.snp.makeConstraints { make in
            make.right.equalTo(slider.snp.right)
            make.centerY.equalTo(currentTimeLabel)
         }
        
    }
    
    private func formatShadowLabel(label: UILabel) {
        label.layer.shadowColor = UIColor.white.cgColor
        label.layer.shadowOpacity = 1
        label.layer.shadowRadius = 12
        label.layer.shadowOffset = .init(width: 0, height: 0)
        label.font = .pingFang(size: 12)
        label.textColor = .T01
    }
    
  
    
    @objc func sliderChange() {
        isSliderTouchDown = true
        self.currentTimeLabel.text = TimeInterval(slider.value).minutesSecond
    }
    
    @objc func sliderEndChange() {
        isSliderTouchDown = false
        PlayerManager.seek(to: TimeInterval(slider.value))
    }
    
}


// MARK: Player State Control
extension PlayerControl {
    private func initPlayerStateControl() {
        contentView.addSubview(previousBtn)
        contentView.addSubview(playPauseBtn)
        contentView.addSubview(nextBtn)
        
        
        previousBtn.touchUpInside {
            PlayerManager.previous()
        }
        previousBtn.backgroundColor = .clear
        previousBtn.snp.makeConstraints { make in
            make.width.height.equalTo(44)
            make.left.equalToSuperview().offset(60)
            make.bottom.equalToSuperview().offset(-kMainWindow.safeAreaInsets.bottom)
            make.top.equalTo(currentTimeLabel.snp.bottom).offset(5)
        }
        
        
        playPauseBtn.isSelected = PlayerManager.isPlaying
        playPauseBtn.touchUpInside {
            PlayerManager.clickPlayPauseButton()
        }
        playPauseBtn.backgroundColor = .clear
        playPauseBtn.snp.makeConstraints { make in
            make.width.height.equalTo(44)
            make.centerY.equalTo(previousBtn)
            make.centerX.equalToSuperview()
        }
        
        
        nextBtn.touchUpInside {
            PlayerManager.next()
        }
        nextBtn.backgroundColor = .clear
        nextBtn.snp.makeConstraints { make in
            make.width.height.equalTo(44)
            make.right.equalToSuperview().offset(-60)
            make.centerY.equalTo(previousBtn)
        }
    }
}





// MARK: Uitls

extension PlayerControl {
    private func exchangeListAndLyric() {
        let tableViewIsShow = tableView.alpha == 1
        tableViewIsShow ? showLyrics() : showTableView()
        
        lyrcisEndEdit()
    }
    
    private func showTableView() {
        if list.isEmpty {
            return
        }
        self.tableViewScrollToPlayItem()

        UIView.animate(withDuration: 0.4) {
            self.tableView.alpha = 1
            self.lyricsTV.alpha = 0
            self.notLyricsLabel.alpha = 0
            self.lyricsEditButton.alpha = 0
        }
    }
    private func showLyrics() {
        UIView.animate(withDuration: 0.4) {
            self.tableView.alpha = 0
            self.lyricsTV.alpha = 1
            self.notLyricsLabel.alpha = 1
            self.lyricsEditButton.alpha = 1
        }
    }
    
    private func tableViewScrollToPlayItem() {
        tableView.scrollTo(item: PlayerManager.currentModel, list: list)
    }
}



class TouchAudioItemView: AudioItemView, TapProtocol {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        if touch.view != self {
            return false
        }
        return true
    }
    
}
