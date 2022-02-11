//
//  NetworkingManager.swift
//  MyMapp
//
//  Created by Akash Nara on 16/12/20.
//  Copyright © 2021 Akash. All rights reserved.
//

import Foundation
import Alamofire

var API_SERVICES = NetworkingManager.shared

// MARK:- Auth interceptor
class AuthInterceptor: RequestInterceptor {
    
    func retry(_ request: Request, for session: Session, dueTo error: Error, completion: @escaping (RetryResult) -> Void) {
        
        debugPrint("\(#function) : request : \(request), retryCount : \(request.retryCount)")
        // let noOfTimesRetried = request.retryCount
        
        guard let statusCode = request.response?.statusCode else {
            completion(.doNotRetry)
            return
        }
        
        switch statusCode {
        case 200...299:
            completion(.doNotRetry)
        default:
            completion(.doNotRetry)
            /*
             if noOfTimesRetried < 1 {
             // Above condition will retry two times.
             // When no of times retried is 0, it means one call already being made, which made by developer
             // When no of times retried is 1, it means one more call has been made by retry, which made by above condition.
             completion(.retry) // Retry only for three times
             }else{
             completion(.doNotRetry)
             }
             */
        }
    }
}

class NetworkingManager {
    
    /// Custom header field
    var headerForNetworking: [String: String]  = ["Content-Type":"application/x-www-form-urlencoded"]
    
    // Singleton instance of networking...
    private static var networkingManager: NetworkingManager? = nil
    static var shared: NetworkingManager {
        if networkingManager == nil {
            networkingManager = NetworkingManager()
        }
        return networkingManager!
    }
    
    // Networking stuff using Alamofire...
    private var defaultSession = Session.default
    

    init() {
        
        // default configuration...
        let configuration = URLSessionConfiguration.default
        
        configuration.httpMaximumConnectionsPerHost = 10    // Limits the no of requests simultaneously can be made.
        configuration.allowsCellularAccess = true
        configuration.timeoutIntervalForRequest = 15
        configuration.timeoutIntervalForResource = 15
        

        // As Apple states in their documentation, mutating URLSessionConfiguration properties after the instance has been added to a URLSession (or, in Alamofire’s case, used to initialize aSession) has no effect.
        // What above sentance indicates: Changing instance properties of 'configuration' later, won't have any effect. You can say that it won't work like class instance.
        self.defaultSession = Session(configuration: configuration, interceptor: AuthInterceptor())

    }
    
    // Additional vaiables
    private let VERIFICATION_TOKEN_KEY = "Verification-Token"
    private let AUTHORIZATION_KEY = "Authorization"
    private let ACCEPT_LANG_KEY = "Accept-Language"
    
    // BASE URL
    private let BASE_URL = Environment.APIBasePath()
}

// MARK: VERIFICATION TOKEN WORK
extension NetworkingManager{
    /// Set Bearer token with this method
    func setAuthorization(_ authorization : String, isNeedPrefixAddBearer:Bool=false) {
        self.headerForNetworking.removeValue(forKey: VERIFICATION_TOKEN_KEY)
        self.headerForNetworking[AUTHORIZATION_KEY] = isNeedPrefixAddBearer ? "Bearer \(authorization)" : authorization
        self.headerForNetworking[ACCEPT_LANG_KEY] = Locale.current.languageCode?.lowercased() ?? "en"
    }
    func getAuthorization() -> String? {
        if let authorization = self.headerForNetworking[AUTHORIZATION_KEY], !authorization.isEmpty {
            return authorization
        }
        return nil
    }
    /// Verification Token
    func setVerificationToken(_ verificationToken : String) {
        self.headerForNetworking[VERIFICATION_TOKEN_KEY] = "Bearer " + verificationToken
        self.headerForNetworking[ACCEPT_LANG_KEY] = Locale.current.languageCode?.lowercased() ?? "en"
    }
    func getVerificationToken() -> String? {
        if let verificationToken = self.headerForNetworking[VERIFICATION_TOKEN_KEY], !verificationToken.isEmpty {
            return verificationToken
        }
        return nil
    }
    func isVerificationTokenExists() -> Bool {
        if let verificationToken = self.headerForNetworking[VERIFICATION_TOKEN_KEY], !verificationToken.isEmpty {
            return true
        }
        return false
    }
    
