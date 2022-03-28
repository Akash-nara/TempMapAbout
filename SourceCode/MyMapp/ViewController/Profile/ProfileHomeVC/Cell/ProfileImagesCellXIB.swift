//
//  ProfileImagesCellXIB.swift
//  MyMapp
//
//  Created by Chirag Pandya on 14/11/21.
//

import UIKit
import SkeletonView

class ProfileImagesCellXIB: UICollectionViewCell {
    
    @IBOutlet weak var btnTitleRemove: UIButton!
    @IBOutlet weak var btnAddimage: UIButton!
    @IBOutlet weak var BottomStackView: UIStackView!
    @IBOutlet weak var TopStackView: UIStackView!
    @IBOutlet weak var imgviewBG: UIImageView!
    
    @IBOutlet weak var tripTitle: UILabel!
    @IBOutlet weak var tripSubTitle: UILabel!
    @IBOutlet weak var tripOfDays: UILabel!
    @IBOutlet weak var widthCancelButton: NSLayoutConstraint!
    @IBOutlet weak var skeletonView: UIView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        imgviewBG.cornerRadius = 15
        imgviewBG.borderColor = .App_BG_SecondaryDark2_Color
        imgviewBG.borderWidth = 0.1
        imgviewBG.contentMode = .scaleAspectFit
        imgviewBG.isSkeletonable = true
        self.skeletonView.isHidden = true
        
    }
    func startAnimating() {
//        self.skeletonView.isHidden = false
        self.imgviewBG.showAnimatedSkeleton()
    }
    
    func stopAnimating() {
//        self.skeletonView.isHidden = true
        self.imgviewBG.hideSkeleton()
    }
    
    func loadCellData(objTripModel:TripDataModel, completion: ((Bool,Int, CGFloat) -> Void)? = nil) {
        
        btnTitleRemove.isHidden = true
        btnAddimage.isHidden = true
        tripTitle.text = objTripModel.city.cityName
        tripTitle.numberOfLines = 3
        tripSubTitle.text = objTripModel.city.countryName
        tripOfDays.text = objTripModel.dateFromatedOftrip
        widthCancelButton.constant = 0
        
        self.startAnimating()
        if let firstObject = objTripModel.photoUploadedArray.first?.arrayOfImageURL.first{
            let urlStr = objTripModel.defaultImageKey.isEmpty ? firstObject.image : objTripModel.defaultImageKey
            imgviewBG.sd_setImage(with: URL.init(string: urlStr), placeholderImage: nil, options: .highPriority) { [self] img, error, cache, url in
                self.stopAnimating()
                self.imgviewBG.image = img
                
                if let image = img, image.isImageVerticle{
                    //since the width > height we may fit it and we'll have bands on top/bottom
                    self.imgviewBG.contentMode = .scaleAspectFill
                    completion?(true, self.imgviewBG.tag, imgviewBG.image?.getHeight ?? 0)
                }else{
                    //width < height we fill it until width is taken up and clipped on top/bottom
                    self.imgviewBG.contentMode = .scaleToFill
                    completion?(false,self.imgviewBG.tag, imgviewBG.image?.getHeight ?? 0)
                }
            }
            self.imgviewBG.clipsToBounds = true
        }else{
//            startAnimating()
            self.imgviewBG.backgroundColor = .clear
            self.imgviewBG.contentMode = .scaleToFill
//            self.imgviewBG.image = UIImage.init(named: "ic_Default_city_image_one")
        }
    }
}

extension UIImage{
    var isImageVerticle:Bool{
        if self.size.width > self.size.height {
            return false
        }else{
            return true
        }
    }
}
