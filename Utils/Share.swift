//
//  Share.swift
//  KKPlayer_new
//
//  Created by 强新宇 on 2024/2/20.
//

import UIKit

class Share {
    static func share(models: [AudioModel]) {
        if models.count > 50 {
            TipView.show("别一下分享这么多，你考虑过手机的感受吗？？？")
            return
        }
        
        let urls = models.map { $0.path.url }
        
        let activityController = UIActivityViewController(
                activityItems: urls,
                applicationActivities: nil)
        DispatchQueue.main.async {
            HomeViewController.shared.present(activityController, animated: true, completion: nil)
        }
    }
}