    func removeAuthorizationAndVarification() {
        self.headerForNetworking.removeValue(forKey: VERIFICATION_TOKEN_KEY)
        self.headerForNetworking.removeValue(forKey: AUTHORIZATION_KEY)
    }
}

// MARK: SINGLE REQUEST
extension NetworkingManager{
    func callAPI(_ params: [String: Any] = [:],
                 path: Routing,
                 method: HTTPMethod = .post,
                 encoding: ParameterEncoding = URLEncoding.default,//JSONEncoding.prettyPrinted,
                 success: (([String: JSON]?) -> ())? = nil,
                 failure: ((String?) -> ())? = nil,
                 internetFailure: (() -> ())? = nil,
                 failureInform: (() -> ())? = nil) {
        
        debugPrint("API Call ----------------------------")
        debugPrint("Header: \(self.headerForNetworking) -------\n")
        debugPrint("URL Access: \(BASE_URL + path.getPath) -------\n")
        debugPrint("Params: \(params) -------\n")
        debugPrint("API Call ----------------------------")
        
        guard SSReachabilityManager.shared.isNetworkAvailable else {
//             SceneDelegate.findOutUIAndShowNoInternetConnectionPopup() // default alert, show from anywhere.
            failureInform?()
            if let internetFailureClosure = internetFailure {
                DispatchQueue.main.async {
                    internetFailureClosure()
                }
            }else{
                DispatchQueue.main.async {
                    Utility.errorMessage(message: "internet_failure")
                }
            }
            // Stop loader if working
            DispatchQueue.main.async {
                API_LOADER.HIDE_CUSTOM_LOADER()
            }
            return
        }
        
        // For better understanding - https://stackoverflow.com/questions/43282281/how-to-add-alamofire-url-parameters
        var encodingReceived: ParameterEncoding = encoding
        if method == .get {
            encodingReceived = URLEncoding.default
        }
        
        let completePath = BASE_URL + path.getPath
        let trimmedURL = completePath.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "" // Replacing space to %20
        
        let request = self.defaultSession.request(trimmedURL, method: method, parameters: params, encoding: encodingReceived, headers: HTTPHeaders.init(self.headerForNetworking))
        /// request.validate().responseJSON { (dataResponse) in  // Validate in all errors, even the custom one sent by Your networking guys.
        request.responseJSON { (dataResponse) in
            debugPrint(dataResponse)
            
            self.setAuthorization(dataResponse.response?.value(forHTTPHeaderField: "Authorization") ?? APP_USER?.accessToken ?? "")
            switch dataResponse.result {
            case .success(let value):
                let parsingJSON = JSON.init(value).dictionaryValue
                debugPrint(parsingJSON)
                
                let verifyErrorPolicy = self.verifyErrorPossiblities(dataResponse, parsingJSON, isHandleFailure: (failure == nil))
                if verifyErrorPolicy.isClearForSuccess {
                    debugPrint("Go ahead with success!")
                    success?(parsingJSON) // closure call
                }else{
                    if verifyErrorPolicy.customErrorMessage.count != 0 {
                        failure?(verifyErrorPolicy.customErrorMessage) // closure call
                    }else{
                        failure?(nil) // closure call
                    }
                    failureInform?()
                }
            case .failure(let error):
                // manually cancelled
                guard !error.localizedDescription.contains("cancelled") else { return }
                
                switch error {
                case .explicitlyCancelled:
                    break // Ignore: these are manually cancelled requests
                default:
                    if let errorDesc = dataResponse.error?.errorDescription,
                       errorDesc == "URLSessionTask failed with error: The request timed out." {
                        DispatchQueue.main.async {
                            API_LOADER.HIDE_CUSTOM_LOADER()
                            Utility.errorMessage(message: "slow_or_internet_failure")
                            internetFailure?()
                        }
                    }else{
                        if dataResponse.response?.statusCode ?? 0 == 401{
                            UserManager.logoutMethod()
                            failure?(nil) // closure call
                        }
                        self.verifyErrorPossiblities(dataResponse, isHandleFailure: (failure == nil)) // if failure part not handled manually
                        failure?(nil) // closure call
                    }
                    debugPrint("Networking error message: \(String(describing: error.errorDescription))")
                }
                failureInform?()
            }
        }
    }
}

