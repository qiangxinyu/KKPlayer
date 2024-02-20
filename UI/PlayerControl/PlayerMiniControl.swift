//
//  MiniPlayerControl.swift
//  KKPlayer_new
//
//  Created by 强新宇 on 2024/2/15.
//

import UIKit

class PlayerMiniControl: Button {
    
    private let artwork = MainThemeImageView()
    private let name = UILabel()
    private let playPauseButton = SelectButton(imageName: "icon_play", selectImageName: "icon_pause")
    private let nextButton = Button(imageName: "icon_next")

    override init() {
        super.init()
        
        PlayerManager.currentModelChange {
            self.artwork.image = PlayerManager.currentModel?.artworkImage ?? UIImage(named: "icon_default_artwork")
            self.name.text = PlayerManager.currentModel?.name
        }
        
        PlayerManager.isPlayingChange {
            self.playPauseButton.isSelected = PlayerManager.isPlaying
        }
        
        playPauseButton.touchUpInside {
            PlayerManager.clickPlayPauseButton()
        }
        
        nextButton.touchUpInside {
            PlayerManager.next()
        }
        
        isShowTouchState = false
        
        layer.cornerRadius = 12
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.5
        layer.shadowOffset = CGSize(width: 0, height: 0)
        layer.shadowRadius = 10

        backgroundColor = .B03
        
        addSubview(artwork)
        addSubview(name)
        addSubview(playPauseButton)
        addSubview(nextButton)

        artwork.layer.cornerRadius = 4
        artwork.layer.masksToBounds = true
        artwork.backgroundColor = .white
        artwork.snp.makeConstraints { make in
            make.left.equalTo(Theme.marginOffset)
            make.top.equalTo(8)
            make.bottom.equalTo(-8)
            make.aspectRatio(1, view: artwork)
        }
        
        
        name.font = .pingFang(name: .medium, size: 16)
        name.adjustsFontSizeToFitWidth = true
        name.minimumScaleFactor = 0.1
        name.snp.makeConstraints { make in
            make.centerY.equalTo(artwork)
            make.left.equalTo(artwork.snp.right).offset(8)
            make.right.equalTo(playPauseButton.snp.left).offset(12)
        }
        
        
        playPauseButton.imageEdgeInserts = .init(edges: 10)
        playPauseButton.backgroundColor = .clear
        playPauseButton.snp.makeConstraints { make in
            make.right.equalTo(nextButton.snp.left)
            make.centerY.equalTo(artwork)
            make.width.height.equalTo(44)
        }
        
        nextButton.imageEdgeInserts = .init(edges: 10)
        nextButton.backgroundColor = .clear
        nextButton.snp.makeConstraints { make in
            make.width.height.equalTo(44)
            make.right.equalToSuperview().offset(-5)
            make.centerY.equalTo(artwork)
        }
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}
