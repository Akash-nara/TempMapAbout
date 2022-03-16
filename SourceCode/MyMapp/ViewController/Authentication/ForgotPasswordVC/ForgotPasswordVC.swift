//
//  ForgotPasswordVC.swift
//  MyMapp
//
//  Created by Chirag Pandya on 01/11/21.
//

import UIKit
import SwiftyJSON

class ForgotPasswordVC: UIViewController,UITextFieldDelegate{
    
    //MARK: - OUTLETS
    @IBOutlet weak var txtEmailAddress:UITextField!
    @IBOutlet weak var btnSubmit:UIButton!
    
    //MARK: - VARIABLES
    var forgotViewModel = ForgotPasswordViewModel()
    
    //MARK: - VIEW DID LOAD
    override func viewDidLoad() {
        super.viewDidLoad()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1, execute: {
            self.btnSubmit.dropShadowButton()
        })
        
        self.txtEmailAddress.delegate = self
        self.txtEmailAddress.tag = 1
        txtEmailAddress.tintColor = .App_BG_SeafoamBlue_Color

        txtEmailAddress.addTarget(self, action: #selector(ForgotPasswordVC.textFieldDidChange(textField:)), for: UIControl.Event.editingChanged)
        self.txtEmailAddress.layer.borderColor = UIColor.App_BG_Textfield_Unselected_Border_Color.cgColor
    }
    
    //MARK: - BUTTON ACTIONS
    @IBAction func btnHandlerForgotPassword(_ sender: Any){
        if self.txtEmailAddress.text?.count == 0{
            Utility.errorMessage(message: LocalValidation.enterEmail)
            return
        }
        
        if InputValidator.isValidEmail(testStr: self.txtEmailAddress.text!) == false{
            Utility.errorMessage(message: LocalValidation.enterValidemail)
            return
        }
        
        let strJson = JSON(["emailId": self.txtEmailAddress.text?.removeWhiteSpace() ?? ""]).rawString(.utf8, options: .sortedKeys) ?? ""
        let param: [String: Any] = ["requestJson" : strJson]
        forgotViewModel.forgotpasswordAPI(param) { (response) in
            Utility.successMessage(message: response)
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    @IBAction func btnHandlerback(_ sender: Any){
        self.navigationController?.popViewController(animated: true)
    }
    
    //MARK: - OTHER FUNCTIONS
    @objc func textFieldDidChange(textField : UITextField){
        if textField.text?.count == 0{
            self.txtEmailAddress.layer.borderColor = UIColor.App_BG_Textfield_Unselected_Border_Color.cgColor
        }else{
            self.txtEmailAddress.layer.borderColor = UIColor.App_BG_SeafoamBlue_Color.cgColor
        }
    }
}