// MARK: Send array directly.
extension NetworkingManager {
    func callAPIWithCollection(_ collection: [Any] = [],
                               path: Routing,
                               method: HTTPMethod = .post,
                               encoding: ParameterEncoding = JSONEncoding.prettyPrinted,
                               success: (([String: JSON]?) -> ())? = nil,
                               failure: ((String?) -> ())? = nil,
                               internetFailure: (() -> ())? = nil,
                               failureInform: (() -> ())? = nil) {
        
        guard let requestingURL = URL.init(string: Environment.APIBasePath()+path.getPath) else {
            debugPrint("Requesting URL!")
            Utility.errorMessage(message: "something_went_wrong")
            return
        }
        
        var request = URLRequest(url: requestingURL)
        request.httpMethod = method.rawValue
        request.setHeader(fields: HTTPHeaders.init(self.headerForNetworking).dictionary)
        request.httpBody = try! JSONSerialization.data(withJSONObject: collection)
        
        self.defaultSession.request(request).responseJSON { (dataResponse) in
            switch dataResponse.result {
            case .success(let value):
                let parsingJSON = JSON.init(value).dictionaryValue
                
                let verifyErrorPolicy = self.verifyErrorPossiblities(dataResponse, parsingJSON, isHandleFailure: (failure == nil))
                if verifyErrorPolicy.isClearForSuccess {
                    debugPrint("Go ahead with success!")
                    success?(parsingJSON) // closure call
                }else{
                    if verifyErrorPolicy.customErrorMessage.count != 0 {
                        failure?(verifyErrorPolicy.customErrorMessage) // closure call
                    }else{
                        failure?(nil) // closure call
                    }
                    failureInform?()
                }
            case .failure(let error):
                // manually cancelled
                guard !error.localizedDescription.contains("cancelled") else { return }
                
                switch error {
                case .explicitlyCancelled:
                    break // Ignore: these are manually cancelled requests
                default:
                    debugPrint("Networking error message: \(String(describing: error.errorDescription))")
                    self.verifyErrorPossiblities(dataResponse, isHandleFailure: (failure == nil)) // if failure part not handled manually
                    failure?(nil) // closure call
                }
                failureInform?()
            }
        }
    }
}

extension URLRequest{
    mutating func setHeader(fields: [String:String?]) {
        fields.forEach { (headerDict) in
            self.setValue(headerDict.value, forHTTPHeaderField: headerDict.key)
        }
    }
}


// MARK: PASS SOMETHING WENT WRONG!
extension NetworkingManager {
    
    @discardableResult
    func verifyErrorPossiblities(_ dataResponse: AFDataResponse<Any>, _ jsonResponse: [String: JSON]? = nil, isHandleFailure: Bool = true) -> (isClearForSuccess: Bool, customErrorMessage: String) {
        
        guard let statusCode = dataResponse.response?.statusCode, let jsonStatus = jsonResponse?["status"]?.intValue else {
            if isHandleFailure {
                showSomethingWentWrong()
            }
            return (false, "")
        }
        switch jsonStatus {
        case 200...201, 203...299:
            return (true, "")
        case 202:
            // Light Error.
            func showAlert(withCustomMessage customMessage: String) {
                Utility.errorMessage(message: customMessage)
                //                CustomAlertView.init(title: customMessage, forPurpose: .success).showForWhile(animated: true)
                // Stop loader if working
                API_LOADER.HIDE_CUSTOM_LOADER()
            }
            
            if let customMessage = jsonResponse?["payload"]?.dictionaryValue["error"]?.dictionaryValue["message"]?.stringValue {
                if isHandleFailure {
                    showAlert(withCustomMessage: customMessage)
                }else{
                    return (false, customMessage)
                }
            }else if let customMessage = jsonResponse?["message"]?.stringValue {
                if isHandleFailure {
                    showAlert(withCustomMessage: customMessage)
                }else{
                    return (false, customMessage)
                }
            }else{
                if isHandleFailure {
                    showSomethingWentWrong()
                }
            }
        case 403:
            // Enterprise Revoked
            API_LOADER.HIDE_CUSTOM_LOADER()
        case 401:
            // Unauthorization
            if let customMessage = jsonResponse?["payload"]?.dictionaryValue["error"]?
                .dictionaryValue["message"]?.stringValue {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                    Utility.errorMessage(message: customMessage)
                    //                    CustomAlertView.init(title: customMessage).showForWhile(animated: true)
                }
            }else{
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                    Utility.errorMessage(message: "Invalid username/password")
                    //                    CustomAlertView.init(title: "Invalid username/password")
                    //                        .showForWhile(animated: true)
                }
            }
            // Stop loader if working
            API_LOADER.HIDE_CUSTOM_LOADER()
            if APP_USER != nil {
                UserManager.logoutMethod()
            }
        default:
            debugPrint("Networking error message: \(String(describing:   jsonResponse?["msg"]?.stringValue))")
            
