//
//  ResetPasswordVC.swift
//  MyMapp
//
//  Created by Chirag Pandya on 04/11/21.
//

import UIKit
import SVPinView

class ResetPasswordVC: UIViewController,UITextFieldDelegate{
    
    //MARK: - OUTLETS
    @IBOutlet weak var viewPin:SVPinView!
    @IBOutlet weak var txtNewPassword:UITextField!
    @IBOutlet weak var txtConfirmPassword:UITextField!
    @IBOutlet weak var btnTitleSubmit:UIButton!
    
    //MARK: - VIEW DID LOAD
    override func viewDidLoad() {
        super.viewDidLoad()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1, execute: {
            self.btnTitleSubmit.dropShadowButton()
        })
        
        viewPin.pinLength = 6
        viewPin.secureCharacter = "\u{25CF}"
        viewPin.interSpace = 5
        viewPin.textColor = UIColor.black
        viewPin.shouldSecureText = false
        viewPin.style = .box
        viewPin.backgroundColor = UIColor.white
        viewPin.borderLineColor = UIColor.App_BG_Textfield_Unselected_Border_Color
        viewPin.activeBorderLineColor = UIColor.App_BG_SeafoamBlue_Color
        viewPin.borderLineThickness = 1
        viewPin.activeBorderLineThickness = 1
        viewPin.layer.cornerRadius = 5
        
        viewPin.font = UIFont.Montserrat.SemiBold(dynamicFontSize(17))
        viewPin.keyboardType = .numberPad
        viewPin.placeholder = ""
        viewPin.fieldCornerRadius = 6
        viewPin.activeFieldCornerRadius = 6
        
        
        self.txtNewPassword.delegate = self
        self.txtConfirmPassword.delegate = self
        self.txtNewPassword.tag = 1
        self.txtConfirmPassword.tag = 2
        
        txtNewPassword.addTarget(self, action: #selector(ResetPasswordVC.textFieldDidChange(textField:)), for: UIControl.Event.editingChanged)
        txtConfirmPassword.addTarget(self, action: #selector(ResetPasswordVC.textFieldDidChange(textField:)), for: UIControl.Event.editingChanged)
        self.txtNewPassword.layer.borderColor = UIColor.App_BG_Textfield_Unselected_Border_Color.cgColor
        self.txtConfirmPassword.layer.borderColor = UIColor.App_BG_Textfield_Unselected_Border_Color.cgColor
    }
    
    //MARK: - BUTTON ACTIONS
    @IBAction func btnHandlerResend(sender:UIButton){
        
    }
    
    @IBAction func btnHandlerSubmit(sender:UIButton){
        if self.viewPin.getPin().count != 6{
            Utility.errorMessage(message: LocalValidation.otpNotempty)
            return
        }
        
        if self.txtNewPassword.text == ""{
            Utility.errorMessage(message: LocalValidation.enterNewpassword)
            return
        }
        
        if self.txtConfirmPassword.text == ""{
            Utility.errorMessage(message: LocalValidation.enterConfirmpassword)
            return
        }
        
        if self.txtNewPassword.text != self.txtConfirmPassword.text{
            Utility.errorMessage(message: LocalValidation.newPasswordnotmatched)
            return
        }
    }
    
    @IBAction func btnHandlerback(sender:UIButton){
        self.navigationController?.popViewController(animated: true)
    }
    
    //MARK: - OTHER FUNCTIONS
    @objc func textFieldDidChange(textField : UITextField){
        if textField.tag == 1{
            if textField.text?.count == 0{
                self.txtNewPassword.layer.borderColor = UIColor.App_BG_Textfield_Unselected_Border_Color.cgColor
            }else{
                self.txtNewPassword.layer.borderColor = UIColor.App_BG_SeafoamBlue_Color.cgColor
            }
        }else{
            if textField.text?.count == 0{
                self.txtConfirmPassword.layer.borderColor = UIColor.App_BG_Textfield_Unselected_Border_Color.cgColor
            }else{
                self.txtConfirmPassword.layer.borderColor = UIColor.App_BG_SeafoamBlue_Color.cgColor
            }
        }
    }    
}
