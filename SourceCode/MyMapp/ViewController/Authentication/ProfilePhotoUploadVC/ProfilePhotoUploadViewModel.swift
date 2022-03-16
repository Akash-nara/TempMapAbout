//
//  LoginViewModel.swift
//  TASK TAP
//
//  Created by ZB_Mac_Mini on 12/11/21.
//

import Foundation
import SwiftyJSON

class ProfilePhotoUploadViewModel {
    
    /*
    // MARK: - API Call
    func profilePictureUpload(param: [String: Any], imageData:Data, success: @escaping (JSON) -> Void, failure: @escaping (_ errorResponse: (JSON)) -> Void){
        
        ServiceManager.shared.postMultipartRequestWithHeader(apiURL: .uploadPic, imageVideoParameters: [ServiceManager.multiPartDataType(fileData: imageData, keyName: "image")], parameters: param, isShowLoader: true, isPassHeader: true, isShowErrorAlerts: true) { response, isSuccess, error, statusCode, headerToken in
            
            let status = response["status"].stringValue
            if status == "200"{
                var Auth = ""
                Auth = headerToken!
                let newString = Auth.replacingOccurrences(of: "Bearer ", with: "", options: .literal, range: nil)
                print(newString)
                
                if appDelegateShared.isKeyPresentInUserDefaults(key: "authToken"){
                    appDelegateShared.authToken = newString
                    UserDefaults.standard.set(appDelegateShared.authToken, forKey: "authToken")
                    UserDefaults.standard.synchronize()
                }else{
                    appDelegateShared.authToken = newString
                    UserDefaults.standard.set(appDelegateShared.authToken, forKey: "authToken")
                    UserDefaults.standard.synchronize()
                }
            }
            success(response)
        } Failure: { response, isSuccess, error, statusCode, headerToken in
            failure(response)
        }
    }*/
}
