//
//  Utility.swift
//  MyMapp
//
//  Created by Akash Nara Pro on 03/04/20.
//  Copyright © 2021 Akash. All rights reserved.
//

import UIKit
import Photos
import AVKit
import AVFoundation

class Utility {
    static func openSafariBrowserWithOrignalUrl(_ strUrl: String?){
        if let urlString = strUrl, let url = URL(string: urlString){
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
    
    static func checkVideoCameraPermission(callback: @escaping (Bool)->()) {
        if AVCaptureDevice.authorizationStatus(for: AVMediaType.video) ==  AVAuthorizationStatus.authorized {
            // Already Authorized
            callback(true)
        } else {
            AVCaptureDevice.requestAccess(for: AVMediaType.video, completionHandler: { (granted: Bool) -> Void in
                if granted == true {
                    // User granted
                    callback(true)
                } else {
                    // User rejected
                    callback(false)
                }
            })
        }
    }
    
    static func getAtrributedText(contents:[String], fonts:[UIFont], colors:[UIColor]) -> NSMutableAttributedString{
        let finalMutableAttributedString = NSMutableAttributedString()
        guard contents.count == fonts.count && contents.count == colors.count else {
            return finalMutableAttributedString
        }
        
        for (index, content) in contents.enumerated(){
            let attributeDict = [NSAttributedString.Key.font : fonts[index], NSAttributedString.Key.foregroundColor : colors[index]]
            let mutableAttributedString = NSMutableAttributedString(string: content, attributes:attributeDict)
            finalMutableAttributedString.append(mutableAttributedString)
        }
        return finalMutableAttributedString
    }
    
    static func convertToDictionary(text: String) -> [String: Any]? {
        if let data = text.data(using: .utf8) {
            do {
                return try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
            } catch {
                print(error.localizedDescription)
            }
        }
        return nil
    }
    
    
    //    static func convertToDictionaryToJson(jsonDict: [String:Any]) -> String? {
    //
    //        do {
    //            let jsonData = try JSONSerialization.data(withJSONObject: jsonDict, options: .prettyPrinted)
    //            // here "jsonData" is the dictionary encoded in JSON data
    //
    //            let decoded = try JSONSerialization.jsonObject(with: jsonData, options: [])
    //            // here "decoded" is of type `Any`, decoded from JSON data
    //            // you can now cast it with the right type
    //            if let dictFromJSON = decoded as? [String:String] {
    //                print(dictFromJSON)
    //            }
    //        } catch {
    //            print(error.localizedDescription)
    //        }
    //        return nil
    //    }
    
    //MARK: - ERROR MESSAGE
    static func errorMessage(message:String){
        CustomAlertView.init(title: message, forPurpose: .failure).showForWhile(animated: true)
//        SwiftMessageBar.showMessage(withTitle: "Error", message: message, type: .error)
//        let generator = UIImpactFeedbackGenerator(style: .heavy)
//        generator.impactOccurred()
    }
    
    static func successMessage(message:String){
        CustomAlertView.init(title: message, forPurpose: .success).showForWhile(animated: true)
//        SwiftMessageBar.showMessage(withTitle: "Success", message: message, type: .success)
    }
}
