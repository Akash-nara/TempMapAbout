//
//  TripAddedSuccessFullVC.swift
//  MyMapp
//
//  Created by Chirag Pandya on 21/11/21.
//

import UIKit

class TripAddedSuccessFullVC: UIViewController {
    
    //MARK: - OUTLETS
    @IBOutlet weak var btnTitleGoToFeed:UIButton!
    
    //MARK: - VIEW DID LOAD
    override func viewDidLoad() {
        super.viewDidLoad()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1, execute: {
            self.btnTitleGoToFeed.dropShadowButton()
        })
    }
    
    //MARK: - BUTTON ACTIONS
    @IBAction func btnHandlerGoToFeed(sender:UIButton){
        appDelegateShared.setTabbarRoot()
    }
}
