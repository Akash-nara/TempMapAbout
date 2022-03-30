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
        imageTrip.cornerRadius = 15
        imageTrip.borderColor = .App_BG_SecondaryDark2_Color
        imageTrip.borderWidth = 0.1
        imageTrip.contentMode = .scaleAspectFit

    }
    
    
    func configureCell(dataModel:TripDataModel, completion: ((Bool,Int) -> Void)? = nil){
        labelBookmarkCount.text = "\(dataModel.bookmarkedTotalCount)"
        labelBookmarkCount.isHidden = dataModel.bookmarkedTotalCount.isZero()
        tripTitle.text = dataModel.city.cityName
        tripSubTitle.text = dataModel.city.countryName
        
        var defaultKey = dataModel.defaultImageKey
        if defaultKey.isEmpty, let firstObject = dataModel.photoUploadedArray.first?.arrayOfImageURL.first{
            defaultKey = firstObject.image
        }
        
        if !defaultKey.isEmpty{
            
            self.imageTrip.sd_setImage(with: URL.init(string: defaultKey), placeholderImage: nil, options: .highPriority) { [weak self] img, error, cache, url in
                
                if let image = img{
                    self?.imageTrip.image = image
                    //since the width > height we may fit it and we'll have bands on top/bottom
                    self?.imageTrip.contentMode = .scaleAspectFill
                }else{
                    //width < height we fill it until width is taken up and clipped on top/bottom
                    self?.imageTrip.contentMode = .scaleToFill
                    if let foundImage = dataModel.photoUploadedArray.first?.arrayOfImageURL.first?.image, !foundImage.isEmpty{
                        self?.imageTrip.setImage(url: foundImage, placeholder: UIImage.init(named: "not_icon"))
                    }else{
                        self?.imageTrip.image = UIImage.init(named: "not_icon")
                    }
                }
                
                if let image = img,image.isImageVerticle{
                    completion?(true, self?.imageTrip.tag ?? 0)
                }else{
                    completion?(false, self?.imageTrip.tag ?? 0)
                }
            }
            self.imageTrip.clipsToBounds = true
        }else{
            //            startAnimating()
            self.imageTrip.backgroundColor = .clear
            self.imageTrip.contentMode = .scaleToFill
            self.imageTrip.image = UIImage.init(named: "not_icon")
            //            self.imgviewBG.image = UIImage.init(named: "ic_Default_city_image_one")
        }
    }
}
