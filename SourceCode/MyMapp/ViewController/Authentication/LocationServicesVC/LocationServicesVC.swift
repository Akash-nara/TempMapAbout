//
//  LocationServicesVC.swift
//  MyMapp
//
//  Created by Chirag Pandya on 31/10/21.
//

import UIKit
import CoreLocation

class LocationServicesVC: UIViewController,CLLocationManagerDelegate{
    
    //MARK: - OUTLETS
    @IBOutlet weak var btnEnable:UIButton!
    
    //MARK: - VARIABLES
    var locationManager = CLLocationManager()
    
    //MARK: - VIEW DID LOAD
    override func viewDidLoad() {
        super.viewDidLoad()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1, execute: {
            self.btnEnable.dropShadowButton()
        })
    }
    
    //MARK: - BUTTON ACTIONS
    @IBAction func btnHandlerMaybelater(_ sender: Any){
        appDelegateShared.setTabbarRoot()
    }
    
    @IBAction func btnHandlerSelectLocatiioon(_ sender: Any){
        self.locationManager = CLLocationManager()
        self.locationManager.delegate = self
    }
    
    //MARK: - OTHER FUNCTIONS
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .notDetermined:
            manager.requestWhenInUseAuthorization()
        case .restricted, .denied:
            
            self.showAlertWithTitleFromVC(appName, andMessage: "Please give the access of location permission for taking the user's current location", buttons: ["Open Settings"]) { i in
                
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
                        appDelegateShared.locationDataGetModel = UserLocationDataSetModel.init(lattitude: manager.location!.coordinate.latitude, longitude: manager.location!.coordinate.longitude, address: "", isPermission: true)
                    }
                }
            }
        @unknown default:
            break
        }
    }    
}
