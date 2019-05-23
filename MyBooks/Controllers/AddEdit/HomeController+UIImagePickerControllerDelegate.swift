//
//  HomeController+UIImagePickerControllerDelegate.swift
//  MyBooks
//
//  Created by Ahmad Abduljawad on 23/05/2019.
//  Copyright © 2019 Test. All rights reserved.
//


import UIKit

extension AddEditController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any])
    {
        // Local variable inserted by Swift 4.2 migrator.
        let info = convertFromUIImagePickerControllerInfoKeyDictionary(info)
        
        
        if let chosenImage:UIImage = info[convertFromUIImagePickerControllerInfoKey(UIImagePickerController.InfoKey.editedImage)] as? UIImage {
            
            guard let imgData = chosenImage.pngData() else {
                dismiss(animated:true, completion: nil)
                return
            }
            
            let mBytes = imgData.count / (1024 * 1024)
            print("uploaded imageSize \(mBytes) MB")
            
            // check if image size exceed 2 MB.
            var resizedImg: UIImage!
            if mBytes > 2 {
                // resize selected image to 2 MB as maximum,
                resizedImg = chosenImage.resize(CGSize(width: view.bounds.size.height, height: view.bounds.size.height))
            } else {
                resizedImg = chosenImage
            }
            guard let resizedImgData = resizedImg.pngData() else {
                dismiss(animated:true, completion: nil)
                return
            }
            bookData.cover = resizedImgData
            coverImgView.image = resizedImg
            dismiss(animated: true)
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}

extension AddEditController {
    
    func presentUploadOptionsAlert(_ sender: UIButton) {
        
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let libraryAlertAction = UIAlertAction(title : NSLocalizedString("Photo Library", comment: ""), style : .default) { action in
            self.showImageController(sourceType: 0)
        }
        let camAlertAction = UIAlertAction(title : NSLocalizedString("Camera", comment: ""), style : .default) { action in
            self.showImageController(sourceType: 1)
        }
        let cancelAlertAction = UIAlertAction(title : NSLocalizedString("Cancel", comment: "") , style : .default) { action in
            alertController.dismiss(animated: true)
        }
        alertController.addAction(libraryAlertAction)
        alertController.addAction(camAlertAction)
        alertController.addAction(cancelAlertAction)
        let popPresenter = alertController.popoverPresentationController
        popPresenter?.sourceView = sender
        popPresenter?.sourceRect = sender.bounds
        self.present(alertController, animated: true)
    }
    
    func showImageController(sourceType:Int) {
        let picker:UIImagePickerController = UIImagePickerController()
        picker.delegate = self
        picker.allowsEditing = true
        switch sourceType {
        case 0:
            picker.sourceType = .photoLibrary
        case 1:
            picker.sourceType = .camera
        default:
            picker.sourceType = .photoLibrary
        }
        present(picker, animated: true, completion: nil)
    }
    
    // Helper function inserted by Swift 4.2 migrator.
    fileprivate func convertFromUIImagePickerControllerInfoKeyDictionary(_ input: [UIImagePickerController.InfoKey: Any]) -> [String: Any] {
        return Dictionary(uniqueKeysWithValues: input.map {key, value in (key.rawValue, value)})
    }
    
    // Helper function inserted by Swift 4.2 migrator.
    fileprivate func convertFromUIImagePickerControllerInfoKey(_ input: UIImagePickerController.InfoKey) -> String {
        return input.rawValue
    }
}
