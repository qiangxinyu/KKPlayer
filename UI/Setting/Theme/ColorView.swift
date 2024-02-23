//
//  ColorView.swift
//  KKPlayer
//
//  Created by 强新宇 on 2022/11/2.
//

import UIKit


class HSBColorPicker : View, TapProtocol, PanProtocol {
    var SBChange: ((CGFloat, CGFloat) -> Void)?
    
    private let sView = UIView()
    private let bView = UIView()
    private let pointView = UIImageView(frame: .init(x: 0, y: 0, width: 30, height: 30))

    override func initSelf() {
        clipsToBounds = true

        
        addSubview(sView)
        sView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        

        
        addSubview(bView)
        bView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        
        addSubview(pointView)
        
        pointView.image = UIImage(named: "color_picker_select")
        pointView.contentMode = .center
        
        
        pan {[weak self] ges in
            self?.settingPoint(ges)
        }
        
        touchUpInside {[weak self] ges in
            self?.settingPoint(ges)
        }
    }
    
    func initFrame() {
        sView.layoutIfNeeded()
        sView.settingGradientColor(hexas: ["#FFFFFFFF", "#FFFFFF00"], mode: .toRight)
        
        bView.layoutIfNeeded()
        bView.settingGradientColor(hexas: ["000000FF", "00000000"], mode: .toTop)
    }
    
    private func settingPoint(_ ges: UIGestureRecognizer) {
        var newPoint = ges.location(in: self)
        newPoint.x = min(width, max(0, newPoint.x))
        newPoint.y = min(height, max(0, newPoint.y))

        pointView.center = newPoint
        
        SBChange?(newPoint.x / width, 1 - (newPoint.y / height))
    }
    

    func settingCenter(S: CGFloat, B: CGFloat) {
        pointView.center = CGPoint(x: width * S, y: height * (1 - B))
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        return true
    }
}
