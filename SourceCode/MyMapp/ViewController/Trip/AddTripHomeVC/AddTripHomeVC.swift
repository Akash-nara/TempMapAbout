//
//  AddTripHomeVC.swift
//  MyMapp
//
//  Created by Chirag Pandya on 07/11/21.
//

import UIKit
import BottomPopup

class AddTripHomeVC: BottomPopupViewController, BottomPopupDelegate {
    
    //MARK: - VARIABLES
    var height: CGFloat?
    var topCornerRadius: CGFloat?
    var presentDuration: Double?
    var dismissDuration: Double?
    var shouldDismissInteractivelty: Bool?
    var customNavigationController:UINavigationController?

    override var popupHeight: CGFloat { return height ?? CGFloat(300) }
    override var popupTopCornerRadius: CGFloat { return topCornerRadius ?? CGFloat(10) }
    override var popupPresentDuration: Double { return presentDuration ?? 1.0 }
    override var popupDismissDuration: Double { return dismissDuration ?? 1.0 }
    override var popupShouldDismissInteractivelty: Bool { return shouldDismissInteractivelty ?? true }
    
    //MARK: - VIEW DID LOAD
    override func viewDidLoad() { super.viewDidLoad() }
    
    //MARK: - BUTTON ACTIONS
    @IBAction func btnHandlerAddTrip(_ sender: Any){
        self.dismiss(animated: true)
        guard let AddTripInfoVC =  UIStoryboard.trip.addTripInfoVC else {
            return
        }
        customNavigationController?.pushViewController(AddTripInfoVC, animated: true)

    }
}
