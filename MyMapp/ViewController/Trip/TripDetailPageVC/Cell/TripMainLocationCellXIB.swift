//
//  TripMainLocationCellXIB.swift
//  MyMapp
//
//  Created by Chirag Pandya on 05/12/21.
//

import UIKit

class TripMainLocationCellXIB: UITableViewCell {

    @IBOutlet weak var labelTitle : UILabel!
    @IBOutlet weak var subTitle : UILabel!
    @IBOutlet weak var buttonBookmark : UIButton!
    @IBOutlet weak var locationImage : UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
