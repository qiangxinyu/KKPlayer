//
//  SettingThemeColorViewController.swift
//  KKPlayer_new
//
//  Created by 强新宇 on 2024/2/22.
//

import UIKit

class SettingThemeColorViewController: PresentViewController {
    private let colors = ["FF0000", "FFFF00", "00FF00", "00FFFF", "0000FF", "FF00FF", "FF0000"]
        
    var currentHSB = HSBA(1, 1, 1, 1)
    
    
    private let colorView = HSBColorPicker()
    private let HSlider = UISlider()
    private let HEXATF = UITextField()
    
    private let RItemView = ItemView()
    private let GItemView = ItemView()
    private let BItemView = ItemView()
    private let AItemView = ItemView()

    private let saveButton = SaveButton(title: "确定")

    private var oldHEXA: String? = nil

    private let maxCount = 10
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        currentHSB = .init(UIColor.Main.HSBA)
        
        
        initHSBViews()
        initRGBAViews()
        
        initHSBChange()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {[weak self] in
            self?.initOldColors()
        }
        
        initSaveButton()
        
        refreshHSBHEXA()
        refreshRGBA()
    }
    
    private func refreshHSBHEXA() {
        refreshColorViewBG()
        refreshColorViewPoint()
        refreshHEXATF()
        refreshHSlider()
    }
    
    private func refreshHEXATF() {
        let color = currentHSB.color
        HEXATF.text = color.HEXA
    }
    
    private func refreshColorViewPoint() {
        colorView.settingCenter(S: currentHSB.S, B: currentHSB.B)
    }
    
    private func refreshColorViewBG() {
        colorView.backgroundColor = UIColor(hue: currentHSB.H, saturation: 1, brightness: 1, alpha: 1)
    }
    private func refreshHSlider() {
        HSlider.value = Float(currentHSB.H)
    }
    
    
    
    private func refreshRGBA(){
        refreshRGB()
        refreshAlpha()
    }
    
    private func refreshRGB() {
        let (r, g, b, _) = currentHSB.color.RGBA
        RItemView.value = r
        GItemView.value = g
        BItemView.value = b
    }
    
    private func refreshAlpha() {
        let (_, _, _, a) = currentHSB.color.RGBA
        AItemView.value = a
    }
    
}

