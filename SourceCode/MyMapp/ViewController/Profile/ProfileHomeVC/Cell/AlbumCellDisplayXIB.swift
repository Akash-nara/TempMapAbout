//
//  AlbumCellDisplayXIB.swift
//  MyMapp
//
//  Created by Chirag Pandya on 04/12/21.
//

import UIKit
import SkeletonView

class AlbumCellDisplayXIB: UICollectionViewCell {

    @IBOutlet weak var tripTitle: UILabel!
    @IBOutlet weak var tripSubTitle: UILabel!
    @IBOutlet weak var labelBookmarkCount: UILabel!
    @IBOutlet weak var buttonSaved: UIButton!
    @IBOutlet weak var imageTrip: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        imageTrip.isSkeletonable = true
    }
}
