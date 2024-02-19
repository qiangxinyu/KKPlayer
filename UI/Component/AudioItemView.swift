//
//  AudioItemView.swift
//  KKPlayer_new
//
//  Created by 强新宇 on 2024/2/16.
//

import UIKit


class AudioItemView: UIView {
    var model = AudioModel() {
        didSet {
            artwork.image = model.artworkImage ?? UIImage(named: "icon_default_artwork")
            name.text = model.name
            artist.text = model.artist
            if model.playCount > 1000 {
                let a = Float(model.playCount) / 1000
                playCount.title = String(format: "%.1fk", a)
            } else {
                playCount.title = "\(model.playCount)"
            }
        }
    }
    
    private let artwork = MainThemeImageView()
    private let name = UILabel()
    private let artist = UILabel()
    private let playCount = ImageTextComponent(style: .imageLeft, imageName: "play_count")
    private let more = Button(imageName: "icon_more")
    private let line = UIView()

    private var hasLine = true
    
    init(hasLine: Bool = true) {
        super.init(frame: .zero)
        self.hasLine = hasLine
        initSelf()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    func initSelf() {
        
        backgroundColor = .white
        addSubview(artwork)
        addSubview(playCount)
        addSubview(more)
        
        let contentView = UIView()
        addSubview(contentView)
        contentView.addSubview(name)
        contentView.addSubview(artist)

        
        artwork.layer.cornerRadius = 4
        artwork.layer.masksToBounds = true
        artwork.backgroundColor = .P01
        artwork.snp.makeConstraints { make in
            make.left.equalTo(Theme.marginOffset)
            make.top.equalTo(2)
            make.bottom.equalTo(-2)
            make.aspectRatio(1, view: artwork)
        }
        
        
        contentView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalTo(artwork.snp.right).offset(8)
            make.right.equalTo(playCount.snp.left).offset(-12)
        }
        
        name.font = .pingFang(name: .medium, size: 16)
        name.adjustsFontSizeToFitWidth = true
        name.minimumScaleFactor = 0.1
        name.snp.makeConstraints { make in
            make.right.top.left.equalToSuperview()
            make.bottom.equalTo(artist.snp.top)
        }
        
        
        artist.font = .pingFang(size: 12)
        artist.adjustsFontSizeToFitWidth = true
        artist.minimumScaleFactor = 0.1
        artist.snp.makeConstraints { make in
            make.right.left.bottom.equalToSuperview()

        }
        
        playCount.label?.textAlignment = .left
        playCount.backgroundColor = .clear
        playCount.titleEdgeInserts = .init(top: 0, left: 0, bottom: 0, right: 5)
        playCount.imageEdgeInserts = .init(top: 10, left: 0, bottom: 10, right: 0)
        
        playCount.label?.textColor = .Main
        playCount.label?.font = .pingFang(size: 10)
        playCount.snp.makeConstraints { make in
            make.right.equalTo(more.snp.left)
            make.height.equalTo(40)
            make.width.equalTo(50)
            make.centerY.equalToSuperview()
        }

        
        more.backgroundColor = .clear
        more.imageEdgeInserts = .init(edges: 10)
        more.snp.makeConstraints { make in
            make.right.equalToSuperview()
            make.width.height.equalTo(44)
            make.centerY.equalToSuperview()
        }
        
        if hasLine {
            addSubview(line)
            line.backgroundColor = .T02
            line.snp.makeConstraints { make in
                make.bottom.equalToSuperview()
                make.right.equalToSuperview()
                make.left.equalTo(artwork.snp.right).offset(4)
                make.height.equalTo(0.5)
            }
        }
    }
    
    
}