            func showAlert(withCustomMessage customMessage: String) {
                DispatchQueue.getMain {
                    // Stop loader if working
                    API_LOADER.HIDE_CUSTOM_LOADER()
                    Utility.errorMessage(message: customMessage)
                }
                //                CustomAlertView.init(title: customMessage).showForWhile(animated: true)
            }
            
            if let customMessage = jsonResponse?["msg"]?.stringValue {
                if isHandleFailure {
                    showAlert(withCustomMessage: customMessage)
                }else{
                    return (false, customMessage)
                }
            }else if let customMessage = jsonResponse?["message"]?.stringValue {
                if isHandleFailure {
                    showAlert(withCustomMessage: customMessage)
                }else{
                    return (false, customMessage)
                }
            }else{
                if isHandleFailure {
                    showSomethingWentWrong()
                }
            }
        }
        
        return (false, "")
    }
    
    func showSomethingWentWrong() {
        Utility.errorMessage(message: "Something went wrong! please try again after sometime!")
        debugPrint("Show: Something went wrong! please try again after sometime!")
        
        // Stop loader if working
        API_LOADER.HIDE_CUSTOM_LOADER()
    }
}


extension NetworkingManager {
    func cancelAllRequests() {
        self.defaultSession.cancelAllRequests()
    }
    
    func cancelRequest(routing: Routing) {
        let lastPathComponent = URL.init(string: routing.getPath)?.lastPathComponent ?? ""
        self.defaultSession.session.getTasksWithCompletionHandler { (sessionDataTask, uploadData, downloadData) in
            debugPrint("avaiable tasks: \(sessionDataTask)")
            sessionDataTask.forEach {
                if let currentRequestLastPathComponent = $0.currentRequest?.url?.lastPathComponent {
                    if lastPathComponent == currentRequestLastPathComponent {
                        $0.cancel()
                        debugPrint("Requests available to cancel: \($0.currentRequest?.url)")
                    }
                }
            }
        }
    }
    func cancelUploadRequests(routing: Routing) {
        let lastPathComponent = URL.init(string: routing.getPath)?.lastPathComponent ?? ""
        self.defaultSession.session.getTasksWithCompletionHandler { (sessionDataTask, uploadData, downloadData) in
            debugPrint("avaiable tasks: \(uploadData)")
            uploadData.forEach {
                if let currentRequestLastPathComponent = $0.currentRequest?.url?.lastPathComponent {
                    if lastPathComponent == currentRequestLastPathComponent {
                        $0.cancel()
                        debugPrint("Requests available to cancel: \($0.currentRequest?.url)")
                    }
                }
            }
        }
    }
}

