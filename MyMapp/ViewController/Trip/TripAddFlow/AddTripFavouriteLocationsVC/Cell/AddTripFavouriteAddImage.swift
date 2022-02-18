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
        
        //        guard let imageData = imageToUpload.jpegData(compressionQuality: 0.50), let url = URL.init(string: Routing.uploadTripImage.getPath+bucketTripHash+"/"+locationBucketHash+"/\(name)") else {
        //            return
        //        }
        
        activityIndicator.startAnimating()
        //       {"width":"100px","height":"200px","imageType":"image/jpeg","key":"95ee271c-8ac4-4007-b298-9c32ef795d0a/1/PassportImage1.jpeg","imageName":"file2.jpg","image":"base64-string"}
        
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
        //        urlRequest.setValue("\(self.tag)", forHTTPHeaderField: "id")
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")  // not necessary, but best practice
        
        if let postData = (try? JSONSerialization.data(withJSONObject: param, options: [])) {
            urlRequest.httpBody = postData//NSKeyedArchiver.archivedData(withRootObject: param)//JSON.init(param).stringValue.data(using: .utf8)
        }
        //          urlRequest.httpBody = param.map { key, value in
        //            let keyString = key.addingPercentEncoding(withAllowedCharacters: .urlQueryValueAllowed)!
        //            let valueString = (value as AnyObject).addingPercentEncoding(withAllowedCharacters: .urlQueryValueAllowed)!
        //            return keyString + "=" + valueString
        //            }.joined(separator: "&").data(using: .utf8)
        
        
        URLSession.shared.uploadTask(with: urlRequest, from: nil, completionHandler: { responseData, response, error in
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


extension CharacterSet {

    /// Character set containing characters allowed in query value as outlined in RFC 3986.
    ///
    /// RFC 3986 states that the following characters are "reserved" characters.
    ///
    /// - General Delimiters: ":", "#", "[", "]", "@", "?", "/"
    /// - Sub-Delimiters: "!", "$", "&", "'", "(", ")", "*", "+", ",", ";", "="
    ///
    /// In RFC 3986 - Section 3.4, it states that the "?" and "/" characters should not be escaped to allow
    /// query strings to include a URL. Therefore, all "reserved" characters with the exception of "?" and "/"
    /// should be percent-escaped in the query string.
    ///
    /// - parameter string: The string to be percent-escaped.
    ///
    /// - returns: The percent-escaped string.

    static var urlQueryValueAllowed: CharacterSet = {
        let generalDelimitersToEncode = ":#[]@" // does not include "?" or "/" due to RFC 3986 - Section 3.4
        let subDelimitersToEncode = "!$&'()*+,;="

        var allowed = CharacterSet.urlQueryAllowed
        allowed.remove(charactersIn: generalDelimitersToEncode + subDelimitersToEncode)

        return allowed
    }()

}
