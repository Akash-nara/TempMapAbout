//
//  SceneDelegate.swift
//  Doo-IoT
//
//  Created by Akash Nara on 19/03/20.
//  Copyright © 2021 Akash. All rights reserved.
//

import UIKit

var IS_USER_INSIDE_APP = false // Indicates user is in initial startup page, available to handle deeplinks, push notifications, learning journey flow etc...

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    static var getWindow: UIWindow? {
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
          let sceneDelegate = windowScene.delegate as? SceneDelegate{
            return sceneDelegate.window
        }else{
            return nil
        }
    }

    var window: UIWindow?
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        SSReachabilityManager.shared.startMonitoring() // Start checking internet connection

        // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
        // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
        // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).
        guard let _ = (scene as? UIWindowScene) else { return }

//        SceneDelegate.getWindow?.rootViewController = UIStoryboard.tabbar.instantiateInitialViewController()
//        return

        if let loggedUser = UserManager.getLoggedInUser() {
            APP_USER = loggedUser
            appDelegateShared.checkRedirectionFlow()
//            self.window?.rootViewController = UIStoryboard.tabbar.savedAlbumDetailVC

        }else{
            self.window?.rootViewController = UIStoryboard.authentication.instantiateInitialViewController()
//            appDelegateShared.setTabbarRoot()
        }
        return
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not neccessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
        
        debugPrint("Did become active called")
        // if user available, then connect
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        if let user = APP_USER, user.displayNameAdded{
            if !SocketIOManager.sharedInstance.isConnected(){
                SocketIOManager.sharedInstance.connect()
            }
        }
        
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
//        if let _ = COUNT_DOWN_VIEW {
//            // debugPrint("count down view detected...")
//            self.setCountdownBasedOnAppSpentTimeInBackground()
//        }
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
        
//        if let _ = COUNT_DOWN_VIEW {
//            // debugPrint("count down view detected...")
//            self.setTimeOfAppWentInBackground()
//        }
    }
    
    // ADDITIONAL PROPERTIES
    private let defaults: UserDefaults = UserDefaults.init()
}

// MARK: COUT DOWN WORK
extension SceneDelegate {
    func setTimeOfAppWentInBackground(withKey key: String = "TimeEnterBackground") {
        defaults.set(Date(), forKey: key)
        defaults.synchronize()
    }

    func setCountdownBasedOnAppSpentTimeInBackground() {
        
        func getElapsedTime() -> Int {
            if let timeSpentInBackground = defaults.value(forKey: "TimeEnterBackground") as? Date {
                let elapsed = Int(Date().timeIntervalSince(timeSpentInBackground))
                return elapsed
            }
            return 0
        }
        
//        COUNT_DOWN_VIEW?.count -= getElapsedTime()
    }
}
