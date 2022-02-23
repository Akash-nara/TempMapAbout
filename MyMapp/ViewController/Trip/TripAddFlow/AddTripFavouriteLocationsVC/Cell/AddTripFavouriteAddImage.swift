//
//  AddTripFavouriteAddImage.swift
//  MyMapp
//
//  Created by ZB_Mac_Mini on 18/11/21.
//

import UIKit
import SkeletonView

class AddTripFavouriteAddImage: UICollectionViewCell {
    
    @IBOutlet weak var btnTitleRemove: UIButton!
    @IBOutlet weak var imgviewCity: UIImageView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var reloadImageButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        btnTitleRemove.imageView?.setImageTintColor(.App_BG_SeafoamBlue_Color)
        btnTitleRemove.tintColor = .App_BG_SeafoamBlue_Color
        imgviewCity.isSkeletonable = true
        imgviewCity.contentMode = .scaleAspectFit
    }
    
    func startAnimating() {
        self.imgviewCity.showAnimatedSkeleton()
    }
    
    func stopAnimating() {
        self.imgviewCity.hideSkeleton()
    }
    
    func uploadImageApi1(bucketTripHash:String, locationBucketHash:String, imageToUpload:UIImage, name:String, completion: (() -> Void)? = nil, failureCompletion: (() -> Void)? = nil){
        
        guard SSReachabilityManager.shared.isNetworkAvailable else {
            DispatchQueue.main.async {
                Utility.errorMessage(message: "No internet connection.")
                failureCompletion?()
            }
            return
        }
        startAnimating()
        let param:[String:Any] = ["width":"\(imageToUpload.size.width)px",
                                  "height":"\(imageToUpload.size.height)px",
                                  "imageType":"image/jpeg",
                                  "key":"\(bucketTripHash+"/"+locationBucketHash+"/"+name)",
                                  "imageName":name,
                                  "image":convertToBase64(image: imageToUpload)
        ]
        
        
        let headerAuth = (API_SERVICES.headerForNetworking["Authorization"] ?? "")
        var urlRequest = URLRequest(url: URL.init(string: "https://g133dvu4m1.execute-api.us-east-1.amazonaws.com/dev/upload")!)
        urlRequest.httpMethod = "POST"
        urlRequest.setValue(headerAuth, forHTTPHeaderField: "Authorization")
        urlRequest.allowsCellularAccess = true
        urlRequest.allowsConstrainedNetworkAccess = true
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")  // not necessary, but best practice
        
        if let postData = (try? JSONSerialization.data(withJSONObject: param, options: [])) {
            urlRequest.httpBody = postData
        }
        
        //        let sessionConfig = URLSessionConfiguration.background(withIdentifier: "swiftlee.background.url.session")
        //        sessionConfig.sharedContainerIdentifier = "group.swiftlee.apps"
        let sessionConfig = URLSessionConfiguration.default
        //        sessionConfig.sharedContainerIdentifier = "group.swiftlee.apps"
        sessionConfig.timeoutIntervalForRequest = 240
        sessionConfig.timeoutIntervalForResource = 240
        //        sessionConfig.waitsForConnectivity = true
        //        sessionConfig.allowsConstrainedNetworkAccess = false
        //        sessionConfig.allowsCellularAccess = true
        let session = URLSession(configuration: sessionConfig)
        session.uploadTask(with: urlRequest, from: nil, completionHandler: { responseData, response, error in
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
        }).resume()
    }
    
    func convertToBase64(image: UIImage) -> String {
        return image.pngData()!
            .base64EncodedString()
    }
}
