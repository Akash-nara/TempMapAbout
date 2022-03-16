//
//  TabbarVC.swift
//  MyMapp
//
//  Created by Chirag Pandya on 07/11/21.
//

import UIKit
import BottomPopup

class TabbarVC: UITabBarController,UITabBarControllerDelegate{
    
    //MARK: - VARIABLES
    var height: CGFloat = 217
    var topCornerRadius: CGFloat = 35
    var presentDuration: Double = 1.0
    var dismissDuration: Double = 1.0
    let kHeightMaxValue: CGFloat = 600
    let kTopCornerRadiusMaxValue: CGFloat = 35
    let kPresentDurationMaxValue = 3.0
    let kDismissDurationMaxValue = 3.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tabBar.backgroundColor = UIColor.white
        
        let Feed: UITabBarItem? = tabBar.items?[0]
        let FeedImage = UIImage(named: "ic_selected_feed")?.withRenderingMode(.alwaysOriginal)
        let FeedUnselectedImage = UIImage(named: "ic_unselected_Feed")?.withRenderingMode(.alwaysOriginal)
        Feed?.selectedImage = FeedImage
        Feed?.image = FeedUnselectedImage
        
        let Explore: UITabBarItem? = tabBar.items?[1]
        let ExploreImage = UIImage(named: "ic_unselected_explore")?.withRenderingMode(.alwaysOriginal)
        let ExploreUnselectedImage = UIImage(named: "ic_unselected_explore")?.withRenderingMode(.alwaysOriginal)
        Explore?.selectedImage = ExploreImage!.imageWithColor(color1: UIColor.App_BG_SecondaryDark2_Color)
        Explore?.image = ExploreUnselectedImage
        
        let Trip: UITabBarItem? = tabBar.items?[2]
        let TripImage = UIImage(named: "ic_plus_unselected")?.withRenderingMode(.alwaysOriginal)
        let TripUnselectedImage = UIImage(named: "ic_plus_unselected")?.withRenderingMode(.alwaysOriginal)
        Trip?.selectedImage = TripImage
        Trip?.image = TripUnselectedImage
        
        let Forum: UITabBarItem? = tabBar.items?[3]
        let ForumImage = UIImage(named: "ic_unselected_Notifications")?.withRenderingMode(.alwaysOriginal)
        let ForumUnselectedImage = UIImage(named: "ic_unselected_Notifications")?.withRenderingMode(.alwaysOriginal)
        Forum?.selectedImage = ForumImage!.imageWithColor(color1: UIColor.App_BG_SecondaryDark2_Color)
        Forum?.image = ForumUnselectedImage
        
        let Profile: UITabBarItem? = tabBar.items?[4]
        let ProfileImage = UIImage(named: "ic_selected_profile")?.withRenderingMode(.alwaysOriginal)
        let ProfileUnselectedImage = UIImage(named: "ic_unselected_profile")?.withRenderingMode(.alwaysOriginal)
        Profile?.selectedImage = ProfileImage
        Profile?.image = ProfileUnselectedImage
        
        self.delegate = self
        
        self.tabBar.layer.masksToBounds = true
        self.tabBar.isTranslucent = true
        self.tabBar.barStyle = .blackOpaque
        self.tabBar.layer.cornerRadius = 20
        self.tabBar.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        
        tabBar.layer.shadowColor = UIColor.black.cgColor
        tabBar.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
        tabBar.layer.shadowRadius = 5
        tabBar.layer.shadowOpacity = 1
        tabBar.layer.masksToBounds = false
    }
    
    
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        
        let name = String(describing: type(of: viewController))
        
        if name == "AddTripHomeVC", let popupVC = UIStoryboard.tabbar.addTripHomeVC{
            popupVC.height = 250
            popupVC.topCornerRadius = topCornerRadius
            popupVC.presentDuration = 0.5
            popupVC.dismissDuration = 0.5
            popupVC.customNavigationController = self.navigationController
            DispatchQueue.main.async {
                self.present(popupVC, animated: true, completion: nil)
            }
            return false
        }else if let profileHomeVC = viewController as? ProfileHomeVC{
                    profileHomeVC.collectionviewProfile.reloadData()
            return true
        }else{
            return true
        }
    }
}

extension UIImage {
    func imageWithColor(color1: UIColor) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(self.size, false, self.scale)
        color1.setFill()
        
        let context = UIGraphicsGetCurrentContext()
        context?.translateBy(x: 0, y: self.size.height)
        context?.scaleBy(x: 1.0, y: -1.0)
        context?.setBlendMode(CGBlendMode.normal)
        
        let rect = CGRect(origin: .zero, size: CGSize(width: self.size.width, height: self.size.height))
        context?.clip(to: rect, mask: self.cgImage!)
        context?.fill(rect)
        
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage!
    }
}
