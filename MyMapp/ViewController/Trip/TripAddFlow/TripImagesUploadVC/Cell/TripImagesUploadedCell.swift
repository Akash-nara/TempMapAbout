//
//  TripImagesUploadedCell.swift
//  MyMapp
//
//  Created by Chirag Pandya on 12/12/21.
//

import UIKit
import SkeletonView
import Alamofire

class TripImagesUploadedCell: UICollectionViewCell {
    
    @IBOutlet weak var buttonRadioSelection: UIButton!
    @IBOutlet weak var buttonRetry: UIButton!
    
    @IBOutlet weak var imgTrip: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        imgTrip.isSkeletonable = true
    }
    
    func startAnimating() {
        self.imgTrip.showAnimatedSkeleton()
    }
    
    func stopAnimating() {
        self.imgTrip.hideSkeleton()
    }
    
    func loadCellData(objTripModel:TripImagesModel) {
        
        //        self.startAnimating()
        self.imgTrip.image = objTripModel.image
        if objTripModel.isVerticalImage {
            //since the width > height we may fit it and we'll have bands on top/bottom
            self.imgTrip.contentMode = .scaleAspectFill
        } else {
            //width < height we fill it until width is taken up and clipped on top/bottom
            self.imgTrip.contentMode = .scaleToFill
        }
        
        /*
         if let firstObject = URL.init(string: objTripModel.url){
         
         imgTrip.sd_setImage(with: firstObject, placeholderImage: nil, options: .highPriority) { [self] img, error, cache, url in
         self.imgTrip.image = img
         //                self.stopAnimating()
         if let sizeOfImage = self.imgTrip.image?.size, sizeOfImage.width > sizeOfImage.height {
         
         //since the width > height we may fit it and we'll have bands on top/bottom
         self.imgTrip.contentMode = .scaleAspectFill
         completion?(true, self.imgTrip.tag, imgTrip.image?.getHeight ?? 0)
         } else {
         //width < height we fill it until width is taken up and clipped on top/bottom
         self.imgTrip.contentMode = .scaleToFill
         completion?(false,self.imgTrip.tag, imgTrip.image?.getHeight ?? 0)
         }
         }
         
         self.imgTrip.clipsToBounds = true
         }else{
         self.imgTrip.contentMode = .scaleToFill
         self.imgTrip.image = UIImage.init(named: "ic_Default_city_image_one")
         //            self.stopAnimating()
         
         }*/
    }
    
    
    func uploadImageApi1(bucketTripHash:String, imageToUpload:UIImage, name:String, completion: (() -> Void)? = nil, failureCompletion: (() -> Void)? = nil){
        
        guard SSReachabilityManager.shared.isNetworkAvailable else {
            DispatchQueue.main.async {
                Utility.errorMessage(message: "No internet connection.")
                failureCompletion?()
            }
            return
        }
        
        self.startAnimating()
        let param:[String:Any] = ["width":"\(imageToUpload.size.width)px",
                                  "height":"\(imageToUpload.size.height)px",
                                  "imageType":"image/jpeg",
                                  "key":"\(bucketTripHash+"/"+name)",
                                  "imageName":name,
                                  "image":self.convertToBase64(image: imageToUpload)
        ]
        
        
        /*
        let headerAuth = (API_SERVICES.headerForNetworking["Authorization"] ?? "")
        var urlRequest = URLRequest(url: URL.init(string: "https://g133dvu4m1.execute-api.us-east-1.amazonaws.com/dev/upload")!)
        urlRequest.httpMethod = "POST"
        urlRequest.setValue(headerAuth, forHTTPHeaderField: "Authorization")
        urlRequest.allowsCellularAccess = true
        urlRequest.allowsConstrainedNetworkAccess = true
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")  // not necessary, but best practice
        urlRequest.networkServiceType = .responsiveData
        urlRequest.timeoutInterval = 120
        
        let realURL: URL = URL(string: "https://g133dvu4m1.execute-api.us-east-1.amazonaws.com/dev/upload")!
        
        let url: Alamofire.URLConvertible = realURL
        AF.upload(multipartFormData: { multipartFormData in
            for (key, value) in param {
                if let data = (value as AnyObject).data(using: String.Encoding.utf8.rawValue) {
                    multipartFormData.append(data, withName: key)
                }
            }
        }, to: url,method:.post,headers: urlRequest.headers).response { response in
            switch response.result{
            case .success:
                debugPrint("status image Code:- \(name)")
                // do your work
                completion?()
            case .failure(let erro):
                debugPrint("failure image:- \(name), \(erro.localizedDescription)")
                failureCompletion?()
            }
        }*/
        
        
        let headerAuth = (API_SERVICES.headerForNetworking["Authorization"] ?? "")
        var urlRequest = URLRequest(url: URL.init(string: "https://g133dvu4m1.execute-api.us-east-1.amazonaws.com/dev/upload")!)
        urlRequest.httpMethod = "POST"
        urlRequest.setValue(headerAuth, forHTTPHeaderField: "Authorization")
        urlRequest.allowsCellularAccess = true
        urlRequest.allowsConstrainedNetworkAccess = true
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")  // not necessary, but best practice
        urlRequest.networkServiceType = .responsiveData
        urlRequest.timeoutInterval = 120

        if let postData = (try? JSONSerialization.data(withJSONObject: param, options: [])) {
            urlRequest.httpBody = postData
        }
        
        //        let sessionConfig = URLSessionConfiguration.background(withIdentifier: "swiftlee.background.url.session")
        //        sessionConfig.sharedContainerIdentifier = "group.swiftlee.apps"
        let sessionConfig = URLSessionConfiguration.default
        //        sessionConfig.sharedContainerIdentifier = "group.swiftlee.apps"
//        sessionConfig.timeoutIntervalForRequest = 240
//        sessionConfig.timeoutIntervalForResource = 240
//                sessionConfig.waitsForConnectivity = true
        sessionConfig.allowsConstrainedNetworkAccess = true
        sessionConfig.allowsCellularAccess = true
        let session = URLSession(configuration: sessionConfig)
        session.uploadTask(with: urlRequest, from: nil, completionHandler: { responseData, response, error in
            //            DispatchQueue.main.async {
            //                self.stopAnimating()
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
            //            }
        }).resume()
        //        }
    }
    
    func convertToBase64(image: UIImage) -> String {
        return image.pngData()!
            .base64EncodedString()
    }
    
    
}
