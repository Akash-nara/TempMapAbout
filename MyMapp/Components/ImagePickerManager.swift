//
//  ImagePickerManager.swift
//  foodberry-driver
//
//  Created by Mac on 11/12/20.
//  Copyright © 2020 ZestBrains PVT LTD. All rights reserved.
//
import Foundation
import UIKit
import Photos
import CropViewController
import WXImageCompress
import QuartzCore

class ImagePickerManager: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    var picker = UIImagePickerController();
    var alert = UIAlertController(title: "Choose image", message: nil, preferredStyle: .actionSheet)
    
    var viewController: UIViewController?
    var pickImageCallback : ((UIImage) -> ())?;
    
    override init(){
        super.init()
        let galleryAction = UIAlertAction(title: "Select from camera roll", style: .default){
            UIAlertAction in
            self.openGallery()
        }
        let cameraAction = UIAlertAction(title: "Take photo", style: .default){
            UIAlertAction in
            self.cameraAuthorization()
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel){
            UIAlertAction in
        }
        
        // Add the actions
        picker.delegate = self
        alert.view.tintColor = UIColor.App_BG_SecondaryDark2_Color
        alert.addAction(cameraAction)
        alert.addAction(galleryAction)
        alert.addAction(cancelAction)
    }
    
    func pickImage(_ viewController: UIViewController, _ callback: @escaping ((UIImage) -> ())) {
        pickImageCallback = callback;
        self.viewController = viewController;
        
        alert.popoverPresentationController?.sourceView = self.viewController!.view
        
        viewController.present(alert, animated: true, completion: nil)
    }
    
    func cameraAuthorization(){
        
        DispatchQueue.main.async {
            self.alert.dismiss(animated: true, completion: nil)
        }
        
        let authStatus = AVCaptureDevice.authorizationStatus(for: AVMediaType.video)
        switch (authStatus){
        case .restricted, .denied:
            self.showPermisionAlert(type:"Camera")
            
        case .authorized:
            self.cameraOpen()
        case .notDetermined:
            print("notDetermined")
            AVCaptureDevice.requestAccess(for: .video, completionHandler: { (granted: Bool) in
                if granted {
                    //access allowed
                    self.cameraOpen()
                } else {
                    //access denied
                    self.cameraAuthorization()
                }
            })
        @unknown default:
            print("notDetermined")
        }
    }
    
    func cameraOpen(){
        DispatchQueue.main.async { [self] in
            self.alert.dismiss(animated: true, completion: nil)
            if(UIImagePickerController .isSourceTypeAvailable(.camera)){
                self.picker.sourceType = .camera
                self.picker.allowsEditing = false
                //to stop parent viewcontroller dismiss
                self.viewController!.definesPresentationContext = true
                self.picker.modalPresentationStyle = .overFullScreen
                self.viewController!.present(self.picker, animated: true, completion: nil)
            } else {
//                showAlert(title: "Warning".localized as NSString, message: "You don't have camera")
                return
            }
        }
    }
    
    func openGallery(){
        alert.dismiss(animated: true, completion: nil)
        
        PHPhotoLibrary.requestAuthorization { [weak self] result in
            guard let self = self else { return }
            if result == .authorized {
                DispatchQueue.main.async {
                    self.picker.sourceType = .photoLibrary
                    self.picker.allowsEditing = false
                    //to stop parent viewcontroller dismiss
                    self.viewController!.present(self.picker, animated: true, completion: nil)
                }
            } else {
                DispatchQueue.main.async {
                    self.showPermisionAlert(type:"")
                }
            }
        }
    }
    
    func showPermisionAlert(type:String) {
        alert = UIAlertController(title: appName, message: "Please check to see if device settings doesn't allow photo library or camera access.", preferredStyle: .alert)
        let settingsAction = UIAlertAction(title: "Settings", style: .default) { (_) -> Void in
            
            guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else { return }
            
            if UIApplication.shared.canOpenURL(settingsUrl) {
                UIApplication.shared.open(settingsUrl, completionHandler: { (success) in
                    print("Settings opened: \(success)") // Prints true
                })
            }
        }
        
        alert.addAction(settingsAction)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        DispatchQueue.main.async{
            self.viewController?.present(self.alert, animated: true, completion: nil)
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let chosenImage:UIImage = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
        picker.dismiss(animated: true, completion: nil)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            let cropController:CropViewController = CropViewController(image: chosenImage)
            cropController.delegate = self
            cropController.aspectRatioPreset = .presetSquare
            cropController.aspectRatioLockEnabled = true
            cropController.aspectRatioPickerButtonHidden = true
            
            if #available(iOS 13.0, *) {
                cropController.modalPresentationStyle = .fullScreen
            }
            
            self.viewController?.present(cropController, animated: true, completion: nil)
        }
    }
    
    @objc func imagePickerController(_ picker: UIImagePickerController, pickedImage: UIImage?) {
    }
}

extension ImagePickerManager : CropViewControllerDelegate {
    func cropViewController(_ cropViewController: CropViewController, didCropToImage image: UIImage, withRect cropRect: CGRect, angle: Int){
        
        cropViewController.dismiss(animated: true, completion:{
            //var Tempimage = image.wxCompress().pngData()
            let Tempimage = image.jpeg(.lowest)
            print(Tempimage?.count)
            self.pickImageCallback?(image.wxCompress())
            // self.pickImageCallback?(image)
        })
    }
}

extension UIImage{
    var highestQualityJPEGNSData: NSData { return self.jpegData(compressionQuality: 1.0)! as NSData }
    var highQualityJPEGNSData: NSData    { return self.jpegData(compressionQuality: 0.75)! as NSData}
    var mediumQualityJPEGNSData: NSData  { return self.jpegData(compressionQuality: 0.5)! as NSData }
    var lowQualityJPEGNSData: NSData     { return self.jpegData(compressionQuality: 0.25)! as NSData}
    var lowestQualityJPEGNSData: NSData  { return self.jpegData(compressionQuality: 0.0)! as NSData }
}
