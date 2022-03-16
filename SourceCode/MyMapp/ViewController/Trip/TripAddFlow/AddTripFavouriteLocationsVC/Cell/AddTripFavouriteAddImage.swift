//
//  AddTripFavouriteAddImage.swift
//  MyMapp
//
//  Created by ZB_Mac_Mini on 18/11/21.
//

import UIKit
import SkeletonView
import Alamofire

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
            if let code = (response.response)?.statusCode, code != 200{
                debugPrint("failure status code: \(code)")
                failureCompletion?()
            }
            
            switch response.result{
            case .success:
                debugPrint("status image Code:- \(name)")
                // do your work
                
                completion?()
            case .failure(let erro):
                debugPrint("failure image:- \(name), \(erro.localizedDescription)")
                failureCompletion?()
            }
        }
    }
}


extension UIImage {
    
    func convertToBase64() -> String {
        let imageData = self.pngData()!
        let size = Float(Double(imageData.count)/1024/1024)
      //For Kb just remove single 1024 from size
      // I am checking 5 MB size here you check as you want
        var comparessedImageData:Data? = nil
        
        if size <= 6.00{
            // Here your image
            comparessedImageData = imageData
        }else{
            comparessedImageData = self.compressImage()?.pngData()! // frist time 0.50 compreddes
            
            // here still more than 6
            if Float(Double(comparessedImageData!.count)/1024/1024) >= 6.00{ // more compraeed
                comparessedImageData = self.compressImage(compressQuality: 0.25)?.pngData()! // frist time 0.25 compreddes
            }
            
            // here still more than 6
            if Float(Double(comparessedImageData!.count)/1024/1024) >= 6.00{ // more compraeed
                comparessedImageData = self.compressImage(compressQuality: 0.20)?.pngData()!// frist time 0.20 compreddes
            }
        }
        
        return comparessedImageData?.base64EncodedString() ?? ""
    }
    
    // MARK: - UIImage+Resize
    func compressTo(_ expectedSizeInMb:Int) -> UIImage? {
        let sizeInBytes = expectedSizeInMb * 1024 * 1024
        var needCompress:Bool = true
        var imgData:Data?
        var compressingValue:CGFloat = 1.0
        while (needCompress && compressingValue > 0.0) {
            if let data:Data = self.jpegData(compressionQuality: compressingValue) {
                if data.count < sizeInBytes {
                    needCompress = false
                    imgData = data
                } else {
                    compressingValue -= 0.1
                }
            }
        }
        
        if let data = imgData {
            if (data.count < sizeInBytes) {
                return UIImage(data: data)
            }
        }
        return nil
    }
}

extension UIImage {
    
    func compressImage(compressQuality:Float=0.5) -> UIImage? {
        // Reducing file size to a 10th
        var actualHeight: CGFloat = self.size.height
        var actualWidth: CGFloat = self.size.width
        let maxHeight: CGFloat = 1136.0
        let maxWidth: CGFloat = 640.0
        var imgRatio: CGFloat = actualWidth/actualHeight
        let maxRatio: CGFloat = maxWidth/maxHeight
        var compressionQuality = compressQuality
        
        if actualHeight > maxHeight || actualWidth > maxWidth {
            if imgRatio < maxRatio {
                //adjust width according to maxHeight
                imgRatio = maxHeight / actualHeight
                actualWidth = imgRatio * actualWidth
                actualHeight = maxHeight
            } else if imgRatio > maxRatio {
                //adjust height according to maxWidth
                imgRatio = maxWidth / actualWidth
                actualHeight = imgRatio * actualHeight
                actualWidth = maxWidth
            } else {
                actualHeight = maxHeight
                actualWidth = maxWidth
                compressionQuality = 1
            }
        }
        let rect = CGRect(x: 0.0, y: 0.0, width: actualWidth, height: actualHeight)
        UIGraphicsBeginImageContext(rect.size)
        self.draw(in: rect)
        guard let img = UIGraphicsGetImageFromCurrentImageContext() else {
            return nil
        }
        UIGraphicsEndImageContext()
        guard let imageData = img.jpegData(compressionQuality: CGFloat(compressionQuality)) else {
            return nil
        }
        return UIImage(data: imageData)
    }
}
