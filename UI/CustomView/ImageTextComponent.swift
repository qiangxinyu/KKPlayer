//
//  Button.swift
//  KKPlayer_new
//
//  Created by 强新宇 on 24/2/15.
//

import UIKit


open class ImageTextComponent: UIView {
    enum Style {
        case text
        case image
        
        /// 图片在文字上面
        case imageTop
        case imageLeft
        case imageBottom
        case imageRight
    }
    
    
    private override init(frame: CGRect) {
        super.init(frame: frame)
    }
    init() {
        super.init(frame: .zero)
    }
    public required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    
    init(title: String) {
        self.title = title
        super.init(frame: .zero)
        style = .text
        initSelf()
    }
    
    init(imageName: String) {
        image = UIImage(named: imageName)
        super.init(frame: .zero)
        style = .image
        initSelf()
    }
    init(style: Style) {
        self.style = style
        super.init(frame: .zero)
        initSelf()
    }

    
    init(style: Style, title: String? = nil, imageName: String? = nil) {
        self.style = style
        super.init(frame: .zero)
        self.title = title
        if let imageName = imageName {
            image = .init(named: imageName)
        }
        initSelf()
    }
    
    var style = Style.text {
        didSet { settingStyle() }
    }
    
 
    var title: String? = nil {
        didSet { label?.text = title }
    }
    var image: UIImage? = nil {
        didSet { imageView?.image = image }
    }
    
    lazy var label: UILabel? = { initLabel() }()
    lazy var imageView: UIImageView? = { initImageView() }()
    {
        didSet {
            if imageView != nil {
                imageView?.contentMode = .scaleAspectFit
                imageView?.clipsToBounds = true
                addSubview(imageView!)
            }
            
        }
    }
    
    var titleEdgeInserts: UIEdgeInsets = .zero {
        didSet { settingStyle() }
    }
    var imageEdgeInserts: UIEdgeInsets = .zero {
        didSet { settingStyle() }
    }
    
    /// 跟随主题色  不可逆
    lazy var isMainTheme: Bool = {
       false
    }() {
        didSet {
            if isMainTheme {
                imageView?.tintColor = .Main
                label?.textColor = .Main
                
                MainColorChange { [weak self] in
                    self?.imageView?.tintColor = .Main
                    self?.label?.textColor = .Main
                }
            }
        }
    }


    
    func initSelf() {
        backgroundColor = .white
        settingStyle()
    }
    
