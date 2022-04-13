//
//  AddTripTopExpandXIB.swift
//  MyMapp
//
//  Created by Chirag Pandya on 13/11/21.
//

import UIKit
import IQKeyboardManagerSwift

protocol AddTripTopExpandProtocol {
    
    func getData(dataString:String, indexRow:Int)
}

class AddTripTopExpandXIB: UITableViewCell,UITextViewDelegate{

    @IBOutlet weak var txtviewTopTip: IQTextView!
    @IBOutlet weak var btnTitleExpand: UIButton!
    @IBOutlet weak var labelTitle: UILabel!

    var AddTripTopExpandDelegate : AddTripTopExpandProtocol?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        txtviewTopTip.tintColor = .App_BG_SeafoamBlue_Color
        self.txtviewTopTip.delegate = self
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        let newText = (textView.text as NSString).replacingCharacters(in: range, with: text)
        let numberOfChars = newText.count
        return numberOfChars < 250
    }
    
    func textViewDidChange(_ textView: UITextView) {
        if textView.text.count == 0{
            AddTripTopExpandDelegate?.getData(dataString: textView.text, indexRow: textView.tag)
        }else{
            AddTripTopExpandDelegate?.getData(dataString: textView.text,indexRow: textView.tag)
        }
    }
}
