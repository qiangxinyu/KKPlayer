//
//  UIAlertController.swift
//  Player_New
//
//  Created by 强新宇 on 2024/2/6.
//

import UIKit


extension UIAlertController {
    static func showDeleteAlert(
        title: String,
        message: String? = nil,
        sureText: String = "确定",
        sureBlock: ((UIAlertAction) -> Void)? = nil,
        cancelText: String = "取消",
        cancelBlock: ((UIAlertAction) -> Void)? = nil)
    {
        DispatchQueue.main.async {
            let alertVC = UIAlertController(title: title, message: message, preferredStyle: .alert)
            alertVC.addAction(UIAlertAction(title: cancelText, style: .default, handler: cancelBlock))
            alertVC.addAction(UIAlertAction(title: sureText, style: .destructive, handler: sureBlock))
            
            showAlert(vc: alertVC)
        }
    }
    
    
    static func showDeleteAlert1(
        title: String,
        message: String? = nil,
        sureText: String = "替换",
        sureBlock: ((UIAlertAction) -> Void)? = nil,
        sureText1: String = "同时存在",
        sureBlock1: ((UIAlertAction) -> Void)? = nil,
        cancelText: String = "取消",
        cancelBlock: ((UIAlertAction) -> Void)? = nil)
    {
        DispatchQueue.main.async {
            let control = UIAlertController(title: title, message: message, preferredStyle: .alert)
            
            control.addAction(UIAlertAction(title: cancelText, style: .default, handler: cancelBlock))
            control.addAction(UIAlertAction(title: sureText, style: .destructive, handler: sureBlock))
            
            control.addAction(UIAlertAction(title: sureText1, style: .destructive, handler: sureBlock1))
            
            showAlert(vc: control)
        }
    }
    
    
    static func show(
        title: String,
        message: String? = nil,
        sureText: String = "明白了",
        sureBlock: ((UIAlertAction) -> Void)? = nil)
    {
        
        DispatchQueue.main.async {
            let control = UIAlertController(title: title, message: message, preferredStyle: .alert)
            control.addAction(UIAlertAction(title: sureText, style: .destructive, handler: sureBlock))
            
            showAlert(vc: control)
        }
    }
    
    
    private static func showAlert(vc: UIAlertController) {
        currentVC(vc: kMainWindow.rootViewController)?.present(vc, animated: true, completion: nil)
    }
    
    private static func currentVC(vc: UIViewController?) -> UIViewController? {
        if let next = vc?.presentedViewController {
            return next
        }
        return vc
    }
}
