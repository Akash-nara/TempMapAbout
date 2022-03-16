////
////  ServiceManager.swift
////  DemoServiceManage
////
////  Created by Zestbrains on 11/06/21.
////
//
//import UIKit
//import Alamofire
//import SwiftyJSON
//import Foundation
//
//
//typealias APIResponseBlock = ((_ response: JSON,_ isSuccess: Bool,_ error: String ,_ statusCode : Int?)->())
//typealias APIResponseBlockWithHeader = ((_ response: JSON,_ isSuccess: Bool,_ error: String ,_ statusCode : Int,_ headerToken : String?)->())
//typealias APIResponseBlockWithStatusCode = ((_ response: NSDictionary?,_ isSuccess: Bool,_ error: String? ,_ statusCode : Int?)->())
//typealias APIFailureResponseBlock = ((_ response: NSDictionary?,_ isSuccess: Bool,_ error: String? ,_ statusCode : Int?)->())
//
//
//enum apiURL {
//    case none
//    case baseURL
//    case login
//    case reset
//    case blank
//    case is_display_name_unique
//    case signup
//    case uploadPic
//    case get_user
//    case user
//    case cityList
//    case add
//
//    func strURL() -> String {
//        var str : String  = ""
//
//        switch self {
//        case .none :
//            return ""
//        case .baseURL:
//            return ""
//        case .login:
//            str = "http://54.160.11.28:8081/api/public/signin"
//        case .reset:
//            return "http://54.160.11.28:8081/api/public/forgotPassword"
//        case .is_display_name_unique:
//            str = "http://54.160.11.28:8081/api/private/user/is-display-name-unique?displayName="
//        case .signup:
//            return "http://54.160.11.28:8081/api/public/signup"
//        case .uploadPic:
//            str = "http://54.160.11.28:8081/api/private/user/uploadPic"
//        case .get_user:
//            str = "http://54.160.11.28:8081/api/private/user/get-user"
//        case .user:
//            str = "http://54.160.11.28:8081/api/private/user"
//        case .cityList:
//            str = "http://54.160.11.28:8081/api/private/config/cityList"
//        case .add:
//            str = "http://54.160.11.28:8081/api/private/trip/add"
//        case .blank:
//            str = ""
//
//
//
//        }
//
//        return apiURL.baseURL.strURL() + str
//    }
//}
//
//
//
//class ServiceManager: NSObject {
//
//    static let shared : ServiceManager = ServiceManager()
//    let manager: Session
//
//    var headers: HTTPHeaders  {
//        let header : HTTPHeaders = ["Authorization" : "Bearer" +  " " + appDelegateShared.authToken,"Content-Type":"application/x-www-form-urlencoded"]
//        return header
//    }
//    var paramEncode: ParameterEncoding = URLEncoding.default
//
//    override init() {
//
//        let configuration = URLSessionConfiguration.default
//        configuration.timeoutIntervalForRequest = 60*2
//        configuration.timeoutIntervalForResource = 60*2
//
//        manager = Session(configuration: configuration)
//
//        super.init()
//    }
//
//
//
//    func postRequest(apiURL : apiURL , strURLAdd : String = "",
//                     parameters : [String: Any] ,
//                     isShowLoader : Bool = true,
//                     isPassHeader : Bool = true,
//                     isShowErrorAlerts : Bool = true,
//                     Success successBlock:@escaping APIResponseBlock,
//                     Failure failureBlock:@escaping APIResponseBlock) {
//
//        do {
//
//            if ServiceManager.checkInterNet() == false
//            {
//                Utility.errorMessage(message: LocalValidation.checkInternetConnection)
//                return
//            }
//
//            if isShowLoader
//            {
//                SHOW_CUSTOM_LOADER()
//
//            }
//
//
//            var header : HTTPHeaders = []
//            if isPassHeader {
//                header = self.headers
//            }
//
//            if ServiceManager.checkInterNet() {
//
//                let url = try getFullUrl(relPath: apiURL.strURL() + strURLAdd)
//
//                //printing headers and parametes
//                printStart(header: header ,Parameter: parameters , url: url)
//
//                _ = manager.request(url, method: .post, parameters: parameters, encoding: paramEncode, headers: header).responseJSON(completionHandler: { (resObj) in
//
//                    HIDE_CUSTOM_LOADER()
//
//                    self.printSucess(json: resObj)
//
//                    //  print(resObj.response?.headers)
//
//
//                    let statusCode = resObj.response?.statusCode ?? 0
//
//                    switch resObj.result {
//                    case .success(let json) :
//                        print("SuccessJSON \(json)")
//
//                        self.handleSucess(json: json, statusCode: statusCode, isShowErrorAlerts: isShowErrorAlerts, Success: successBlock, Failure: failureBlock)
//
//                    case .failure(let err) :
//                        print(err)
//
//                        if let data = resObj.data, let str = String(data: data, encoding: String.Encoding.utf8){
//                            print("Server Error: " + str)
//                        }
//
//                        self.handleFailure(json: "", error: err, statusCode: statusCode, isShowErrorAlerts: isShowErrorAlerts, Success: successBlock, Failure: failureBlock)
//                    }
//
//                })
//            }
//
//        }catch let error {
//            self.jprint(items: error)
//            HIDE_CUSTOM_LOADER()
//        }
//    }
//
//
//    func getRequest(apiURL : apiURL ,
//                    parameters : [String: Any] ,
//                    isShowLoader : Bool = true,
//                    isPassHeader : Bool = true,
//                    isShowErrorAlerts : Bool = true,
//                    valuePass : URL,
//                    Success successBlock:@escaping APIResponseBlock,
//                    Failure failureBlock:@escaping APIResponseBlock) {
//
//        do {
//
//            if ServiceManager.checkInterNet() == false
//            {
//                Utility.errorMessage(message: LocalValidation.checkInternetConnection)
//                return
//            }
//
//
//            if isShowLoader {
//                SHOW_CUSTOM_LOADER()
//            }
//
//            var header : HTTPHeaders = []
//            if isPassHeader {
//                header = self.headers
//            }
//
//            if ServiceManager.checkInterNet() {
//
//                let url = try getFullUrl(relPath: apiURL.strURL())
//
//                //printing headers and parametes
//                printStart(header: header ,Parameter: parameters , url: url)
//
//                _ = manager.request(url, method: .get, parameters: parameters, encoding: paramEncode, headers: header).responseJSON(completionHandler: { (resObj) in
//
//                    HIDE_CUSTOM_LOADER()
//
//                    self.printSucess(json: resObj)
//
//                    let statusCode = resObj.response?.statusCode ?? 0
//
//                    switch resObj.result {
//                    case .success(let json) :
//                        print("SuccessJSON \(json)")
//
//                        self.handleSucess(json: json, statusCode: statusCode, isShowErrorAlerts: isShowErrorAlerts, Success: successBlock, Failure: failureBlock)
//
//                    case .failure(let err) :
//                        print(err)
//
//                        if let data = resObj.data, let str = String(data: data, encoding: String.Encoding.utf8){
//                            print("Server Error: " + str)
//                        }
//
//                        self.handleFailure(json: "", error: err, statusCode: statusCode, isShowErrorAlerts: isShowErrorAlerts, Success: successBlock, Failure: failureBlock)
//                    }
//
//                })
//            }
//
//        }catch let error {
//            self.jprint(items: error)
//            HIDE_CUSTOM_LOADER()
//        }
//    }
//
//    func postRequestForGetToken(apiURL : apiURL , strURLAdd : String = "",
//                                parameters : [String: Any] ,
//                                isShowLoader : Bool = true,
//                                isPassHeader : Bool = true,
//                                isShowErrorAlerts : Bool = true,
//                                headerToken : String = "",
//                                Success successBlock:@escaping APIResponseBlockWithHeader,
//                                Failure failureBlock:@escaping APIResponseBlockWithHeader)
//    {
//
//        do {
//
//            if ServiceManager.checkInterNet() == false
//            {
//                Utility.errorMessage(message: LocalValidation.checkInternetConnection)
//                return
//            }
//
//            if isShowLoader {
//                SHOW_CUSTOM_LOADER()
//            }
//
//            var header : HTTPHeaders = []
//            if isPassHeader {
//                header = self.headers
//            }
//
//
//
//            if ServiceManager.checkInterNet() {
//
//                let url = try getFullUrl(relPath: apiURL.strURL() + strURLAdd)
//
//                //printing headers and parametes
//                printStart(header: header ,Parameter: parameters , url: url)
//
//                _ = manager.request(url, method: .post, parameters: parameters, encoding: paramEncode, headers: header).responseJSON(completionHandler: { (resObj) in
//
//                    HIDE_CUSTOM_LOADER()
//
//                    self.printSucess(json: resObj)
//
//
//
//                    var AuthToken = ""
//                    if resObj.response?.headers != nil
//                    {
//                        if resObj.response?.headers["Authorization"] != nil
//                        {
//                            AuthToken = (resObj.response?.headers["Authorization"]) as! String
//                        }
//                        print(resObj.response?.headers["Authorization"])
//
//                    }
//
//
//                    let statusCode = resObj.response?.statusCode ?? 0
//
//                    switch resObj.result {
//                    case .success(let json) :
//                        print("SuccessJSON \(json)")
//
//                        self.handleSucessForGetToken(json: json, statusCode: statusCode, headerToken: AuthToken, Success: successBlock, Failure: failureBlock)
//
//
//                    case .failure(let err) :
//                        print(err)
//
//                        if let data = resObj.data, let str = String(data: data, encoding: String.Encoding.utf8){
//                            print("Server Error: " + str)
//                        }
//
//                        self.handleFailureForGetToken(json: "", error: err, statusCode: statusCode, headerToken: AuthToken, Success: successBlock, Failure: failureBlock)
//
//                    }
//
//                })
//            }
//
//        }catch let error {
//            self.jprint(items: error)
//            HIDE_CUSTOM_LOADER()
//        }
//    }
//
//
//    func patchRequestForGetToken(apiURL : apiURL , strURLAdd : String = "",
//                                parameters : [String: Any] ,
//                                isShowLoader : Bool = true,
//                                isPassHeader : Bool = true,
//                                isShowErrorAlerts : Bool = true,
//                                headerToken : String = "",
//                                Success successBlock:@escaping APIResponseBlockWithHeader,
//                                Failure failureBlock:@escaping APIResponseBlockWithHeader)
//    {
//
//        do {
//
//            if ServiceManager.checkInterNet() == false
//            {
//                Utility.errorMessage(message: LocalValidation.checkInternetConnection)
//                return
//            }
//
//            if isShowLoader {
//                SHOW_CUSTOM_LOADER()
//            }
//
//            var header : HTTPHeaders = []
//            if isPassHeader {
//                header = self.headers
//            }
//
//
//
//            if ServiceManager.checkInterNet() {
//
//                let url = try getFullUrl(relPath: apiURL.strURL() + strURLAdd)
//
//                //printing headers and parametes
//                printStart(header: header ,Parameter: parameters , url: url)
//
//                _ = manager.request(url, method: .patch, parameters: parameters, encoding: paramEncode, headers: header).responseJSON(completionHandler: { (resObj) in
//
//                    HIDE_CUSTOM_LOADER()
//
//                    self.printSucess(json: resObj)
//
//
//
//                    var AuthToken = ""
//                    if resObj.response?.headers != nil
//                    {
//                        if resObj.response?.headers["Authorization"] != nil
//                        {
//                            AuthToken = (resObj.response?.headers["Authorization"]) as! String
//                        }
//                        print(resObj.response?.headers["Authorization"])
//
//                    }
//
//
//                    let statusCode = resObj.response?.statusCode ?? 0
//
//                    switch resObj.result {
//                    case .success(let json) :
//                        print("SuccessJSON \(json)")
//
//                        self.handleSucessForGetToken(json: json, statusCode: statusCode, headerToken: AuthToken, Success: successBlock, Failure: failureBlock)
//
//
//                    case .failure(let err) :
//                        print(err)
//
//                        if let data = resObj.data, let str = String(data: data, encoding: String.Encoding.utf8){
//                            print("Server Error: " + str)
//                        }
//
//                        self.handleFailureForGetToken(json: "", error: err, statusCode: statusCode, headerToken: AuthToken, Success: successBlock, Failure: failureBlock)
//
//                    }
//
//                })
//            }
//
//        }catch let error {
//            self.jprint(items: error)
//            HIDE_CUSTOM_LOADER()
//        }
//    }
//
//
//
//    struct multiPartDataType {
//        var mimetype : String  = "image/jpg"
//        var fileName : String  = ".jpg"
//        var fileData : Data?
//        var keyName : String = ""
//    }
//
//    func postMultipartRequestWithHeader(apiURL : apiURL ,
//                              imageVideoParameters : [multiPartDataType],
//                              parameters : [String: Any] ,
//                              isShowLoader : Bool = true,
//                              isPassHeader : Bool = true,
//                              isShowErrorAlerts : Bool = true,
//                              Success successBlock:@escaping APIResponseBlockWithHeader,
//                              Failure failureBlock:@escaping APIResponseBlockWithHeader) {
//
//        do {
//
//            if ServiceManager.checkInterNet() == false
//            {
//                Utility.errorMessage(message: LocalValidation.checkInternetConnection)
//                return
//            }
//
//            if isShowLoader {
//                SHOW_CUSTOM_LOADER()
//            }
//
//            var header : HTTPHeaders = []
//            if isPassHeader {
//                header = self.headers
//                header = ["Accept": "application/json",
//                                   "Content-Type": "multipart/form-data","Authorization":"Bearer " + appDelegateShared.authToken]
//
//            }
//
//            if ServiceManager.checkInterNet() {
//
//                let url = try getFullUrl(relPath: apiURL.strURL())
//
//
//                var urlRequest = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalAndRemoteCacheData, timeoutInterval: 10.0 * 1000)
//                urlRequest.httpMethod = "POST"
//                urlRequest.headers = header
//
//                //printing headers and parametes
//                printStart(header: header ,Parameter: parameters , url: url)
//
//                _ = manager.upload(multipartFormData: { multiPart in
//                    for (key, value) in parameters {
//                        if let temp = value as? String {
//                            multiPart.append(temp.data(using: .utf8)!, withName: key )
//                        }
//                        if let temp = value as? Int {
//                            multiPart.append("\(temp)".data(using: .utf8)!, withName: key )
//                        }
//                        if let temp = value as? NSArray {
//                            temp.forEach({ element in
//                                let keyObj = key
//                                print("keyObj:",keyObj)
//                                if let string = element as? String {
//                                    print("string:",string)
//                                    multiPart.append(string.data(using: .utf8)!, withName: keyObj)
//                                } else
//                                if let num = element as? Int {
//                                    let value = "\(num)"
//                                    print("num:",num)
//
//                                    multiPart.append(value.data(using: .utf8)!, withName: keyObj)
//                                }
//                            })
//                        }else if let temp = value as? Double {
//                            multiPart.append("\(temp)".data(using: .utf8)!, withName: key )
//                        }
//
//                    }
//
//                    for obj in imageVideoParameters {
//                        if let fileData = obj.fileData {
//                            print("withName:",obj.keyName)
//                            print("fileName:",obj.fileName)
//                           // print("mimeType:",obj.mimeType)
//
//
//                            multiPart.append(fileData, withName:obj.keyName, fileName: obj.fileName, mimeType: obj.mimetype)
//                        }
//                    }
//
//                }, with: urlRequest)
//
//                    .uploadProgress(queue: .main, closure: { progress in
//                        print("Upload Progress: \(progress.fractionCompleted)")
//                    })
//                    .responseJSON(completionHandler: { (resObj) in
//
//                        HIDE_CUSTOM_LOADER()
//
//                        self.printSucess(json: resObj)
//
//                        let statusCode = resObj.response?.statusCode ?? 0
//
//                        switch resObj.result {
//                        case .success(let json) :
//                            print("SuccessJSON \(json)")
//
//                            var AuthToken = ""
//
//                            if resObj.response?.headers != nil
//                            {
//                                if resObj.response?.headers["Authorization"] != nil
//                                {
//                                    AuthToken = (resObj.response?.headers["Authorization"]) as! String
//                                }
//                                print(resObj.response?.headers["Authorization"])
//
//                            }
//
//                            self.handleSucessForGetToken(json: json, statusCode: statusCode, headerToken: AuthToken, Success: successBlock, Failure: failureBlock)
//
//
//
//                        case .failure(let err) :
//                            print(err)
//
//                            // You Got Failure :(
//
//                                                   print(err.localizedDescription)
//                                                   print("\n\n===========Error===========")
//                                                   print("Error Code: \(err._code)")
//                                                   print("Error Messsage: \(err.localizedDescription)")
//
//                                                   debugPrint(err as Any)
//                                                   print("===========================\n\n")
//                                                   HIDE_CUSTOM_LOADER()
//
//                            if let data = resObj.data, let str = String(data: data, encoding: String.Encoding.utf8){
//                                print("Server Error: " + str)
//                            }
//
//                            var AuthToken = ""
//
//                            if resObj.response?.headers != nil
//                            {
//                                if resObj.response?.headers["Authorization"] != nil
//                                {
//                                    AuthToken = (resObj.response?.headers["Authorization"]) as! String
//                                }
//                                print(resObj.response?.headers["Authorization"])
//
//                            }
//
//                            self.handleFailureForGetToken(json: "", error: err, statusCode: statusCode, headerToken: AuthToken, Success: successBlock, Failure: failureBlock)
//                        }
//
//                    })
//            }
//
//        }catch let error {
//            self.jprint(items: error)
//            HIDE_CUSTOM_LOADER()
//        }
//    }
//
//    func postMultipartRequest(apiURL : apiURL ,
//                              imageVideoParameters : [multiPartDataType],
//                              parameters : [String: Any] ,
//                              isShowLoader : Bool = true,
//                              isPassHeader : Bool = true,
//                              isShowErrorAlerts : Bool = true,
//                              Success successBlock:@escaping APIResponseBlock,
//                              Failure failureBlock:@escaping APIResponseBlock) {
//
//        do {
//
//            if ServiceManager.checkInterNet() == false
//            {
//                Utility.errorMessage(message: LocalValidation.checkInternetConnection)
//                return
//            }
//
//            if isShowLoader {
//                SHOW_CUSTOM_LOADER()
//            }
//
//            var header : HTTPHeaders = []
//            if isPassHeader {
//                header = self.headers
//                header = ["Accept": "application/json",
//                                   "Content-Type": "multipart/form-data","Authorization":"Bearer " + appDelegateShared.authToken]
//
//            }
//
//            if ServiceManager.checkInterNet() {
//
//                let url = try getFullUrl(relPath: apiURL.strURL())
//
//
//                var urlRequest = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalAndRemoteCacheData, timeoutInterval: 10.0 * 1000)
//                urlRequest.httpMethod = "POST"
//                urlRequest.headers = header
//
//                //printing headers and parametes
//                printStart(header: header ,Parameter: parameters , url: url)
//
//                _ = manager.upload(multipartFormData: { multiPart in
//                    for (key, value) in parameters {
//                        if let temp = value as? String {
//                            multiPart.append(temp.data(using: .utf8)!, withName: key )
//                        }
//                        if let temp = value as? Int {
//                            multiPart.append("\(temp)".data(using: .utf8)!, withName: key )
//                        }
//                        if let temp = value as? NSArray {
//                            temp.forEach({ element in
//                                let keyObj = key
//                                print("keyObj:",keyObj)
//                                if let string = element as? String {
//                                    print("string:",string)
//                                    multiPart.append(string.data(using: .utf8)!, withName: keyObj)
//                                } else
//                                if let num = element as? Int {
//                                    let value = "\(num)"
//                                    print("num:",num)
//
//                                    multiPart.append(value.data(using: .utf8)!, withName: keyObj)
//                                }
//                            })
//                        }else if let temp = value as? Double {
//                            multiPart.append("\(temp)".data(using: .utf8)!, withName: key )
//                        }
//
//                    }
//
//                    for obj in imageVideoParameters {
//                        if let fileData = obj.fileData {
//                            print("withName:",obj.keyName)
//                            print("fileName:",obj.fileName)
//                           // print("mimeType:",obj.mimeType)
//
//
//                            multiPart.append(fileData, withName:obj.keyName, fileName: obj.fileName, mimeType: obj.mimetype)
//                        }
//                    }
//
//                }, with: urlRequest)
//
//                    .uploadProgress(queue: .main, closure: { progress in
//                        print("Upload Progress: \(progress.fractionCompleted)")
//                    })
//                    .responseJSON(completionHandler: { (resObj) in
//
//                        HIDE_CUSTOM_LOADER()
//
//                        self.printSucess(json: resObj)
//
//                        let statusCode = resObj.response?.statusCode ?? 0
//
//                        switch resObj.result {
//                        case .success(let json) :
//                            print("SuccessJSON \(json)")
//
//                            self.handleSucess(json: json, statusCode: statusCode, isShowErrorAlerts: isShowErrorAlerts, Success: successBlock, Failure: failureBlock)
//
//                        case .failure(let err) :
//                            print(err)
//
//                            // You Got Failure :(
//
//                                                   print(err.localizedDescription)
//                                                   print("\n\n===========Error===========")
//                                                   print("Error Code: \(err._code)")
//                                                   print("Error Messsage: \(err.localizedDescription)")
//
//                                                   debugPrint(err as Any)
//                                                   print("===========================\n\n")
//                                                   HIDE_CUSTOM_LOADER()
//
//                            if let data = resObj.data, let str = String(data: data, encoding: String.Encoding.utf8){
//                                print("Server Error: " + str)
//                            }
//
//                            self.handleFailure(json: "", error: err, statusCode: statusCode, isShowErrorAlerts: isShowErrorAlerts, Success: successBlock, Failure: failureBlock)
//                        }
//
//                    })
//            }
//
//        }catch let error {
//            self.jprint(items: error)
//            HIDE_CUSTOM_LOADER()
//        }
//    }
//
//}
//
//
//// MARK: - Internet Availability
//
//extension ServiceManager {
//
//    class func checkInterNet() -> Bool {
//        if Connectivity.isConnectedToInternet() {
//            return true
//        }else {
//            Utility.errorMessage(message: LocalValidation.checkInternetConnection)
//
//            return false
//        }
//    }
//
//    //Get Full URL
//    func getFullUrl(relPath : String) throws -> URL{
//        do{
//            if relPath.lowercased().contains("http") || relPath.lowercased().contains("www"){
//                return try relPath.asURL()
//            }else{
//                return try (apiURL.baseURL.strURL() + relPath).asURL()
//            }
//        }catch let err{
//            HIDE_CUSTOM_LOADER()
//            throw err
//        }
//    }
//}
//
////MARK:- Handler functions
//extension ServiceManager {
//
//
//    func handleSucess(json : Any,isStringJSON : Bool = false, statusCode : Int, isShowErrorAlerts : Bool = true, Success successBlock:@escaping APIResponseBlock, Failure failureBlock:@escaping APIResponseBlock) {
//
//        var jsonResponse = JSON(json)
//        if isStringJSON {
//            jsonResponse = JSON.init(parseJSON: "\(json)")
//        }
//        //        let dataResponce:Dictionary<String,Any> = jsonResponse.dictionaryValue
//        let dataResponce:Dictionary = jsonResponse.dictionaryValue
//        let errorMessage1 : String = jsonResponse["msg"].string ?? "Something went wrong."
//        let statusCode1 : Int = jsonResponse["status"].intValue
//
//
//
//        let isShowErrorAlerts = isShowErrorAlerts && (!(errorMessage1.localizedCaseInsensitiveContains("no record found")))
//
//        if(statusCode == 307)
//        {
//
//        }
//        else if(statusCode == 401)
//        {
//
//
//            failureBlock(jsonResponse,false,"Something went wrong.", statusCode)
//
//            guard isShowErrorAlerts else { return }
//
//            Utility.errorMessage(message: errorMessage1 ?? "")
//            return
//
//        }
//        else if (statusCode == 412){
//            failureBlock(jsonResponse,false,errorMessage1, statusCode)
//
//            guard isShowErrorAlerts else { return }
//
//            Utility.errorMessage(message: errorMessage1 ?? "")
//            return
//        }
//
//        else if (statusCode == 200){
//            successBlock(jsonResponse, true, errorMessage1,statusCode)
//        }
//
//        else{
//            failureBlock(jsonResponse,false,errorMessage1, statusCode)
//
//            guard isShowErrorAlerts else { return }
//
//            Utility.errorMessage(message: errorMessage1 ?? "")
//            return
//        }
//    }
//
//    func handleSucessForGetToken(json : Any,isStringJSON : Bool = false, statusCode : Int, isShowErrorAlerts : Bool = true, headerToken: String, Success successBlock:@escaping APIResponseBlockWithHeader, Failure failureBlock:@escaping APIResponseBlockWithHeader) {
//
//        var jsonResponse = JSON(json)
//        if isStringJSON {
//            jsonResponse = JSON.init(parseJSON: "\(json)")
//        }
//        //        let dataResponce:Dictionary<String,Any> = jsonResponse.dictionaryValue
//        let dataResponce:Dictionary = jsonResponse.dictionaryValue
//        let errorMessage1 : String = jsonResponse["msg"].string ?? "Something went wrong."
//        let statusCode1 : Int = jsonResponse["status"].intValue
//
//
//
//        let isShowErrorAlerts = isShowErrorAlerts && (!(errorMessage1.localizedCaseInsensitiveContains("no record found")))
//
//        if(statusCode == 307)
//        {
//
//        }
//        else if(statusCode == 401)
//        {
//
//
//            failureBlock(jsonResponse,false,"Something went wrong.", statusCode, headerToken)
//
//            guard isShowErrorAlerts else { return }
//
//            Utility.errorMessage(message: errorMessage1 ?? "")
//            return
//
//        }
//        else if (statusCode == 412){
//            failureBlock(jsonResponse,false,errorMessage1, statusCode, headerToken)
//
//            guard isShowErrorAlerts else { return }
//
//            Utility.errorMessage(message: errorMessage1 ?? "")
//            return
//        }
//
//        else if (statusCode == 200){
//            successBlock(jsonResponse, true, errorMessage1,statusCode, headerToken)
//        }
//
//        else{
//            failureBlock(jsonResponse,false,errorMessage1, statusCode, headerToken)
//
//            guard isShowErrorAlerts else { return }
//
//            Utility.errorMessage(message: errorMessage1 ?? "")
//            return
//        }
//    }
//
//
//
//    func handleFailure(json : Any, isStringJSON : Bool = false, error : AFError, statusCode : Int, isShowErrorAlerts : Bool = true, Success suceessBlock:@escaping APIResponseBlock, Failure failureBlock:@escaping APIResponseBlock) {
//
//        var jsonResponse = JSON(json)
//        if isStringJSON {
//            jsonResponse = JSON.init(parseJSON: "\(json)")
//        }
//
//        let errorMessage1 : String = jsonResponse["message"].string ?? "Something went wrong."
//
//        let isShowErrorAlerts = isShowErrorAlerts && (!(errorMessage1.localizedCaseInsensitiveContains("no record found")))
//
//        print(error.localizedDescription)
//        print("\n\n===========Error===========")
//        print("Error Code: \(error._code)")
//        print("Error Messsage: \(error.localizedDescription)")
//
//
//        print("===========================\n\n")
//        HIDE_CUSTOM_LOADER()
//
//
//        if (error._code == NSURLErrorTimedOut || error._code == 13 ) {
//            failureBlock(jsonResponse,true,errorMessage1, statusCode)
//        }
//        else{
//            failureBlock(jsonResponse,false,errorMessage1, statusCode)
//
//            //showing alert
//            guard isShowErrorAlerts else { return }
//
//            //GeneralUtility.sharedInstance.showUtility.errorMessage(message: errorMessage)
//            Utility.errorMessage(message: errorMessage1 ?? "")
//            return
//
//            //            if let topVC = UIApplication.topViewController() {
//            //                GeneralUtility.sharedInstance.showAlertWithTitleFromVC(vc: topVC, title: appName, andMessage: errorMessage, buttons: ["OK"]) { (tag) in
//            //
//            //                    if tag == 0 {
//            //
//            //                    }
//            //                }
//            //            }
//        }
//    }
//
//
//    func handleFailureForGetToken(json : Any, isStringJSON : Bool = false, error : AFError, statusCode : Int, isShowErrorAlerts : Bool = true,  headerToken: String, Success suceessBlock:@escaping APIResponseBlockWithHeader, Failure failureBlock:@escaping APIResponseBlockWithHeader) {
//
//        var jsonResponse = JSON(json)
//        if isStringJSON {
//            jsonResponse = JSON.init(parseJSON: "\(json)")
//        }
//
//        let errorMessage1 : String = jsonResponse["message"].string ?? "Something went wrong."
//
//        let isShowErrorAlerts = isShowErrorAlerts && (!(errorMessage1.localizedCaseInsensitiveContains("no record found")))
//
//        print(error.localizedDescription)
//        print("\n\n===========Error===========")
//        print("Error Code: \(error._code)")
//        print("Error Messsage: \(error.localizedDescription)")
//
//
//        print("===========================\n\n")
//        HIDE_CUSTOM_LOADER()
//
//
//        if (error._code == NSURLErrorTimedOut || error._code == 13 ) {
//            failureBlock(jsonResponse,true,errorMessage1, statusCode, headerToken)
//        }
//        else{
//            failureBlock(jsonResponse,false,errorMessage1, statusCode, headerToken)
//
//            //showing alert
//            guard isShowErrorAlerts else { return }
//
//            //GeneralUtility.sharedInstance.showErrorMessage(message: errorMessage)
//            Utility.errorMessage(message: errorMessage1 ?? "")
//            return
//
//            //            if let topVC = UIApplication.topViewController() {
//            //                GeneralUtility.sharedInstance.showAlertWithTitleFromVC(vc: topVC, title: appName, andMessage: errorMessage, buttons: ["OK"]) { (tag) in
//            //
//            //                    if tag == 0 {
//            //
//            //                    }
//            //                }
//            //            }
//        }
//    }
//
//    func printStart(header : HTTPHeaders,Parameter: [String : Any] , url: URL)  {
//        print("**** API CAll Start ****")
//        print("**** API URL ****" , url)
//
//        print("**** API Header Start ****")
//        print(header)
//        print("**** API Header End ****")
//        print("**** API Parameter Start ****")
//        print(Parameter)
//        print("**** API Parameter End ****")
//    }
//
//    func printSucess(json : Any) {
//        print("**** API CAll END ****")
//        print("**** API Response Start ****")
//        print(json)
//        print("**** API Response End ****")
//    }
//
//    func jprint(items: Any...) {
//        for item in items {
//            print(item)
//        }
//    }
//
//}
//
//
//class Connectivity {
//    class func isConnectedToInternet() ->Bool {
//        return NetworkReachabilityManager()!.isReachable
//    }
//}
//
//
//extension String {
//
//    static func random(length: Int = 20) -> String {
//        let base = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
//        var randomString: String = ""
//
//        for _ in 0..<length {
//            let randomValue = arc4random_uniform(UInt32(base.count))
//            randomString += "\(base[base.index(base.startIndex, offsetBy: Int(randomValue))])"
//        }
//        return randomString
//    }
//}
