//
//  FeedTableViewCell.swift
//  MyMapp
//
//  Created by Akash on 16/02/22.
//

import UIKit
import SDWebImage

class FeedTableViewCell: UITableViewCell {
    
    @IBOutlet var carousel: iCarousel!
    @IBOutlet weak var postedUserPic: UIImageView!
    @IBOutlet weak var commentedUserPic: UIImageView!
    @IBOutlet weak var postedUserName: UILabel!
    @IBOutlet weak var postedUserAddress: UILabel!
    @IBOutlet weak var postedDate: UILabel!
    @IBOutlet weak var labelExpDescription: UILabel!
    @IBOutlet weak var labelTotalLikeCount: UILabel!
    @IBOutlet weak var labelTotaBookmarkCount: UILabel!
    @IBOutlet weak var textFieldComment: UITextField!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var pageControll: UIPageControl!
    
    @IBOutlet weak var buttonBookmark: UIButton!
    @IBOutlet weak var buttonLike: UIButton!
    
    var arrayOfImageURL: [TripDataModel.TripPhotoDetails.TripImage] = []
    fileprivate var currentPage: Int = 0 {
        didSet {
            pageControll.currentPage = currentPage
        }
    }
    
    fileprivate var pageSize: CGSize {
        let layout = self.collectionView.collectionViewLayout as! UPCarouselFlowLayout
        var pageSize = layout.itemSize
        pageSize.width += layout.minimumLineSpacing
        if layout.scrollDirection == .horizontal {
        } else {
            pageSize.height += layout.minimumLineSpacing
        }
        return pageSize
    }
    
    
    func setupLayout() {
        let layout = self.collectionView.collectionViewLayout as! UPCarouselFlowLayout
        layout.spacingMode = UPCarouselFlowLayoutSpacingMode.fixed(spacing: -50)
        layout.sideItemAlpha = 0.8
        layout.sideItemScale = 0.6
        //        layout.sideItemShift = 0.8
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        //        carousel.type = .rotary
        //        carousel.centerItemWhenSelected = true
        
        collectionView.contentInset = UIEdgeInsets.init(top: 0, left: 10, bottom: 0, right: 10)
        
        self.collectionView.registerCellNib(identifier: CarouselCollectionViewCell.identifier)
        setupLayout()
        commentedUserPic.setImage(url: APP_USER?.profilePicPath ?? "", placeholder: UIImage.init(named: "ic_user_image_defaulut_one"))
    }
    
    func configureCell(modelData:TripDataModel){
        labelExpDescription.text = modelData.tripDescription
        postedUserAddress.text = modelData.city.cityName+","+modelData.city.countryName
        postedDate.text = modelData.dateFromatedOftrip
        labelTotalLikeCount.text = "\(modelData.likedTotalCount)"
        labelTotaBookmarkCount.text = "\(modelData.bookmarkedTotalCount)"
        buttonBookmark.isSelected = modelData.isBookmarked
        buttonLike.isSelected = modelData.isLiked
        
        
        arrayOfImageURL.removeAll()
        modelData.photoUploadedArray.forEach { obj in
            obj.arrayOfImageURL.forEach { obj1 in
                arrayOfImageURL.append(obj1)
            }
        }
        
        pageControll.numberOfPages = arrayOfImageURL.count
        collectionView.reloadData()
        //        carousel.reloadData()
    }
}

/*
 extension FeedTableViewCell:iCarouselDataSource, iCarouselDelegate{
 func numberOfItems(in carousel: iCarousel) -> Int {
 return arrayOfImageURL.count
 }
 
 func carousel(_ carousel: iCarousel, viewForItemAt index: Int, reusing view: UIView?) -> UIView {
 var itemView: UIImageView
 
 //reuse view if available, otherwise create a new view
 if let view = view as? UIImageView {
 itemView = view
 } else {
 //don't do anything specific to the index within
 //this `if ... else` statement because the view will be
 //recycled and used with other index values later
 itemView = UIImageView(frame: CGRect(x: 0, y: 0, width: Int(arrayOfImageURL[index].width) ?? 0, height: 200))
 itemView.setImage(url: arrayOfImageURL[index].image, placeholder: nil)
 itemView.contentMode = .scaleToFill
 }
 itemView.cornerRadius = 15
 return itemView
 }
 
 func carousel(_ carousel: iCarousel, valueFor option: iCarouselOption, withDefault value: CGFloat) -> CGFloat {
 if (option == .spacing) {
 //return value * 1.1
 }
 return value
 }
 }*/

// MARK: - Card Collection Delegate & DataSource
extension FeedTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrayOfImageURL.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CarouselCollectionViewCell.identifier, for: indexPath) as! CarouselCollectionViewCell
        
//        cell.image.sd_setImage(with: URL.init(string: arrayOfImageURL[indexPath.row].image), placeholderImage: nil, options: .highPriority) { img, error, caceh, url in
//
//            cell.image.image = img?.drawOutlie()
//        }
        cell.image.setImage(url: arrayOfImageURL[indexPath.row].image, placeholder: nil)
        cell.image.cornerRadius = 15
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize{
            // In this function is the code you must implement to your code project if you want to change size of Collection view
           let height  = Int(arrayOfImageURL[indexPath.row].height)
            let width  = (collectionView.frame.width-20)/3
            return CGSize(width: width, height: 200)
    }
    
    
    // MARK: - UIScrollViewDelegate
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let layout = self.collectionView.collectionViewLayout as! UPCarouselFlowLayout
        let pageSide = (layout.scrollDirection == .horizontal) ? self.pageSize.width : self.pageSize.height
        let offset = (layout.scrollDirection == .horizontal) ? scrollView.contentOffset.x : scrollView.contentOffset.y
        currentPage = Int(floor((offset - pageSide / 2) / pageSide) + 1)
    }
}
