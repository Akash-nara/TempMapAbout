//
//  TripMainLocationCellXIB.swift
//  MyMapp
//
//  Created by Chirag Pandya on 05/12/21.
//

import UIKit
import TagListView
class TripMainLocationCellXIB: UITableViewCell {

    @IBOutlet weak var labelTitle : UILabel!
    @IBOutlet weak var subTitle : UILabel!
    @IBOutlet weak var buttonBookmark : UIButton!
    @IBOutlet weak var locationImage : UIImageView!
    @IBOutlet weak var tagListView : TagListView!

    override func awakeFromNib() {
        super.awakeFromNib()
        
        locationImage.contentMode = .scaleToFill
        // Initialization code
        
//        tagListView.textFont = UIFont.Montserrat.Medium(14)
//        tagListView.addTag("Architecture")
//        tagListView.addTag("Landscape")
//        tagListView.addTag("Design")
//        tagListView.alignment = .center
//        tagListView.alignment = .left
//        tagListView.enableRemoveButton = false
//        tagListView.paddingX = 10
//        tagListView.paddingY = 10
//        let width = tagListView.tagViews.map { $0.frame.width }.reduce(0, +)
//        tagListView.constant = width + CGFloat(10 * tagListView.tagViews.count)


    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