// MARK: HSB HEX
extension SettingThemeColorViewController {
    private func initHSBViews() {
        view.addSubview(colorView)
        colorView.snp.makeConstraints { make in
            make.left.equalTo(Theme.marginOffset)
            make.right.equalTo(-Theme.marginOffset)
            make.height.equalTo(150)
            make.top.equalTo(lineView.snp.bottom).offset(Theme.marginOffset)
        }
        
        
        
        HSlider.maximumValue = 1
        HSlider.addTarget(self, action: #selector(HSliderValueChange), for: .valueChanged)
        HSlider.tintColor = .clear
        view.addSubview(HSlider)
        HSlider.snp.makeConstraints { make in
            make.top.equalTo(colorView.snp.bottom).offset(12)
            make.left.equalTo(Theme.marginOffset)
        }
        
        
        formatTextFiled(HEXATF)
        view.addSubview(HEXATF)
        HEXATF.snp.makeConstraints { make in
            make.right.equalTo(-Theme.marginOffset)
            make.centerY.equalTo(HSlider)
            make.left.equalTo(HSlider.snp.right).offset(5)
            make.width.equalTo(100)
        }
    }
    
    private func initHSBChange() {
        colorView.SBChange = {[weak self] S, B in
            self?.currentHSB.S = S
            self?.currentHSB.B = B
            self?.refreshHEXATF()
            self?.refreshRGBA()
        }
        colorView.layoutIfNeeded()
        colorView.initFrame()
        
        HSlider.layoutIfNeeded()
        HSlider.settingGradientColor(
            hexs: colors,
            mode: .toRight,
            frame: .init(
                x: 3,
                y: HSlider.height / 2 - 2.5,
                width: HSlider.width - 6,
                height: 5
            ),
            cornerRadius: 2.5
        )
    }
}


// MARK: RGB
extension SettingThemeColorViewController {
    private func initRGBAViews() {
        view.addSubview(RItemView)
        view.addSubview(GItemView)
        view.addSubview(BItemView)
        view.addSubview(AItemView)
        
        RItemView.title = "Red"
        GItemView.title = "Green"
        BItemView.title = "Blue"
        AItemView.title = "Alpha"

        RItemView.valueChangeBlock = {[weak self] red in
            self?.rgbaToHSBA()
        }
        
        GItemView.valueChangeBlock = {[weak self] green in
            self?.rgbaToHSBA()
        }
        
        BItemView.valueChangeBlock = {[weak self] blue in
            self?.rgbaToHSBA()
        }
        
        AItemView.valueChangeBlock = {[weak self] alpha in
            self?.currentHSB.A = CGFloat(alpha)
            self?.refreshHEXATF()
        }
        
        let itemHeight = 44

        RItemView.snp.makeConstraints { make in
            make.height.equalTo(itemHeight)
            make.left.right.equalToSuperview()
            make.top.equalTo(HSlider.snp.bottom).offset(10)
        }
        
        GItemView.snp.makeConstraints { make in
            make.height.equalTo(itemHeight)
            make.left.right.equalToSuperview()
            make.top.equalTo(RItemView.snp.bottom).offset(5)
        }
        
        BItemView.snp.makeConstraints { make in
            make.height.equalTo(itemHeight)
            make.left.right.equalToSuperview()
            make.top.equalTo(GItemView.snp.bottom).offset(5)
        }
        
        AItemView.snp.makeConstraints { make in
            make.height.equalTo(itemHeight)
            make.left.right.equalToSuperview()
            make.top.equalTo(BItemView.snp.bottom).offset(5)
        }
    }
    
    private func rgbaToHSBA() {
        let color = UIColor(
                            red: RItemView.value,
                            green: GItemView.value,
                            blue: BItemView.value,
                            alpha: AItemView.value
                        )
        
        
        currentHSB = .init(color.HSBA)
        
        refreshHSBHEXA()
    }
    
    class ItemView: View, UITextFieldDelegate {
        private let titleLabel = UILabel()
        private let slider = UISlider()
        private let textInput = UITextField()
        private var oldText: String? = nil
        
        var title: String? {
            set { titleLabel.text = newValue }
            get { titleLabel.text }
        }
        
        var value: CGFloat {
            set {
                slider.value = Float(newValue)
                textInput.text = "\(Int(value * 255))"
            }
            get { CGFloat(slider.value) }
        }
        
        override func initSelf() {
            addSubview(titleLabel)
            addSubview(slider)
            addSubview(textInput)
            
            textInput.borderStyle = .roundedRect
            textInput.font = .pingFang(size: 14)
            textInput.textAlignment = .center
            textInput.delegate = self
            textInput.keyboardType = .numberPad
            
            titleLabel.snp.makeConstraints { make in
                make.left.equalTo(Theme.marginOffset)
                make.width.equalTo(50)
                make.centerY.equalToSuperview()
            }
            
            slider.maximumValue = 1
            slider.addTarget(self, action: #selector(valueChange), for: .valueChanged)
            slider.snp.makeConstraints { make in
                make.centerY.equalToSuperview()
                make.left.equalTo(titleLabel.snp.right).offset(10)
                make.right.equalTo(textInput.snp.left).offset(-10)
            }
            
            textInput.snp.makeConstraints { make in
                make.centerY.equalToSuperview()
                make.right.equalTo(-Theme.marginOffset)
                make.width.equalTo(100)
            }
        }
        var valueChangeBlock: ((Float) -> Void)? = nil
        @objc func valueChange() {
            valueChangeBlock?(slider.value)
            textInput.text = "\(Int(slider.value * 255))"
        }
        
        func textFieldDidBeginEditing(_ textField: UITextField) {
            oldText = textField.text
        }
        
        func textFieldDidEndEditing(_ textField: UITextField) {
            guard let newText = textField.text,
                  let number = Int(newText),
                  number >= 0, number <= 255 else {
                TipView.show("不正确的格式")
                textField.text = oldText
                return
            }
            
            slider.value = Float(number) / 255
            valueChangeBlock?(slider.value)
        }
    }
}

// MARK: Slider
extension SettingThemeColorViewController {
    @objc func HSliderValueChange() {
        currentHSB.H = CGFloat(HSlider.value)
        refreshColorViewBG()
        refreshHEXATF()
        refreshRGBA()
    }
}

// MARK: Text Field

extension SettingThemeColorViewController: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        oldHEXA = textField.text
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        guard let value = textField.text else {
            TipView.show("不正确的格式")
            textField.text = oldHEXA
            return
        }
        
        
        let hexa = value.replacingOccurrences(of: "#", with: "").uppercased()
        
