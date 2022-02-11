//
//  AddTripFavouriteAddImage.swift
//  MyMapp
//
//  Created by ZB_Mac_Mini on 18/11/21.
//

import UIKit

class AddTripFavouriteAddImage: UICollectionViewCell {
    
    @IBOutlet weak var btnTitleRemove: UIButton!
    @IBOutlet weak var imgviewCity: UIImageView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var reloadImageButton: UIButton!

    override func awakeFromNib() {
        super.awakeFromNib()
        btnTitleRemove.imageView?.setImageTintColor(.App_BG_SeafoamBlue_Color)
        btnTitleRemove.tintColor = .App_BG_SeafoamBlue_Color

        imgviewCity.contentMode = .scaleAspectFit
    }

    func uploadImageApi1(bucketTripHash:String, locationBucketHash:String, imageToUpload:UIImage, name:String, completion: (() -> Void)? = nil, failureCompletion: (() -> Void)? = nil){
        
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
        
        activityIndicator.startAnimating()
        let headerAuth = (API_SERVICES.headerForNetworking["Authorization"] ?? "").replacingOccurrences(of: "Bearer ", with: "")
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "PUT"
        urlRequest.setValue("image/jpeg", forHTTPHeaderField: "Content-Type")
        urlRequest.setValue(headerAuth, forHTTPHeaderField: "Authorization")
        urlRequest.allowsCellularAccess = true
        urlRequest.allowsConstrainedNetworkAccess = true
        urlRequest.setValue("\(self.tag)", forHTTPHeaderField: "id")

            URLSession.shared.uploadTask(with: urlRequest, from: imageData, completionHandler: { responseData, response, error in
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
}
