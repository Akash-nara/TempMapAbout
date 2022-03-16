//
//  UserManager.swift
//  MyMapp
//
//  Created by Akash Nara on 23/12/20.
//  Copyright © 2021 Akash. All rights reserved.
//

import Foundation
import UIKit


var APP_USER: AppUser? = nil

// frpm user instance itself, user can be saved.
extension AppUser {
    func saveUser() {
        UserManager.saveUser()
    }
}

struct UserManager {
    
    static let CertifUserKey = "MyMappUser"
    
    static func storeCertifUser(_ dooUser: AppUser?) {
        
        guard let strongUser = dooUser else {return}
                
        NetworkingManager.shared.setAuthorization(strongUser.accessToken ?? "") // NETWORKING... whenver user gets updated. just set new accesstoken to networking...
        
        UserManager.archieveAndStoreCertifUser(strongUser)
    }
    
    static func saveUser() {
        if let strongUser = APP_USER {
            self.archieveAndStoreCertifUser(strongUser)
        }
    }
    
    // Actual store
    private static func archieveAndStoreCertifUser(_ strongUser: AppUser) {
        // https://stackoverflow.com/questions/37028194/cannot-decode-object-of-class-employee-for-key-ns-object-0-the-class-may-be-d
        // the class may be defined in source code or a library that is not linked
        NSKeyedArchiver.setClassName("MyMappUser", for: AppUser.self)
        
        if let encodedData = try? NSKeyedArchiver.archivedData(withRootObject: strongUser, requiringSecureCoding: false) {
                UserDefaults.standard.set(encodedData, forKey: CertifUserKey)
                UserDefaults.standard.synchronize()
        }
    }
    
    static func getLoggedInUser() -> AppUser? {
        
        NSKeyedUnarchiver.setClass(AppUser.self, forClassName: "MyMappUser")
        guard let storedObject: Data = UserDefaults.standard.object(forKey: CertifUserKey) as? Data else {
            return nil
        }
        do {
            
            if let storedUser: AppUser = try NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(storedObject) as? AppUser{
                NetworkingManager.shared.setAuthorization(storedUser.accessToken ?? "") // NETWORKING...
                return storedUser
            }
            return nil
        } catch{
           debugPrint(error)
            return nil
        }
    }
}

extension UserManager {
    static func logoutMethod() {
        if let _ = (SceneDelegate.getWindow?.rootViewController as? UINavigationController)?.viewControllers.first as? SigninVC {
            // If user already in SignIn and verification failed via wrong password
        }else{
            // When user inside app or other process like, location add or learning journey.
            clear()
            // Move to signup flow...
            appDelegateShared.setOnboardingVC()
        }
    }
    
    static func clear() {
        TABBAR_INSTANCE = nil // remove tabbar instance set globally.
        UserDefaults.standard.removeObject(forKey: CertifUserKey)
        UserDefaults.standard.synchronize()
        UIApplication.shared.unregisterForRemoteNotifications()
        SocketIOManager.sharedInstance.addDisconnectHandler()
        SocketIOManager.sharedInstance.disconnect()
        SocketIOManager.sharedInstance.removeAllHandlers()
        APP_USER = nil
        API_SERVICES.removeAuthorizationAndVarification() // Networking...
        IS_USER_INSIDE_APP = false // User is not inside app any more.
    }
}
