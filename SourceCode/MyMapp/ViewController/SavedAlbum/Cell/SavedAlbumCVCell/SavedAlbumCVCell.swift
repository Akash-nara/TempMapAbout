//
//  SavedAlbumCVCell.swift
//  MyMapp
//
//  Created by smartsense ConsultingSolutions on 02/04/22.
//

import UIKit

class SavedAlbumCVCell: UICollectionViewCell {

    static let cellSize = CGSize(width: 155, height: 155)
    
    @IBOutlet weak var imageViewPhoto: UIImageView!
    @IBOutlet weak var labelTripDate: UILabel!

    @IBOutlet weak var imageViewProfilePic: UIImageView!
    @IBOutlet weak var labelUsername: UILabel!
    @IBOutlet weak var buttonUser: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func cellConfig(data: TripDataModel) {
        labelTripDate.text = data.dateFromatedOftrip
        labelUsername.text = data.userCreatedTrip?.displayName
        imageViewPhoto.backgroundColor = UIColor.green
        imageViewProfilePic.backgroundColor = UIColor.red
        
        imageViewPhoto.contentMode = .scaleToFill
        imageViewPhoto.setImage(url: data.defaultImageKey, placeholder: UIImage.init(named: "not_icon"))
        imageViewPhoto.setBorderWithColor()
        
        imageViewProfilePic.setImage(url: data.userCreatedTrip?.profilePicPath ?? "", placeholder: UIImage.init(named: "not_icon"))
        imageViewProfilePic.setBorderWithColor()
    }
    
}