    private func settingStyle() {
        switch style {
        case .text:
            label?.text = title
            label?.snp.removeConstraints()
            label?.snp.makeConstraints({ make in
                make.top.equalToSuperview().offset(titleEdgeInserts.top)
                make.left.equalToSuperview().offset(titleEdgeInserts.left)
                make.right.equalToSuperview().offset(-titleEdgeInserts.right)
                make.bottom.equalToSuperview().offset(-titleEdgeInserts.bottom)
                make.height.greaterThanOrEqualTo(1)
                make.width.greaterThanOrEqualTo(1)
            })
        case .image:
            imageView?.image = image
            imageView?.snp.removeConstraints()
            imageView?.snp.makeConstraints({ make in
                make.top.equalToSuperview().offset(imageEdgeInserts.top)
                make.left.equalToSuperview().offset(imageEdgeInserts.left)
                make.right.equalToSuperview().offset(-imageEdgeInserts.right)
                make.bottom.equalToSuperview().offset(-imageEdgeInserts.bottom)
            })
        case .imageTop:
            imageView?.image = image
            imageView?.snp.removeConstraints()
            label?.text = title
            label?.snp.removeConstraints()

            imageView?.snp.makeConstraints({ make in
                make.top.equalToSuperview().offset(imageEdgeInserts.top)
                make.left.equalToSuperview().offset(imageEdgeInserts.left)
                make.right.equalToSuperview().offset(-imageEdgeInserts.right)
                make.aspectRatio(1, view: imageView!)

            })
            label?.snp.makeConstraints({ make in
                make.top.equalTo(imageView!.snp.bottom).offset(titleEdgeInserts.top + imageEdgeInserts.bottom)
                make.left.equalToSuperview().offset(titleEdgeInserts.left)
                make.right.equalToSuperview().offset(-titleEdgeInserts.right)
                make.bottom.equalToSuperview().offset(-titleEdgeInserts.bottom)
                make.height.greaterThanOrEqualTo(1)
                make.width.greaterThanOrEqualTo(1)
                
            })
        case .imageLeft:
            
            imageView?.image = image
            imageView?.snp.removeConstraints()
            label?.text = title
            label?.snp.removeConstraints()
            
            imageView?.snp.makeConstraints({ make in
                make.top.equalToSuperview().offset(imageEdgeInserts.top)
                make.left.equalToSuperview().offset(imageEdgeInserts.left)
                make.bottom.equalToSuperview().offset(-imageEdgeInserts.bottom)
                make.aspectRatio(1, view: imageView!)
            })
            
            
            
            label?.snp.makeConstraints({ make in
                make.top.equalToSuperview().offset(titleEdgeInserts.top)
                make.left.equalTo(imageView!.snp.right).offset(titleEdgeInserts.left + imageEdgeInserts.right)
                make.right.equalToSuperview().offset(-titleEdgeInserts.right)
                make.bottom.equalToSuperview().offset(-titleEdgeInserts.bottom)
                make.height.greaterThanOrEqualTo(1)
                make.width.greaterThanOrEqualTo(1)
            })
        case .imageBottom:
            imageView?.image = image
            imageView?.snp.removeConstraints()
            label?.text = title
            label?.snp.removeConstraints()
            
            imageView?.snp.makeConstraints({ make in
                make.left.equalToSuperview().offset(imageEdgeInserts.left)
                make.right.equalToSuperview().offset(-imageEdgeInserts.right)
                make.bottom.equalToSuperview().offset(-imageEdgeInserts.bottom)
                make.aspectRatio(1, view: imageView!)

            })
            
            
            label?.snp.makeConstraints({ make in
                make.top.equalToSuperview().offset(titleEdgeInserts.top)
                make.left.equalToSuperview().offset(titleEdgeInserts.left)
                make.right.equalToSuperview().offset(-titleEdgeInserts.right)
                make.bottom.equalTo(imageView!.snp.top).offset(-titleEdgeInserts.bottom - imageEdgeInserts.top)
                make.height.greaterThanOrEqualTo(1)
                make.width.greaterThanOrEqualTo(1)
            })
        case .imageRight:
            imageView?.image = image
            imageView?.snp.removeConstraints()
            label?.text = title
            label?.snp.removeConstraints()
            
            imageView?.snp.makeConstraints({ make in
                make.top.equalToSuperview().offset(imageEdgeInserts.top)
                make.right.equalToSuperview().offset(-imageEdgeInserts.right)
                make.bottom.equalToSuperview().offset(-imageEdgeInserts.bottom)
                make.aspectRatio(1, view: imageView!)
            })
            
            
            label?.snp.makeConstraints({ make in
                make.top.equalToSuperview().offset(titleEdgeInserts.top)
                make.left.equalToSuperview().offset(titleEdgeInserts.left)
                make.right.equalTo(imageView!.snp.left).offset(-titleEdgeInserts.right - imageEdgeInserts.left)
                make.bottom.equalToSuperview().offset(-titleEdgeInserts.bottom)
                make.height.greaterThanOrEqualTo(1)
                make.width.greaterThanOrEqualTo(1)            })
        }
    }
    
    private func initLabel() -> UILabel {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = .T01
        label.font = Theme.titleFont
        addSubview(label)
        return label
    }
    
    private func initImageView() -> UIImageView {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        addSubview(imageView)
        return imageView
    }
}


class MainThemeImageTextComponent: ImageTextComponent {
    override func initSelf() {
        super.initSelf()
        isMainTheme = true
    }
}
