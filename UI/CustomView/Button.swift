//
//  Button.swift
//  KKPlayer_new
//
//  Created by 强新宇 on 2024/2/17.
//

import UIKit

open class Button: ImageTextComponent, TapProtocol {
    public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        if touch.view != self {
            return false
        }
        return true
    }
    
    
    var oldTitleColor: UIColor?
    
    var isEnable = true {
        didSet {
            if !isEnable {
                imageView?.tintColor = .gray
                oldTitleColor = label?.textColor
                label?.textColor = .gray
            } else {
                imageView?.tintColor = .Main
                label?.textColor = oldTitleColor
            }
        }
    }
    var isShowTouchState = true
    
    public func touchUpInside(touch: @escaping () -> Void) {
        let tap = UITapGestureRecognizer {[weak self] _ in
            if self?.isEnable == true {
                touch()
            }
        }
        tap.delegate = self
        addGestureRecognizer(tap)
    }
    
    func touchUpInside(touch: @escaping UIGestureRecognizer.Touch) {
        let tap = UITapGestureRecognizer {[weak self] ges in
            if self?.isEnable == true {
                touch(ges)
            }
        }
        tap.delegate = self
        addGestureRecognizer(tap)
    }
    
    open override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if isShowTouchState, isEnable {
            alpha = Theme.touchAlpha
        }
    }
    
    open override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if isEnable {
            alpha = 1
        }
    }
    
    open override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        if isShowTouchState, isEnable {
            alpha = 1
        }
    }
}



open class SelectButton: Button {
    init(imageName: String, selectImageName: String) {
        super.init(imageName: imageName)
        selectedImage = .init(named: selectImageName)
    }
    init(title: String, selectTitle: String) {
        super.init(title: title)
        selectedTitle = selectTitle
    }
    
    override init() {
        super.init()
        initSelf()
    }
    
    required public init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    override var title: String? {
        didSet { refresh() }
    }
    override var image: UIImage? {
        didSet { refresh() }
    }
    
    var selectedTitle: String? = nil {
        didSet { refresh() }
    }
    var selectedImage: UIImage? = nil {
        didSet { refresh() }
    }
    
    open var isSelected = false {
        didSet { refresh() }
    }
    
    
    func refresh() {
        label?.text = isSelected ? selectedTitle : title
        imageView?.image = isSelected ? selectedImage : image
    }
}



open class MainThemeButton: Button {
    override func initSelf() {
        super.initSelf()
        
        isMainTheme = true
    }
}


open class MainThemeSelectButton: SelectButton {
    override func initSelf() {
        super.initSelf()
        
        isMainTheme = true
    }
}


open class SaveButton: Button {
    override func initSelf() {
        super.initSelf()
        
        backgroundColor = .Main
        label?.textColor = .white
        layer.cornerRadius = 8
        layer.masksToBounds = true

        MainColorChange {[weak self] in
            self?.backgroundColor = .Main
        }
    }
    
    func snpMake() {
        snp.makeConstraints { make in
            make.bottom.equalToSuperview().offset(-kMainWindow.safeAreaInsets.bottom)
            make.height.equalTo(44)
            make.left.equalToSuperview().offset(30)
            make.right.equalToSuperview().offset(-30)
        }
    }
}
