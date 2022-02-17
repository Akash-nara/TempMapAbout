//
//  AppDelegate.swift
//  MyMapp
//
//  Created by Chirag Pandya on 27/10/21.
//

import UIKit
import IQKeyboardManagerSwift
import CoreLocation
import GoogleMaps
import GooglePlaces

let appDelegateShared : AppDelegate = UIApplication.shared.delegate as! AppDelegate

@main
class AppDelegate: UIResponder, UIApplicationDelegate,CLLocationManagerDelegate{
    
    //MARK: - VARIABLES
    var authToken = String()
    var tagsData = [TagListModel]()
    var locationManager = CLLocationManager()
    var locationDataGetModel = UserLocationDataSetModel()
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        SSReachabilityManager.shared.startMonitoring() // Start checking internet connection

        //        sleep(2)
        IQKeyboardManager.shared.enable = true
        IQKeyboardManager.shared.toolbarPreviousNextAllowedClasses.append(UIStackView.self)
        IQKeyboardManager.shared.toolbarPreviousNextAllowedClasses.append(UIView.self)
        IQKeyboardManager.shared.previousNextDisplayMode = .alwaysShow
        IQKeyboardManager.shared.shouldResignOnTouchOutside = true
        IQKeyboardManager.shared.toolbarTintColor = UIColor.black
        
        // GMSServices.provideAPIKey("AIzaSyDBjaNDds3kltx7UHUipMduma3TfCzijSs")
        // GMSPlacesClient.provideAPIKey("AIzaSyDBjaNDds3kltx7UHUipMduma3TfCzijSs")
        
//        GMSServices.provideAPIKey("AIzaSyD0CSdY7uisKjY-kwmEUPtzHnHjvxk2Gj8")
//        GMSPlacesClient.provideAPIKey("AIzaSyD0CSdY7uisKjY-kwmEUPtzHnHjvxk2Gj8")

        GMSServices.provideAPIKey("AIzaSyCbpJmRcahoG9cm330aEfMc3Owv85oP218")
        GMSPlacesClient.provideAPIKey("AIzaSyCbpJmRcahoG9cm330aEfMc3Owv85oP218")

        
        self.locationManager = CLLocationManager()
        self.locationManager.delegate = self
        
        UITabBarItem.appearance().setTitleTextAttributes([NSAttributedString.Key.font: UIFont.Montserrat.Medium(10)], for: .normal)
        UITabBarItem.appearance().setTitleTextAttributes([NSAttributedString.Key.font: UIFont.Montserrat.Medium(10)], for: .selected)
        
        UITabBar.appearance().tintColor = UIColor.App_BG_SecondaryDark2_Color
        UITabBar.appearance().unselectedItemTintColor = UIColor.App_BG_colorsNeutralLightDark2
        
        return true
    }
    
    // MARK: UISceneSession Lifecycle
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }

    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .notDetermined:
            print("REQUEST")
            
        case .restricted, .denied:
            
            UIApplication.topViewController()?.showAlertWithTitleFromVC(appName, andMessage: "Please give the access of location permission for taking the user's current location", buttons: ["Open Settings"]) { i in
                if i == 0{
                    if let url = NSURL(string:UIApplication.openSettingsURLString) {
                        UIApplication.shared.openURL(url as URL)
                    }
                }
            }
            
        case .authorizedAlways, .authorizedWhenInUse:
            if manager != nil{
                if manager.location != nil{
                    if manager.location?.coordinate != nil{
                        locationDataGetModel = UserLocationDataSetModel.init(lattitude: manager.location!.coordinate.latitude, longitude: manager.location!.coordinate.longitude, address: "", isPermission: true)
                    }
                }
            }
        @unknown default:
            break
        }
    }
    
    func setOnboardingVC(){
        SceneDelegate.getWindow?.rootViewController = UIStoryboard.authentication.instantiateInitialViewController()
    }
    
    func setProfilePicture(){
        guard let navControler = UIStoryboard.authentication.instantiateInitialViewController() as? UINavigationController, let vc = UIStoryboard.authentication.profilePhotoUploadVC else {
            return
        }
        navControler.viewControllers = [vc]
        SceneDelegate.getWindow?.rootViewController = navControler
    }
    
    func setPersonalDetails(){
        guard let navControler = UIStoryboard.authentication.instantiateInitialViewController() as? UINavigationController, let vc = UIStoryboard.authentication.personalDetailsVC else {
            return
        }
        navControler.viewControllers = [vc]
        SceneDelegate.getWindow?.rootViewController = navControler
    }
    
    func setLoginRoot(){
        guard let navControler = UIStoryboard.authentication.instantiateInitialViewController() as? UINavigationController, let vc = UIStoryboard.authentication.signinVC else {
            return
        }
        navControler.viewControllers = [vc]
        SceneDelegate.getWindow?.rootViewController = navControler
    }
    
    func setTabbarRoot(){
        SceneDelegate.getWindow?.rootViewController = UIStoryboard.tabbar.instantiateInitialViewController()
//        self.socketConnect()
    }
    
    func socketConnect(){
        SocketIOManager.sharedInstance.addBasicHandlers()
        SocketIOManager.sharedInstance.addConnectHandler()
        SocketIOManager.sharedInstance.connect()
    }
    
    //MARK: - OTHER FUNCTIONS
    func isKeyPresentInUserDefaults(key: String) -> Bool {
        return UserDefaults.standard.object(forKey: key) != nil
    }

    func checkRedirectionFlow(){
        guard let user = APP_USER else {
            appDelegateShared.setOnboardingVC()
            return
        }
        
        if user.emailId.isEmpty{
            appDelegateShared.setOnboardingVC()
            
        }else{
            
            // here check user email verified or not
            if user.emailVerified{ // if true use case
                
                API_SERVICES.setAuthorization(user.accessToken ?? "")
                
                // here check for pricture added or not
                if user.profilePictureAdded{ // if added
                    
                    // here check is display name added or not
                    if user.displayNameAdded{ // if added the
                        appDelegateShared.setTabbarRoot()
                        
                    }else{ // if not added display name then show screen to add name
                        appDelegateShared.setPersonalDetails()
                    }
                }else{ // if not added picture then show screen to upload picture
                    appDelegateShared.setProfilePicture()
                }
                
            }else{ // if false then show login screen for login
                appDelegateShared.setLoginRoot()
            }
        }
    }
}

