//
//  TripImagesModel.swift
//  MyMapp
//
//  Created by Akash on 25/01/22.
//

import UIKit

class TripImagesModel:NSObject {
    
    enum EnumUploadStatus:Equatable {
        case none, progress, done, fail, notStarted, pause
    }
    
    var isCityUploadeImage = false
    var type:String = ""
    var url:String = ""
    var isEdit = false
    var statusUpload:EnumUploadStatus = .none
    var nameOfImage = ""
    var id = 0
    var keyToSubmitServer  = ""
    var isVerticalImage:Bool{
        if let sizeOfImage = image?.size, sizeOfImage.width > sizeOfImage.height {
            //since the width > height we may fit it and we'll have bands on top/bottom
            return false
        } else {
            //width < height we fill it until width is taken up and clipped on top/bottom
            return true
        }
    }
    

    // MARK : Variables Declaration
//    var imgData : Data?
    var image: UIImage?
    var progress: Double? {
        didSet {
            DispatchQueue.main.async {
                self.progressBlock?(self.progress)
            }
        }
    }
    var uploadStatus: EnumUploadStatus = .notStarted
    var progressBlock: ((Double?)->())?
    private weak var uploadTask: URLSessionUploadTask?
    
//image: UIImage(), type: "last", url: "", isEdit: "0"
//    // MARK : Data Init Implementation
    convenience init(image: UIImage ,type:String="", url:String, nameOfImage:String = "") {
        self.init()
//        self.id = id
        self.image = image
        self.nameOfImage = nameOfImage
        self.type = type
    }
    
//    override init() {}
    func pauseTask(){
        self.uploadStatus = .pause
        self.uploadTask?.suspend()
    }
    
    func resume(){
        self.uploadStatus = .progress
        self.uploadTask?.resume()
    }
    
    func cancelUpload() {
        self.uploadStatus = .fail
        self.uploadTask?.cancel()
    }
    
    func uploadImgFile(bucketTripHash:String, locationBucketHash:String, imageToUpload:UIImage, name:String, completion: (() -> Void)? = nil, failureCompletion: (() -> Void)? = nil) -> Void {
        
        guard SSReachabilityManager.shared.isNetworkAvailable else {
            DispatchQueue.main.async {
                Utility.errorMessage(message: "No internet connection.")
                failureCompletion?()
            }
            return
        }

        guard let imageData = imageToUpload.jpegData(compressionQuality: 0.50), let url = URL.init(string: Routing.uploadTripImage.getPath+bucketTripHash+"/"+locationBucketHash+"/\(name)") else {
            return
        }
        
        //        "https://pv80m0iz3f.execute-api.us-east-1.amazonaws.com/dev/v1/d0f30768-3bd2-42ac-8179-da36d0032bdc/1"
        let headerAuth = (API_SERVICES.headerForNetworking["Authorization"] ?? "").replacingOccurrences(of: "Bearer ", with: "")
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "PUT"
        urlRequest.setValue("image/jpeg", forHTTPHeaderField: "Content-Type")
        urlRequest.setValue(headerAuth, forHTTPHeaderField: "Authorization")
        
        DispatchQueue.global(qos: .background).async{
            self.uploadTask = URLSession.shared.uploadTask(with: urlRequest, from: imageData, completionHandler: { responseData, response, error in
                DispatchQueue.main.async {
                    guard let responseCode = (response as? HTTPURLResponse)?.statusCode, responseCode == 200  else {
                        if let error = error {
                            print(error)
                        }
                        print("failure image:- \(name)")
                        failureCompletion?()
                        return
                    }
                    print("status image Code:- \(name) \(responseCode)")
                    // do your work
                    completion?()
                }
            })
            self.uploadTask?.resume()
        }
    }
}
