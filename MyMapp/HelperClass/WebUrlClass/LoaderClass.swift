//
//  LoaderClass.swift
//  DemoServiceManage
//
//  Created by Zestbrains on 11/06/21.
//

import Foundation
import NVActivityIndicatorView
import UIKit

class LoadingDailog: UIViewController, NVActivityIndicatorViewable {
    
    //MARK: - Shared Instance
    static let sharedInstance : LoadingDailog = {
        let instance = LoadingDailog()
        return instance
    }()
    
    func startLoader() {
        //.AppBlue()
        startAnimating(nil, message: "Loading...", messageFont: UIFont.Montserrat.Bold(dynamicFontSize(17)), type: .ballClipRotatePulse, color: UIColor.App_BG_SeafoamBlue_Color, padding: nil, displayTimeThreshold: nil, minimumDisplayTime: nil)
    }
    
    func stopLoader() {
        self.stopAnimating()
    }
}

//MARK: HIDE/SHOW LOADERS
public func HIDE_CUSTOM_LOADER(){
    LoadingDailog.sharedInstance.stopLoader()
    //NewLoadingDailog.sharedInstance.stopLoader()
}

public func SHOW_CUSTOM_LOADER(){
    LoadingDailog.sharedInstance.startLoader()
    //    NewLoadingDailog.sharedInstance.startLoader()
}

//MARK: Loading indicater and Alert From UIVIEWController
extension UIViewController {
    
    //MARK: - Show/Hide Loading Indicator
    func SHOW_CUSTOM_LOADER() {
        LoadingDailog.sharedInstance.startLoader()
    }
    func HIDE_CUSTOM_LOADER() {
        LoadingDailog.sharedInstance.stopLoader()
    }
}

var API_LOADER = LoadingDailog()
