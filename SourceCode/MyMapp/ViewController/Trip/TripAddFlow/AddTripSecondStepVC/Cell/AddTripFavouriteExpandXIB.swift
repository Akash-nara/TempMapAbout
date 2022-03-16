//
//  AddTripFavouriteExpandXIB.swift
//  MyMapp
//
//  Created by Chirag Pandya on 13/11/21.
//

import UIKit
import IQKeyboardManagerSwift

protocol AddTripFavouriteExpandProtocol {
    
    func getDataFavourite(DataString:String)
}


class AddTripFavouriteExpandXIB: UITableViewCell,UITextViewDelegate{

    @IBOutlet weak var btnTitleExpand: UIButton!
    @IBOutlet weak var txtviewFavourite: IQTextView!

    var AddTripFavouriteExpandDelegate : AddTripFavouriteExpandProtocol?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        txtviewFavourite.tintColor = .App_BG_SeafoamBlue_Color
        self.txtviewFavourite.delegate = self
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
            AddTripFavouriteExpandDelegate?.getDataFavourite(DataString: textView.text)
        }
        else
        {
            
            AddTripFavouriteExpandDelegate?.getDataFavourite(DataString: textView.text)
        }
        
    }
    
}
