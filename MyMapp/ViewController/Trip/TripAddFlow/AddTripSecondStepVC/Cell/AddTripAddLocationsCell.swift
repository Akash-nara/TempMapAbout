//
//  AddTripAddLocationsCell.swift
//  MyMapp
//
//  Created by Chirag Pandya on 12/11/21.
//

import UIKit

class AddTripAddLocationsCell: UITableViewCell {
    
    @IBOutlet weak var btnHandlerGooglePicker: UIButton!{
        didSet{
            self.btnHandlerGooglePicker.layer.borderColor = UIColor.App_BG_Textfield_Unselected_Border_Color.cgColor
            self.btnHandlerGooglePicker.layer.borderWidth = 1.0
            self.btnHandlerGooglePicker.layer.cornerRadius = 25.0
        }
    }
    @IBOutlet weak var btnTitleRemove: UIButton!
    @IBOutlet weak var btnTitleAddDetails: UIButton!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
}
