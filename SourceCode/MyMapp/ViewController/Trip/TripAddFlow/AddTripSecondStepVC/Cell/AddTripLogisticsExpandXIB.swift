//
//  AddTripLogisticsExpandXIB.swift
//  MyMapp
//
//  Created by Chirag Pandya on 13/11/21.
//

import UIKit
import IQKeyboardManagerSwift

protocol AddTripLogisticsExpandProtocol {
    func getDataLogistics(DataString:String)
}

class AddTripLogisticsExpandXIB: UITableViewCell,UITextViewDelegate{
    
    @IBOutlet weak var btnTitleExpand: UIButton!
    @IBOutlet weak var txtviewLogistics: IQTextView!
    
    var AddTripLogisticsExpandDelegate : AddTripLogisticsExpandProtocol?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        txtviewLogistics.tintColor = .App_BG_SeafoamBlue_Color
        self.txtviewLogistics.delegate = self
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        let newText = (textView.text as NSString).replacingCharacters(in: range, with: text)
        let numberOfChars = newText.count
        return numberOfChars < 250
    }
    
    
    func textViewDidChange(_ textView: UITextView) {
        
        if textView.text.count == 0
        {
            AddTripLogisticsExpandDelegate?.getDataLogistics(DataString: textView.text)
        }
        else
        {
            
            AddTripLogisticsExpandDelegate?.getDataLogistics(DataString: textView.text)
        }
        
    }
    
}
