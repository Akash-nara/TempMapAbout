//
//  LoginViewModel.swift
//  TASK TAP
//
//  Created by ZB_Mac_Mini on 12/11/21.
//

import Foundation
import SwiftyJSON

class LoginViewModel {
    
    // MARK: - API Call
    func loginApi(_ param: [String: Any], successBlock: @escaping (String)->()) {
        
        SHOW_CUSTOM_LOADER()
        API_SERVICES.setAuthorization(TOKEN_STATIC, isNeedPrefixAddBearer: false)
        API_SERVICES.callAPI(param, path: .signIn, method: .post) { (parsingResponse) in
            HIDE_CUSTOM_LOADER()
            
            debugPrint("response: \(parsingResponse)")
            guard let status = parsingResponse?["status"]?.intValue,
                  status == 200, let responseJson = parsingResponse?["responseJson"] else {
                      Utility.errorMessage(message: parsingResponse?["msg"]?.stringValue ?? "")
                      return
                  }
            
            // here store user data model
            APP_USER = AppUser.init(loginResponse: responseJson, authToken: API_SERVICES.getAuthorization() ?? TOKEN_STATIC)
            UserManager.saveUser()
            UserManager.storeCertifUser(APP_USER)
            
            successBlock(parsingResponse?["msg"]?.stringValue ?? "")
        } failureInform: {
            HIDE_CUSTOM_LOADER()
        }
    }    
}
