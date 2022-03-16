//
//  SearchHeaderXIB.swift
//  MyMapp
//
//  Created by Chirag Pandya on 14/11/21.
//

import UIKit

class SearchHeaderXIB: UITableViewCell {

    @IBOutlet weak var labelTitle: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        labelTitle.font = UIFont.Montserrat.SemiBold(20)
        labelTitle.textColor = .App_BG_SecondaryDark2_Color
        labelTitle.numberOfLines = 1
        
    }
}
