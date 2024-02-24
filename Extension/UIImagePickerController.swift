//
//  UIImagePickerController.swift
//  KKPlayer_new
//
//  Created by 强新宇 on 2024/2/21.
//

import UIKit

extension UIImagePickerController {
    static func openPhotos(viewConroller: (UIViewController & UIImagePickerControllerDelegate & UINavigationControllerDelegate)?) {
        guard let vc = viewConroller else {return}
        let pickerController = UIImagePickerController()
        pickerController.delegate = vc
        pickerController.allowsEditing = true
        pickerController.mediaTypes = ["public.image"]
        
        vc.present(pickerController, animated: true)
    }
}
