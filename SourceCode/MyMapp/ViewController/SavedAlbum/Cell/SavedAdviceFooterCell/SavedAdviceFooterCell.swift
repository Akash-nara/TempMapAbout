//
//  SavedAdviceFooterCell.swift
//  MyMapp
//
//  Created by Akash  on 03/04/22.
//

import UIKit

class SavedAdviceFooterCell: UITableViewCell {

    static private var readmoreDataCount = 5
    
    static func getHeight(isOpenCell: Bool, dataCount: Int) -> CGFloat {
        if isOpenCell {
            return dataCount < readmoreDataCount ? 35 : 53
        } else {
            return 15
        }
    }

    @IBOutlet weak var viewBottom: UIView!
    @IBOutlet weak var buttonReadMore: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code

//        backgroundColor = UIColor.red
//        buttonReadMore.backgroundColor = UIColor.green
        selectionStyle = .none
        viewBottom.selectedCorners(radius: 20, [.bottomLeft, .bottomRight])
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func cellConfig(isOpenCell: Bool, dataCount: Int) {
        viewBottom.isHidden = !isOpenCell
        buttonReadMore.isHidden = dataCount < SavedAdviceFooterCell.readmoreDataCount
    }
    
}
