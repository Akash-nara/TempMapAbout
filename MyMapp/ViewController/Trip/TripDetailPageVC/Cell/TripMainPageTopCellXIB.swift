//
//  TripMainPageTopCellXIB.swift
//  MyMapp
//
//  Created by Chirag Pandya on 05/12/21.
//

import UIKit

class TripMainPageTopCellXIB: UITableViewCell {

    @IBOutlet weak var imgviewExpand: UIImageView!
    @IBOutlet weak var lblHeader: UILabel!
    @IBOutlet weak var viewExpand: UIControl!

    @IBOutlet weak var btnTitleExpand: UIButton!
    @IBOutlet weak var buttonBookmark: UIButton!
    @IBOutlet weak var trealingViewExpand: NSLayoutConstraint!

    override func awakeFromNib() {
        super.awakeFromNib()

        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