        if hexa.count != 8, !hexa.isHEXA {
            TipView.show("不正确的格式")
            textField.text = oldHEXA
            return
        }
        
        let color = UIColor.HEXA(hexa)
        
        let (h, s, b, a) = color.HSBA
        
        currentHSB = .init(h, s, b, a)
        refreshColorViewBG()
        refreshHSlider()
        refreshColorViewPoint()
        
        refreshRGBA()
        
        textField.text = "#" + hexa
    }
    
    private func formatTextFiled(_ tf: UITextField) {
        tf.borderStyle = .roundedRect
        tf.font = .pingFang(size: 14)
        tf.textAlignment = .center
        tf.delegate = self
    }
}




struct HSBA {
    var H: CGFloat
    var S: CGFloat
    var B: CGFloat
    var A: CGFloat
    
    var color: UIColor {
        .init(hue: H, saturation: S, brightness: B, alpha: A)
    }
    
    init(_ H: CGFloat, _ S: CGFloat, _ B: CGFloat, _ A: CGFloat) {
        self.H = H
        self.S = S
        self.B = B
        self.A = A
    }
    
    init(_ hsba: (CGFloat, CGFloat, CGFloat, CGFloat)) {
        self.H = hsba.0
        self.S = hsba.1
        self.B = hsba.2
        self.A = hsba.3
    }
}


// MARK: old colors
extension SettingThemeColorViewController {
    private func initOldColors() {
        AItemView.layoutIfNeeded()
        
        let HEXAList = UserDefaultsUtils.themeColor

        let itemSpace: CGFloat = 10
        let offset = Theme.marginOffset
        let itemWidth = CGFloat((view.width - offset * 2 - itemSpace * (CGFloat(maxCount) - 1)) / CGFloat(maxCount))
        
        let y = AItemView.frame.maxY + 40
        var x = offset


        for HEXA in HEXAList {
            let colorV = Button()
            colorV.frame = .init(x: x, y: y, width: itemWidth, height: itemWidth)
            view.addSubview(colorV)
            colorV.backgroundColor = .HEXA(HEXA)
            x += itemWidth + itemSpace
            
            colorV.touchUpInside {[weak self] in
                
                self?.currentHSB = .init(colorV.backgroundColor!.HSBA)
                self?.refreshHSBHEXA()
                self?.refreshRGBA()
            }
        }
    }
}


// MARK: Save

extension SettingThemeColorViewController {
    private func initSaveButton() {
        view.addSubview(saveButton)
        saveButton.snpMake()
        
        saveButton.touchUpInside { [weak self] in
            self?.clickSave()
        }
    }
    
    private func clickSave() {
        let color = currentHSB.color
        
        UIColor.Main = color
        PostMainColorChnage()
        
        var list = UserDefaultsUtils.themeColor

        if list.count >= maxCount {
            list.removeLast()
        }
        list.insert(color.HEXA, at: 0)
        UserDefaultsUtils.themeColor = list
        
        dismiss(animated: true)
    }
}
