//
//  ProfilePhotoUploadVC.swift
//  MyMapp
//
//  Created by Chirag Pandya on 31/10/21.
//

import UIKit
import Alamofire
import SwiftyJSON

class ProfilePhotoUploadVC: UIViewController {
    
    //MARK: - OUTLETS
    @IBOutlet weak var lblDescription: UILabel!
    @IBOutlet weak var btnTitleChangePhoto: UIButton!
    @IBOutlet weak var btnTitleAddPhoto: UIButton!
    @IBOutlet weak var imgviewPic: UIImageView!
    
    //MARK: - VARIABLES
    var imageData = Data()
    var ProfilePictureModel = ProfilePhotoUploadViewModel()
    
    //MARK: - VIEW DID LOAD
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.lblDescription.text = "Start building your travel profile!"
        
        self.btnTitleAddPhoto.setTitle("Add photo", for: .normal)
        self.btnTitleChangePhoto.isHidden = true
        self.imgviewPic.layer.cornerRadius = 0
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1, execute: {
            self.btnTitleAddPhoto.dropShadowButton()
        })
    }
    
    //MARK: - BUTTON ACTIONS
    @IBAction func btnHandlerChangePhoto(_ sender: Any){
        ImagePickerManager().pickImage(self){ image in
            self.imgviewPic.layer.cornerRadius = self.imgviewPic.frame.width / 2
            self.imageData = image.pngData()!
            self.imgviewPic.image = image
            self.btnTitleAddPhoto.setTitle("Submit photo", for: .normal)
            self.btnTitleChangePhoto.isHidden = false
            self.lblDescription.text = "You can always change this later on your personal profile! "
        }
    }
    
    @IBAction func btnHandlerSkip(sender:UIButton){
        guard let displayNameAdded = APP_USER?.displayNameAdded, displayNameAdded else {
            guard let personalDetailsVC =  UIStoryboard.authentication.personalDetailsVC else {
                return
            }
            self.navigationController?.pushViewController(personalDetailsVC, animated: true)
            return
        }
        
        appDelegateShared.setTabbarRoot()
    }
    
    @IBAction func btnHandlerAddPhoto(sender: UIButton){
        if self.imageData.count != 0{
            SHOW_CUSTOM_LOADER()
            API_SERVICES.callUploadFileAPI([:], localFilePaths: [], images: [self.imgviewPic.image!], names: ["image"], fileNames: ["image"], path: .uploadPic, method: .post) { progressValue in
                
            } success: { response in
                debugPrint(response)
                self.getUserProfile(success: response?["msg"]?.stringValue ?? "")
            } failure: { str in
                self.HIDE_CUSTOM_LOADER()
                Utility.errorMessage(message: str ?? "")
            } internetFailure: {
                Utility.errorMessage(message: "Internet failure")
            } failureInform: {
                self.HIDE_CUSTOM_LOADER()
            }
        }
        else{
            ImagePickerManager().pickImage(self){ image in
                self.imgviewPic.layer.cornerRadius = self.imgviewPic.frame.width / 2
                //self.imageData = image.pngData()!
                self.imageData  = image.lowestQualityJPEGNSData as Data
                
                self.imgviewPic.image = image
                self.btnTitleAddPhoto.setTitle("Submit photo", for: .normal)
                self.btnTitleChangePhoto.isHidden = false
                self.lblDescription.text = "You can always change this later on your personal profile! "
            }
        }
    }
    
    //MARK: - OTHER FUNCTIONS
    func getUserProfile(success:String){
        
        API_SERVICES.callAPI([:], path: .user, method: .get, encoding: JSONEncoding.default) { response in
            self.HIDE_CUSTOM_LOADER()
            Utility.successMessage(message: success)
            
            guard let status = response?["status"]?.intValue,
                  status == 200, let responseJson = response?["responseJson"] else {
                      return
                  }
            
            // here store user data model
            APP_USER = AppUser.init(loginResponse: responseJson, authToken: API_SERVICES.getAuthorization() ?? TOKEN_STATIC)
            UserManager.saveUser()
            
            appDelegateShared.checkRedirectionFlow()
        } failureInform: {
            self.HIDE_CUSTOM_LOADER()
        }
    }
}
