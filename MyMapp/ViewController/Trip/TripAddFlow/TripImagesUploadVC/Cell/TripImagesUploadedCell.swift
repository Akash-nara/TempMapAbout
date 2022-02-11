//
//  TripImagesUploadedCell.swift
//  MyMapp
//
//  Created by Chirag Pandya on 12/12/21.
//

import UIKit

class TripImagesUploadedCell: UICollectionViewCell {

    @IBOutlet weak var buttonRadioSelection: UIButton!
    @IBOutlet weak var imgTrip: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
//    func startAnimating() {
//        self.skeletonView.isHidden = false
//        self.skeletonView.showAnimatedSkeleton()
//    }
//
//    func stopAnimating() {
//        self.skeletonView.isHidden = true
//        self.skeletonView.hideSkeleton()
//    }
    
    func loadCellData(objTripModel:TripImagesModel) {
        
//        self.startAnimating()
        self.imgTrip.image = objTripModel.image
        if objTripModel.isVerticalImage {
            //since the width > height we may fit it and we'll have bands on top/bottom
            self.imgTrip.contentMode = .scaleAspectFill
        } else {
            //width < height we fill it until width is taken up and clipped on top/bottom
            self.imgTrip.contentMode = .scaleToFill
        }
        
        /*
        if let firstObject = URL.init(string: objTripModel.url){
            
            imgTrip.sd_setImage(with: firstObject, placeholderImage: nil, options: .highPriority) { [self] img, error, cache, url in
                self.imgTrip.image = img
//                self.stopAnimating()
                if let sizeOfImage = self.imgTrip.image?.size, sizeOfImage.width > sizeOfImage.height {
                    
                    //since the width > height we may fit it and we'll have bands on top/bottom
                    self.imgTrip.contentMode = .scaleAspectFill
                    completion?(true, self.imgTrip.tag, imgTrip.image?.getHeight ?? 0)
                } else {
                    //width < height we fill it until width is taken up and clipped on top/bottom
                    self.imgTrip.contentMode = .scaleToFill
                    completion?(false,self.imgTrip.tag, imgTrip.image?.getHeight ?? 0)
                }
            }
            
            self.imgTrip.clipsToBounds = true
        }else{
            self.imgTrip.contentMode = .scaleToFill
            self.imgTrip.image = UIImage.init(named: "ic_Default_city_image_one")
//            self.stopAnimating()
            
        }*/
    }

}
