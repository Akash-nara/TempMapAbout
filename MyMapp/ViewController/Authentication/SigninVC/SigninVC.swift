//
//  SigninVC.swift
//  MyMapp
//
//  Created by Chirag Pandya on 01/11/21.
//

import UIKit
import SwiftyJSON

class SigninVC: UIViewController,UITextFieldDelegate{
    
    //MARK: - OUTLETS
    @IBOutlet weak var txtEmailAddress:UITextField!
    @IBOutlet weak var txtPassword:UITextField!
    @IBOutlet weak var btnTitleSignin:UIButton!
    
    //MARK: - VARIABLES
    var loginViewModel = LoginViewModel()
    
    //MARK: - VIEW DID LOAD
    override func viewDidLoad() {
        super.viewDidLoad()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1, execute: {
            self.btnTitleSignin.dropShadowButton()
        })
        
        txtEmailAddress.tintColor = .App_BG_SeafoamBlue_Color
        txtPassword.tintColor = .App_BG_SeafoamBlue_Color
        
        txtEmailAddress.textContentType = .username
        txtPassword.textContentType = .password
        
        self.txtEmailAddress.delegate = self
        self.txtPassword.delegate = self
        self.txtEmailAddress.tag = 1
        self.txtPassword.tag = 2
        
        txtEmailAddress.addTarget(self, action: #selector(SigninVC.textFieldDidChange(textField:)), for: UIControl.Event.editingChanged)
        txtPassword.addTarget(self, action: #selector(SigninVC.textFieldDidChange(textField:)), for: UIControl.Event.editingChanged)
        self.txtEmailAddress.layer.borderColor = UIColor.App_BG_Textfield_Unselected_Border_Color.cgColor
        self.txtPassword.layer.borderColor = UIColor.App_BG_Textfield_Unselected_Border_Color.cgColor
        
        txtEmailAddress.text = "akashnara123@gmail.com"
        txtPassword.text = "Smart@123"
    }
    
    //MARK: - BUTTON ACTIONS
    @IBAction func btnHandlerback(_ sender: Any){
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnHandlerForgotPassword(_ sender: Any){
        guard let forgotVC =  UIStoryboard.authentication.forgotPasswordVC else {
            return
        }
        self.navigationController?.pushViewController(forgotVC, animated: true)
    }
    
    @IBAction func btnHandlerSignin(_ sender: Any){
        if self.txtEmailAddress.text?.count == 0{
            Utility.errorMessage(message: LocalValidation.enterEmail)
            return
        }
        
        if InputValidator.isValidEmail(testStr: self.txtEmailAddress.text!) == false{
            Utility.errorMessage(message: LocalValidation.enterValidemail)
            return
        }
        
        if self.txtPassword.text == ""{
            Utility.errorMessage(message: LocalValidation.enterPassword)
            return
        }
        let strJson = JSON(["emailId": self.txtEmailAddress.text!,
                            "password": self.txtPassword.text! ]).rawString(.utf8, options: .sortedKeys) ?? ""
        let param: [String: Any] = ["requestJson" : strJson]
        loginViewModel.loginApi(param) { responseMsg in
            Utility.successMessage(message: responseMsg)
            
            appDelegateShared.checkRedirectionFlow()
        }
    }
    
    //MARK: - OTHER FUNCTIONS
    @objc func textFieldDidChange(textField : UITextField){
        if textField.tag == 1{
            if textField.text?.count == 0{
                self.txtEmailAddress.layer.borderColor = UIColor.App_BG_Textfield_Unselected_Border_Color.cgColor
            }else{
                self.txtEmailAddress.layer.borderColor = UIColor.App_BG_SeafoamBlue_Color.cgColor
            }
        }else{
            if textField.text?.count == 0{
                self.txtPassword.layer.borderColor = UIColor.App_BG_Textfield_Unselected_Border_Color.cgColor
            }else{
                self.txtPassword.layer.borderColor = UIColor.App_BG_SeafoamBlue_Color.cgColor
            }
        }
    }
}
