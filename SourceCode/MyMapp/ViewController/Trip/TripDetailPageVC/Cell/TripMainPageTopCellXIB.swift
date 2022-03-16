//
//  TripMainPageTopCellXIB.swift
//  MyMapp
//
//  Created by Chirag Pandya on 05/12/21.
//

import UIKit

class TripMainPageTopCellXIB: UITableViewCell {

    @IBOutlet weak var buttonArrow: UIButton!
    @IBOutlet weak var lblHeader: UILabel!
    @IBOutlet weak var viewExpand: UIView!
    @IBOutlet weak var labelSubTitle: UILabel!

    @IBOutlet weak var buttonBookmark: UIButton!
    @IBOutlet weak var trealingViewExpand: NSLayoutConstraint!
    @IBOutlet weak var bottomConstrainOfMainStackView: NSLayoutConstraint!

    override func awakeFromNib() {
        super.awakeFromNib()

        // Initialization code
    }
    
    @IBAction func controllExpandTap(_ sender:UIControl){
        
    }
}