// MARK: SINGLE REQUEST
extension NetworkingManager{
    func callUploadFileAPI(_ params: [String: Any] = [:],
                           localFilePaths: [URL] = [], // Local files or images
                           images: [UIImage] = [], // Local files or images
                           names: [String], // Mandatory in both cases, images & local file paths.
                           fileNames: [String] = [],
                           path: Routing,
                           method: HTTPMethod = .post,
                           withProgress progressBlock: @escaping (_ progressValue: Double) -> Void,
                           success: (([String: JSON]?) -> ())? = nil,
                           failure: ((String?) -> ())? = nil,
                           internetFailure: (() -> ())? = nil,
                           failureInform: (() -> ())? = nil) {
        
        debugPrint("API Call ----------------------------")
        debugPrint("Header: \(self.headerForNetworking) -------\n")
        debugPrint("URL Access: \(BASE_URL + path.getPath) -------\n")
        debugPrint("Params: \(params) -------\n")
        debugPrint("API Call ----------------------------")
        
        guard SSReachabilityManager.shared.isNetworkAvailable else {
            // SceneDelegate.findOutUIAndShowNoInternetConnectionPopup() // default alert, show from anywhere.
            failureInform?()
            if let internetFailureClosure = internetFailure {
                DispatchQueue.main.async {
                    internetFailureClosure()
                }
            }else{
                DispatchQueue.main.async {
                    Utility.errorMessage(message: "internet_failure")
                }
            }
            // Stop loader if working
            DispatchQueue.main.async {
                API_LOADER.HIDE_CUSTOM_LOADER()
            }
            return
        }
        
        let completePath = BASE_URL + path.getPath
        let trimmedURL = completePath.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "" // Replacing space to %20
        
        self.defaultSession.upload(multipartFormData: { multipartFormData in
            for index in 0..<localFilePaths.count {
                let localFilePath = localFilePaths[index]
                multipartFormData.append(localFilePath, withName: names[index]) // filename automatically will be taken from url, including mime type...
            }
            for index in 0..<images.count {
                let imageToBeUploaded = images[index];
                let imageNameToBeAppended = names[index];
                if let imageData = imageToBeUploaded.jpegData(compressionQuality: 0) {
                    multipartFormData.append(imageData,
                                             withName: imageNameToBeAppended,
                                             fileName: fileNames[index],
                                             mimeType: "image/jpg")
                }
            }
            for (key, value) in params {
                multipartFormData.append(String(describing: value).data(using: .utf8)!, withName: key)
            }
        }, to: trimmedURL,
                                   usingThreshold: UInt64.init(),
                                   method: method,
                                   headers: HTTPHeaders.init(self.headerForNetworking))
            .uploadProgress(closure: { (progress) in
                progressBlock(progress.fractionCompleted)
            })
            .responseJSON { (dataResponse) in
                switch dataResponse.result {
                case .success(let value):
                    let parsingJSON = JSON.init(value).dictionaryValue
                    
                    let verifyErrorPolicy = self.verifyErrorPossiblities(dataResponse, parsingJSON, isHandleFailure: (failure == nil))
                    if verifyErrorPolicy.isClearForSuccess {
                        debugPrint("Go ahead with success!")
                        success?(parsingJSON) // closure call
                    }else{
                        if verifyErrorPolicy.customErrorMessage.count != 0 {
                            failure?(verifyErrorPolicy.customErrorMessage) // closure call
                        }else{
                            failure?(nil) // closure call
                        }
                        failureInform?()
                    }
                case .failure(let error):
                    // manually cancelled
                    guard !error.localizedDescription.contains("cancelled") else { return }
                    
                    switch error {
                    case .explicitlyCancelled:
                        break // Ignore: these are manually cancelled requests
                    default:
                        debugPrint("Networking error message: \(String(describing: error.errorDescription))")
                        self.verifyErrorPossiblities(dataResponse, isHandleFailure: (failure == nil)) // if failure part not handled manually
                        failure?(nil) // closure call
                    }
                    failureInform?()
                }
            }
    }
    
    
    func callUploadWithSIngleFileAPI(_ params: [String: Any] = [:],
                           localFilePaths: [URL] = [], // Local files or images
                           images: [UIImage] = [], // Local files or images
                           names: [String], // Mandatory in both cases, images & local file paths.
                           fileNames: [String] = [],
                           path: String,
                           method: HTTPMethod = .post,
                           withProgress progressBlock: @escaping (_ progressValue: Double) -> Void,
                           success: (([String: JSON]?) -> ())? = nil,
                           failure: ((String?) -> ())? = nil,
                           internetFailure: (() -> ())? = nil,
                           failureInform: (() -> ())? = nil) {
        
        debugPrint("API Call ----------------------------")
        debugPrint("Header: \(self.headerForNetworking) -------\n")
        debugPrint("URL Access: \(path) -------\n")
        debugPrint("Params: \(params) -------\n")
        debugPrint("API Call ----------------------------")
        
        guard SSReachabilityManager.shared.isNetworkAvailable else {
            // SceneDelegate.findOutUIAndShowNoInternetConnectionPopup() // default alert, show from anywhere.
            failureInform?()
            if let internetFailureClosure = internetFailure {
                DispatchQueue.main.async {
                    internetFailureClosure()
                }
            }else{
                DispatchQueue.main.async {
                    Utility.errorMessage(message: "internet_failure")
                }
            }
            // Stop loader if working
            DispatchQueue.main.async {
                API_LOADER.HIDE_CUSTOM_LOADER()
            }
            return
        }
        
        let completePath = path
        let trimmedURL = completePath.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "" // Replacing space to %20
        
        self.defaultSession.upload(multipartFormData: { multipartFormData in
            for index in 0..<localFilePaths.count {
                let localFilePath = localFilePaths[index]
                multipartFormData.append(localFilePath, withName: names[index]) // filename automatically will be taken from url, including mime type...
            }
            for index in 0..<images.count {
                let imageToBeUploaded = images[index];
                let imageNameToBeAppended = names[index];
                if let imageData = imageToBeUploaded.jpegData(compressionQuality: 0) {
                    multipartFormData.append(imageData,
                                             withName: imageNameToBeAppended,
                                             fileName: fileNames[index],
                                             mimeType: "image/jpg")
                }
            }
            for (key, value) in params {
                multipartFormData.append(String(describing: value).data(using: .utf8)!, withName: key)
            }
        }, to: trimmedURL,
                                   usingThreshold: UInt64.init(),
                                   method: method,
                                   headers: HTTPHeaders.init(self.headerForNetworking))
            .uploadProgress(closure: { (progress) in
                progressBlock(progress.fractionCompleted)
            })
            .responseJSON { (dataResponse) in
                switch dataResponse.result {
                case .success(let value):
                    let parsingJSON = JSON.init(value).dictionaryValue
                    
                    let verifyErrorPolicy = self.verifyErrorPossiblities(dataResponse, parsingJSON, isHandleFailure: (failure == nil))
                    if verifyErrorPolicy.isClearForSuccess {
                        debugPrint("Go ahead with success!")
                        success?(parsingJSON) // closure call
                    }else{
                        if verifyErrorPolicy.customErrorMessage.count != 0 {
                            failure?(verifyErrorPolicy.customErrorMessage) // closure call
                        }else{
                            failure?(nil) // closure call
                        }
                        failureInform?()
                    }
                case .failure(let error):
                    // manually cancelled
                    guard !error.localizedDescription.contains("cancelled") else { return }
                    
                    switch error {
                    case .explicitlyCancelled:
                        break // Ignore: these are manually cancelled requests
                    default:
                        debugPrint("Networking error message: \(String(describing: error.errorDescription))")
                        self.verifyErrorPossiblities(dataResponse, isHandleFailure: (failure == nil)) // if failure part not handled manually
                        failure?(nil) // closure call
                    }
                    failureInform?()
                }
            }
    }

    
    func downloadFile(url: String,
                      fileName: String,
                      isSetHeaderNil:Bool = false,
                      withProgress progressBlock: @escaping (_ progressValue: Double) -> Void,
                      onSuccess success: @escaping (_ responsePathURL: URL?, _ isAvailabelFile:Bool) -> Void,
                      failure: ((String?) -> ())? = nil,
                      internetFailure: (() -> ())? = nil,
                      failureInform: (() -> ())? = nil){
        
        let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0];
        let fileURL = documentsURL.appendingPathComponent(fileName)
        if let documentsPathURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
            let pathComponent = documentsPathURL.appendingPathComponent(fileURL.lastPathComponent)
            let filePath = pathComponent.path
            
