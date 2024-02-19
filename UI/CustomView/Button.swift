//
//  Button.swift
//  KKPlayer_new
//
//  Created by 强新宇 on 2024/2/17.
//

import UIKit

class Button: ImageTextComponent, TapProtocol {
    var isShowTouchState = true

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if isShowTouchState {
            alpha = Theme.touchAlpha
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        alpha = 1
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        if isShowTouchState {
            alpha = 1
        }
    }
}



class SelectButton: Button {
    init(imageName: String, selectImageName: String) {
        super.init(imageName: imageName)
        selectedImage = .init(named: selectImageName)
    }
    
    required init?(coder: NSCoder) {
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
    
    var isSelected = false {
        didSet { refresh() }
    }
    
    
    private func refresh() {
        label?.text = isSelected ? selectedTitle : title
        imageView?.image = isSelected ? selectedImage : image
    }
}



class MainThemeButton: Button {
    
}


class MainThemeSelectButton: SelectButton {
    
}
