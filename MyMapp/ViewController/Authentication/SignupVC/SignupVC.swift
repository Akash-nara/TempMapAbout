//
//  SignupVC.swift
//  MyMapp
//
//  Created by Chirag Pandya on 30/10/21.
//

import UIKit
import SwiftyJSON

class SignupVC: UIViewController,UITextFieldDelegate{
    
    //MARK: - OUTLETS
    @IBOutlet weak var btnTitleSignup: UIButton!
    @IBOutlet weak var txtEmailAddress:UITextField!
    @IBOutlet weak var txtPassword:UITextField!
    @IBOutlet weak var txtConfirmPassword:UITextField!
    
    var signupViewModel = SignupViewModel()
    
    //MARK: - VIEW DID LOAD
    override func viewDidLoad() {
        super.viewDidLoad()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1, execute: {
            
            self.btnTitleSignup.dropShadowButton()
        })
        
        txtPassword.tintColor = .App_BG_SeafoamBlue_Color
        txtEmailAddress.tintColor = .App_BG_SeafoamBlue_Color
        txtConfirmPassword.tintColor = .App_BG_SeafoamBlue_Color

        
        self.txtPassword.delegate = self
        self.txtEmailAddress.delegate = self
        self.txtConfirmPassword.delegate = self

        self.txtEmailAddress.tag = 1
        self.txtPassword.tag = 2
        self.txtConfirmPassword.tag = 3
        
        txtEmailAddress.addTarget(self, action: #selector(SignupVC.textFieldDidChange(textField:)), for: UIControl.Event.editingChanged)
        txtPassword.addTarget(self, action: #selector(SignupVC.textFieldDidChange(textField:)), for: UIControl.Event.editingChanged)
        txtConfirmPassword.addTarget(self, action: #selector(SignupVC.textFieldDidChange(textField:)), for: UIControl.Event.editingChanged)
        
        self.txtEmailAddress.layer.borderColor = UIColor.App_BG_Textfield_Unselected_Border_Color.cgColor
        self.txtPassword.layer.borderColor = UIColor.App_BG_Textfield_Unselected_Border_Color.cgColor
        self.txtConfirmPassword.layer.borderColor = UIColor.App_BG_Textfield_Unselected_Border_Color.cgColor
    }
    
    //MARK: - BUTTON ACTIONS
    @IBAction func btnHandlerback(_ sender: Any){
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnHandlerSignup(_ sender: Any){
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
        
        if self.txtConfirmPassword.text == ""{
            Utility.errorMessage(message: LocalValidation.enterConfirmpassword)
            return
        }
        
        if self.txtPassword.text != self.txtConfirmPassword.text{
            Utility.errorMessage(message: LocalValidation.passwordNotmatched)
            return
        }
        
        let strJson = JSON(["emailId": self.txtEmailAddress.text?.removeWhiteSpace() ?? "",
                            "password": self.txtPassword.text ?? ""]).rawString(.utf8, options: .sortedKeys) ?? ""
        
        let param: [String: Any] = ["requestJson" : strJson]
        signupViewModel.signupAPI(param) { (response) in
            print(response)
            Utility.successMessage(message: response)
            self.navigationController?.popViewController(animated: true)
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
        }
        
        if textField.tag == 2{
            if textField.text?.count == 0{
                self.txtPassword.layer.borderColor = UIColor.App_BG_Textfield_Unselected_Border_Color.cgColor
            }else{
                self.txtPassword.layer.borderColor = UIColor.App_BG_SeafoamBlue_Color.cgColor
            }
        }
        
        if textField.tag == 3{
            if textField.text?.count == 0{
                self.txtConfirmPassword.layer.borderColor = UIColor.App_BG_Textfield_Unselected_Border_Color.cgColor
            }else{
                self.txtConfirmPassword.layer.borderColor = UIColor.App_BG_SeafoamBlue_Color.cgColor
            }
        }
    }
}