            if FileManager.default.fileExists(atPath: filePath) {
                if let _ = try? FileManager.default.removeItem(atPath: filePath) {
                    debugPrint("FILE NOT AVAILABLE")
                }else{
                    debugPrint("FILE AVAILABLE")
                    success(fileURL, true)
                    return
                }
            } else {
                debugPrint("FILE NOT AVAILABLE")
            }
        }
        
        debugPrint("url to call: \(url)")
        let destination: DownloadRequest.Destination = { _, _ in
            debugPrint(fileURL)
            return (fileURL, [.removePreviousFile])
        }
        
        // change in inteval timeout for specific request
        self.defaultSession.download(
            url,
            headers: isSetHeaderNil ? nil : HTTPHeaders.init(self.headerForNetworking),
            to: destination).downloadProgress(closure: { (progress) in
                //progress closure
                progressBlock(progress.fractionCompleted)
            }).response(completionHandler: { (dataResponse) in
                //here you able to access the DefaultDownloadResponse
                //result closure
                
                switch dataResponse.result {
                case .success(_):
                    success(dataResponse.value as? URL, false) // closure call
                    // failureInform?()
                case .failure(let error):
                    // manually cancelled
                    guard !error.localizedDescription.contains("cancelled") else { return }
                    
                    switch error {
                    case .explicitlyCancelled:
                        break // Ignore: these are manually cancelled requests
                    default:
                        debugPrint("Networking error message: \(String(describing: error.errorDescription))")
                        failure?(nil) // closure call
                    }
                    failureInform?()
                }
            })
    }
    
}
