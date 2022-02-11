//
//  AddTripCityDescriptionHeaderCell.swift
//  MyMapp
//
//  Created by Chirag Pandya on 11/11/21.
//

import UIKit
import IQKeyboardManagerSwift

protocol AddTripCityDescriptionHeaderProtoCol {
    func getDescriptionContentString(textContent:String)
}

class AddTripCityDescriptionHeaderCell: UITableViewCell,UITextViewDelegate{
    var cityDescriptionHeaderProtoColDelegate: AddTripCityDescriptionHeaderProtoCol?
    
    @IBOutlet weak var viewDescription: UIView!
    @IBOutlet weak var txtDescription: IQTextView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        txtDescription.tintColor = .App_BG_SeafoamBlue_Color
        self.txtDescription.delegate = self
        self.viewDescription.layer.borderColor = UIColor.App_BG_Textfield_Unselected_Border_Color.cgColor
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        let newText = (textView.text as NSString).replacingCharacters(in: range, with: text)
        let numberOfChars = newText.count
        print(numberOfChars)
        return numberOfChars < 600
    }
    
    func textViewDidChange(_ textView: UITextView) {
        if textView.text.count == 0{
            self.viewDescription.layer.borderColor = UIColor.App_BG_Textfield_Unselected_Border_Color.cgColor
            cityDescriptionHeaderProtoColDelegate?.getDescriptionContentString(textContent: textView.text)
        }else{
            self.viewDescription.layer.borderColor = UIColor.App_BG_SeafoamBlue_Color.cgColor
            cityDescriptionHeaderProtoColDelegate?.getDescriptionContentString(textContent: textView.text)
        }
    }
}
