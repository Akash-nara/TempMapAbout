//
//  Constants.swift
//  MyMapp
//
//  Created by Akash Nara Pro on 19/03/20.
//  Copyright © 2021 Akash. All rights reserved.
//

import UIKit

struct cueDevice {
    static let isDeviceSEOrLower: Bool = cueSize.screen.height <= 568.0
    static let isDevice6SOrLower: Bool = cueSize.screen.height <= 667
    static let isDevice6SPOrLower: Bool = cueSize.screen.height <= 736.0
    static let isDevice6SOrGreater: Bool = cueSize.screen.height >= 667
    static let isDeviceXOrGreater: Bool = cueSize.statusBarHeight > 20
    static let is_iPad = UIDevice.current.userInterfaceIdiom == .pad
}

// MARK: - Device Size

struct cueSize {
    static let screen = UIScreen.main.bounds.size
    static let iphone5Height = 568.0
    static let iPhone6PlusWidth = 414.0
    static let iPhone6PlusHeight = 736.0
    static let iPhone6Width = 375.0
    static let iPhone6Height = 667.0
    static let iPhoneXHeight = 812.0
    static let statusBarHeight = UIApplication.shared.statusBarFrame.height
    static let keyboardHeight: CGFloat = cueSize.screen.width <= 375 ? (cueDevice.isDeviceXOrGreater ? 233 : 216) : 226
    static let bottomHeightOfSafeArea: CGFloat = cueDevice.isDeviceXOrGreater ? 34.0 : 0.0

    /*
    static var statusBarHeight: CGFloat {
        get {
            setStatuBarHeight()
            return self.statusBarHeight
        }
        set {
            setStatuBarHeight()
        }
    }

    static private func setStatuBarHeight(){
        if cueSize.statusBarHeight == 0 {
            let window = UIApplication.shared.windows.filter {$0.isKeyWindow}.first
            if let windowStrong = window,
                let windowScene = windowStrong.windowScene,
                let statusBarManager = windowScene.statusBarManager {
                cueSize.statusBarHeight = statusBarManager.statusBarFrame.height
            }
        }
    }
 */

}


// MARK: - App Info -
struct AppInfo {
    static var currentViewController: String = ""
    
    static var appName: String {
        return (Bundle.main.infoDictionary?["CFBundleName"] as? String) ?? ""
    }
    
    static var appDisplayName: String {
        return (Bundle.main.infoDictionary?["CFBundleDisplayName"] as? String) ?? "Doo"
    }
}

// MARK: - Alert Titles Buttons Messages
struct cueAlert {
    // Alert Titles
    struct Title {
//        static let selectOptions = "Select options"
//        static let video = "Video"
//        static let warning = "Warning"
    }
    
    // Alert Buttons
    struct Button {
        static let cancel = "cancel_button"
        static let save = "save_button"
        static let update = "update_button"

        static let enable = "Enable"
        static let disable = "Disable"
    }
    
    // Alert Message
    struct Message {
        static let somethingWentWrong = "something_went_wrong_plz_try"
        static let deleteAlert = "are_you_sure_you_want_to_delete"
//        static let safariInvalidAddess = "Safari cannot open the page because the address is invalid."
//        static let failRegisterNotificationMessgae = "You have not given permission for notification so we could not register it."
//        static let sessionExpipred = "Session expired, Please try again!"
        static let cameraAccessDenided = "camera_access_denided"
        static let photosAccessDenided = "photos_access_denided"
//        static let cameraDontHave = "You don't have a camera"
    }
}

// MARK: - Image Literal
struct cueImage {
    struct Signup {
        // password
        static let eyeOn: UIImage = #imageLiteral(resourceName: "eyeShow")
        static let eyeOff: UIImage = #imageLiteral(resourceName: "eyeHide")
        static let imgSearchGray: UIImage = #imageLiteral(resourceName: "imgSearchGray")
    }
    static let userPlaceholder: UIImage = #imageLiteral(resourceName: "userPlaceholder")
}

// MARK: -  Regex

struct cueRegex {
    // Private & General
    static let selfMatch = "SELF MATCHES %@"
    // these all chars allowd.. you can verify this chars is not allowd(À,ȕ)
    // `~!@#$%^&*()-_+=\|}{]["';:/?.,><
    private static let allPunctuationChars = "`~!@#$%^&*()-_+=\\|}{\"';:/?.,><"
    
    // MARK: Contact Details
    static let emailId = "[A-Za-z0-9]+[A-Z0-9a-z+_.-]+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2,4}"
    static let mobile = "[0-9]{4,13}"
    static let enterpriseName = "[A-Za-z0-9 \(allPunctuationChars)]{2,40}"
    static let firstOrLastName = "[A-Za-z0-9 \(allPunctuationChars)]{2,40}"
    static let deviceName = "[A-Za-z0-9 \(allPunctuationChars)]{2,40}"
    static let applianceName = "[A-Za-z0-9 \(allPunctuationChars)]{2,40}"

    // MARK: General
    struct Password {
        static let capitalLetter = ".*[A-Z]+.*"
        static let numberLetter = ".*[0-9]+.*"
        static let specialChar = ".*[^A-Za-z0-9].*"
        static let smallLetter = ".*[a-z]+.*"
    }
}

