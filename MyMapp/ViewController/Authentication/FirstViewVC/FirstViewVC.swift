//
//  FirstViewVC.swift
//  MyMapp
//
//  Created by Chirag Pandya on 30/10/21.
//

import UIKit

class FirstViewVC: UIViewController {
    
    //MARK: - OUTLETS
    @IBOutlet weak var btnTitleJoinCoounity: UIButton!{
        didSet{}
    }
    
    //MARK: - VIEW DID LOAD
    override func viewDidLoad() {
        super.viewDidLoad()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1, execute: {
            self.btnTitleJoinCoounity.dropShadowButton()
        })
    }
    
    //MARK: - BUTTON ACTIONS
    @IBAction func btnHandlerJoinCommunity(_ sender: Any){
        guard let signupVC =  UIStoryboard.authentication.signupVC else {
            return
        }
        self.navigationController?.pushViewController(signupVC, animated: true)
    }
    
    @IBAction func btnHandlerLogin(_ sender: Any){
        guard let signinVC =  UIStoryboard.authentication.signinVC else {
            return
        }
        self.navigationController?.pushViewController(signinVC, animated: true)
    }
}
