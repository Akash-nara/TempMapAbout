//
//  TripImageView.swift
//  MyMapp
//
//  Created by Akash Nara on 05/03/22.
//

import UIKit

class TripImageView: UIView {

    @IBOutlet weak var imageViewPhoto: UIImageView!
    @IBOutlet weak var sketonView: UIView!

    var view: UIView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        nibSetup()
        initSetup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        nibSetup()
        initSetup()
    }
    
    // MARK: - User Defined Methods
    private func nibSetup() {
        backgroundColor = UIColor.clear
        view = loadViewFromNib()
        view.frame = bounds
        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.translatesAutoresizingMaskIntoConstraints = true
        addSubview(view)
    }
    
    private func loadViewFromNib() -> UIView {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: String(describing: type(of: self)), bundle: bundle)
        let nibView = nib.instantiate(withOwner: self, options: nil).first as! UIView
        nibView.backgroundColor = UIColor.clear
        return nibView
    }
    
    func initSetup() {
        backgroundColor = UIColor.white
        view.backgroundColor = UIColor.white
    }
    
    func configureSkelton(){
        sketonView.isSkeletonable = true
        sketonView.layer.cornerRadius = 15
        sketonView.clipsToBounds = true
    }
    func startAnimating() {
        sketonView.isHidden = false
        sketonView.showAnimatedSkeleton()
    }

    func stopAnimating() {
        sketonView.hideSkeleton()
        sketonView.isHidden = true
    }

    func setData(image: String) {
        imageViewPhoto.image = UIImage(named: image)
    }
    
    func cellConfig(obj: TripDataModel.TripPhotoDetails.TripImage) {
        let img = obj.image
        configureSkelton()
        startAnimating()
        imageViewPhoto.sd_setImage(with: URL.init(string: img), placeholderImage: nil, options: .highPriority) { img, error, cache, url in
            self.imageViewPhoto.image = img
            //            self.stopAnimating()
            if let sizeOfImage = self.imageViewPhoto.image?.size, sizeOfImage.width > sizeOfImage.height {
                //since the width > height we may fit it and we'll have bands on top/bottom
                self.imageViewPhoto.contentMode = .scaleAspectFill
                //                self.photoUploadedArray[indexPath.section].arrayOfImageURL[indexPath.row].isVerticle = true
                //                self.arrayOfImageURL[indexPath.row].isVerticle = true
            } else {
                //width < height we fill it until width is taken up and clipped on top/bottom
                self.imageViewPhoto.contentMode = .scaleToFill
                //                self.arrayOfImageURL[indexPath.row].isVerticle = false
                //                self.photoUploadedArray[indexPath.section].arrayOfImageURL[indexPath.row].isVerticle = false
            }
            
            if obj.isVerticle{
                self.imageViewPhoto.contentMode = .scaleAspectFill
            }else{
                self.imageViewPhoto.contentMode = .scaleToFill
            }
            
            if let lodedImage = img{
                self.stopAnimating()
                self.imageViewPhoto.cornerRadius = 15
                self.imageViewPhoto.image = lodedImage //.withRoundedCorners(radius: 15)
            }
        }
    }

}
