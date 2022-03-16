//
//  LoginViewModel.swift
//  TASK TAP
//
//  Created by ZB_Mac_Mini on 12/11/21.
//

import Foundation
import SwiftyJSON

class PersonalDetailsViewModel {
    
    // MARK: - API Call
    func getCityListAPI(param: [String: Any], success: @escaping ([String:JSON]?) -> Void, failure: @escaping (_ errorResponse: ()?) -> Void){
        
        API_SERVICES.callAPI(param, path: .cityList, method: .post) { responseJson in
            success(responseJson)
        } failure: { str in
            Utility.errorMessage(message: str ?? "Something went to wrong")
        }
    }
}
