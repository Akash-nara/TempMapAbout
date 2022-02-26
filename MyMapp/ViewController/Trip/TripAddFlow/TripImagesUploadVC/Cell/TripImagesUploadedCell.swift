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
                                  "image":imageToUpload.convertToBase64()//convertToBase64(image: imageToUpload)
        ]
        
        let headerAuth = (API_SERVICES.headerForNetworking["Authorization"] ?? "")
        var urlRequest = URLRequest(url: URL.init(string: "https://g133dvu4m1.execute-api.us-east-1.amazonaws.com/dev/upload")!)
        urlRequest.httpMethod = "POST"
        urlRequest.setValue(headerAuth, forHTTPHeaderField: "Authorization")
        urlRequest.allowsCellularAccess = true
        urlRequest.allowsConstrainedNetworkAccess = true
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")  // not necessary, but best practice
        urlRequest.timeoutInterval = 120 // 120 secs
        urlRequest.networkServiceType = .responsiveData
        
        let req: Alamofire.URLRequestConvertible = urlRequest
        guard let postData = (try? JSONSerialization.data(withJSONObject: param, options: []))else{
            return
        }
        
        AF.upload(postData, with: req).response { response in
            
            // fail image reject server it return
            if let code = (response.response)?.statusCode, code != 200{
                debugPrint("failure status code: \(code)")
                failureCompletion?()
            }
            
            switch response.result{
            case .success:
                debugPrint("status image Code:- \(name)")
                completion?()
            case .failure(let erro):
                debugPrint("failure image:- \(name), \(erro.localizedDescription)")
                failureCompletion?()
            }
        }
    }
}
