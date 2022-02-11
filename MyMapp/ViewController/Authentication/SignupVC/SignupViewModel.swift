//
//  LoginViewModel.swift
//  TASK TAP
//
//  Created by ZB_Mac_Mini on 12/11/21.
//

import Foundation
import SwiftyJSON

class SignupViewModel {
    
    // MARK: - API Call
    func signupAPI(_ param: [String: Any], successBlock: @escaping (String)->()) {
        
        
        API_LOADER.SHOW_CUSTOM_LOADER()
        API_SERVICES.setAuthorization(TOKEN_STATIC)
        API_SERVICES.callAPI(param, path: .signUP, method: .post) { (parsingResponse) in
            API_LOADER.HIDE_CUSTOM_LOADER()
            debugPrint("response: \(parsingResponse)")
            
            guard let status = parsingResponse?["status"]?.intValue,
                  status == 200 else {
                      Utility.errorMessage(message: parsingResponse?["msg"]?.stringValue ?? "")
                      return
                  }
            successBlock(parsingResponse?["msg"]?.stringValue ?? "")
        }
    }
}
