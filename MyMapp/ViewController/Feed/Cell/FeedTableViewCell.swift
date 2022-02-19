//
//  FeedTableViewCell.swift
//  MyMapp
//
//  Created by Akash on 16/02/22.
//

import UIKit
import SDWebImage

class FeedTableViewCell: UITableViewCell {
    
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
         
        return pageSize//CGSize.init(width: arrayOfImageURL.count == 1 ? collectionView.frame.size.width : pageSize.width, height: pageSize.height)
    }
    
    
    func setupLayout() {
        let layout = self.collectionView.collectionViewLayout as! UPCarouselFlowLayout
        layout.spacingMode = UPCarouselFlowLayoutSpacingMode.fixed(spacing: -50)
        layout.sideItemAlpha = 0.6
        layout.sideItemScale = 0.6
        //        layout.sideItemShift = 0.8
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        postedDate.textColor = UIColor.App_BG_silver_Color
        collectionView.contentInset = UIEdgeInsets.init(top: 0, left: 0, bottom: 0, right: 0)
        
        self.collectionView.registerCellNib(identifier: CarouselCollectionViewCell.identifier)
        setupLayout()
        commentedUserPic.setImage(url: APP_USER?.profilePicPath ?? "", placeholder: UIImage.init(named: "ic_user_image_defaulut_one"))
    }
    
    func configureCell(modelData:TripDataModel){
        labelExpDescription.text = "The city is very vibrant at night, especially in summerThe city is very vibrant at night, especially in summerThe city is very vibrant at night, especially in summer"//modelData.tripDescription
        labelExpDescription.isHidden = labelExpDescription.text!.isEmpty

        postedDate.text = modelData.dateFromatedOftrip
        
        labelTotalLikeCount.text = "\(modelData.likedTotalCount)"
        labelTotalLikeCount.isHidden = modelData.likedTotalCount == 0
        
        labelTotaBookmarkCount.text = "\(modelData.bookmarkedTotalCount)"
        labelTotaBookmarkCount.isHidden = modelData.bookmarkedTotalCount == 0

        buttonBookmark.isSelected = modelData.isBookmarked
        buttonLike.isSelected = modelData.isLiked
        
        postedUserPic.setImage(url: modelData.userCreatedTrip?.profilePic ?? "", placeholder: UIImage.init(named: "ic_user_image_defaulut_one"))
        postedUserName.text = modelData.userCreatedTrip?.username ?? "-"
        
        postedUserAddress.text = modelData.userCreatedTrip?.region ?? "-"
        postedUserAddress.isHidden = (modelData.userCreatedTrip?.region ?? "").isEmpty

        arrayOfImageURL.removeAll()
        modelData.photoUploadedArray.forEach { obj in
            obj.arrayOfImageURL.forEach { obj1 in
                arrayOfImageURL.append(obj1)
            }
        }
        
        pageControll.numberOfPages = arrayOfImageURL.count
//        pageControll.isHidden = arrayOfImageURL.count == 1 ? true : false
        self.collectionView.isScrollEnabled = arrayOfImageURL.count == 1 ? false : true
        collectionView.reloadData {
            if self.arrayOfImageURL.count > 2{
                self.collectionView.scrollToItem(at: IndexPath.init(row: 3, section: 0), at: .right, animated: false)
            }
        }
    }
}

// MARK: - Card Collection Delegate & DataSource
extension FeedTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrayOfImageURL.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CarouselCollectionViewCell.identifier, for: indexPath) as! CarouselCollectionViewCell
        
        cell.configureCell(model: arrayOfImageURL[indexPath.row])
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
