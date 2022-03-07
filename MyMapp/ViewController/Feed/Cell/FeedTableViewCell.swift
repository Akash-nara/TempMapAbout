//
//  FeedTableViewCell.swift
//  MyMapp
//
//  Created by Akash on 16/02/22.
//

import UIKit
import SDWebImage
import TagListView

class FeedTableViewCell: UITableViewCell {
    
    @IBOutlet weak var postedUserPic: UIImageView!
    @IBOutlet weak var commentedUserPic: UIImageView!
    @IBOutlet weak var postedUserName: UILabel!
    @IBOutlet weak var postedUserAddress: UILabel!
    @IBOutlet weak var postedDate: UILabel!
    @IBOutlet weak var labelExpDescription: LessMoreCustomizeLabel!
    @IBOutlet weak var labelTotalLikeCount: UILabel!
    @IBOutlet weak var labelTotaBookmarkCount: UILabel!
    @IBOutlet weak var textFieldComment: UITextField!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var pageControll: UIPageControl!
    
    @IBOutlet weak var buttonBookmark: UIButton!
    @IBOutlet weak var buttonLike: UIButton!
    //    @IBOutlet weak var tagListView: TagListView!
    @IBOutlet weak var collectionviewTags: UICollectionView!
    @IBOutlet weak var constraintHeightCollectionView: NSLayoutConstraint!
    @IBOutlet weak var stackViewPostedUser: UIStackView!

    var arrayOfImageURL: [TripDataModel.TripPhotoDetails.TripImage] = []
    var arrayTagName = [String]()
    var didTap: ((TripDataModel.TripPhotoDetails.TripImage) -> Void)?

    
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
        layout.spacingMode = UPCarouselFlowLayoutSpacingMode.fixed(spacing: -(CarouselCollectionViewCell.cellSize * 0.4))
//        layout.spacingMode = UPCarouselFlowLayoutSpacingMode.overlap(visibleOffset: -250)
        layout.sideItemAlpha = 0.6
        layout.sideItemScale = 0.6
//        layout.sideItemShift = 1
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        constraintHeightCollectionView.constant = CarouselCollectionViewCell.cellSize + 25
        
        postedDate.textColor = UIColor.App_BG_silver_Color
        collectionView.contentInset = UIEdgeInsets.init(top: 0, left: 0, bottom: 0, right: 0)
        
        self.collectionView.registerCellNib(identifier: CarouselCollectionViewCell.identifier)
        setupLayout()
        commentedUserPic.setImage(url: APP_USER?.profilePicPath ?? "", placeholder: UIImage.init(named: "ic_user_image_defaulut_one"))
        
        labelExpDescription.textColor = UIColor.App_BG_SecondaryDark2_Color
        labelExpDescription.numberOfLines = 0
        labelExpDescription.seeMoreLessColor = UIColor.grayLightReadLessMore
        labelExpDescription.setTextFont = UIFont.Montserrat.Medium(12.7)
        labelExpDescription.seeMoreLessFont = UIFont.Montserrat.Medium(12.7)
        labelExpDescription.isNeedToUnderlineSeeMoreSeeLess = false
        
        configureCollectionView()
        
        //        tagListView.textFont = UIFont.Montserrat.SemiBold(9)
        //        tagListView.alignment = .center
        //        tagListView.enableRemoveButton = false
        //        tagListView.paddingX = 10
        //        tagListView.paddingY = 10
        
        
        //        addTagsList(arrrayOfArray: ["Architecture","Landscape","Design"])
        
    }
    
    func configureCollectionView(){
        collectionviewTags.register(UINib(nibName: "LocationDescriptionCell", bundle: nil), forCellWithReuseIdentifier: "LocationDescriptionCell")
        collectionviewTags.dataSource = self
        collectionviewTags.delegate = self
    }
    
    //    func addTagsList(arrrayOfArray:[String]){
    //        tagListView.removeAllTags()
    //        arrrayOfArray.forEach { str in
    //            tagListView.addTag(str)
    //        }
    //    }
    
    func configureCell(modelData:TripDataModel){
        
        postedDate.text = modelData.dateFromatedOftrip
        
        labelTotalLikeCount.text = "\(modelData.likedTotalCount)"
        labelTotalLikeCount.isHidden = modelData.likedTotalCount == 0
        
        labelTotaBookmarkCount.text = "\(modelData.bookmarkedTotalCount)"
        labelTotaBookmarkCount.isHidden = modelData.bookmarkedTotalCount == 0
        
        buttonBookmark.isSelected = modelData.isBookmarked
        buttonLike.isSelected = modelData.isLiked
        
        postedUserPic.setImage(url: modelData.userCreatedTrip?.profilePicPath ?? "", placeholder: UIImage.init(named: "ic_user_image_defaulut_one"))
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
            
            if let index = self.arrayOfImageURL.firstIndex(where: {$0.isDefaultImage}){
                self.currentPage = index
                self.collectionView.scrollToItem(at: IndexPath.init(row: index, section: 0), at: .centeredHorizontally, animated: false)
            } else if self.arrayOfImageURL.count > 0 {
                self.collectionView.scrollToItem(at: IndexPath.init(row: 0, section: 0), at: .centeredHorizontally, animated: false)
            }
        }

        DispatchQueue.getMain {
            self.arrayTagName.removeAll()
            
            modelData.locationList.forEach { obj in
                obj.arrayTagsFeed.forEach { strTag in
                    self.arrayTagName.append(strTag)
                }
            }
            
//            modelData.locationList.forEach(
////                self.arrayTagName +=
////                                            self.arrayTagName.append(str.)
//            })
            if self.arrayTagName.count == 0{
                self.collectionviewTags.isHidden = true
            }else{
                self.collectionviewTags.isHidden = false
                self.collectionviewTags.reloadData()
            }
        }
        pageControll.isHidden = arrayOfImageURL.count == 0
        collectionView.isHidden = arrayOfImageURL.count == 0
    }
}

// MARK: - Card Collection Delegate & DataSource
extension FeedTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch collectionView{
        case self.collectionView:
            return arrayOfImageURL.count
        case collectionviewTags:
            return arrayTagName.count
        default:
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch collectionView{
        case self.collectionView:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CarouselCollectionViewCell.identifier, for: indexPath) as! CarouselCollectionViewCell
            cell.configureCell(model: arrayOfImageURL[indexPath.row])
            return cell
            
        case collectionviewTags:
            let cell = collectionviewTags.dequeueReusableCell(withReuseIdentifier: "LocationDescriptionCell", for: indexPath ) as! LocationDescriptionCell
            cell.lblTItle.text = arrayTagName[indexPath.row]
            cell.viewBG.backgroundColor = UIColor.App_BG_App_BG_colorsNeutralLightDark2
            return cell
            
        default:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CarouselCollectionViewCell.identifier, for: indexPath) as! CarouselCollectionViewCell
            
            cell.configureCell(model: arrayOfImageURL[indexPath.row])
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        switch collectionView{
        case self.collectionView:
            return CGSize(width: CarouselCollectionViewCell.cellSize, height: CarouselCollectionViewCell.cellSize)
        case collectionviewTags:
            let label = UILabel(frame: CGRect.zero)
            label.text = arrayTagName[indexPath.row]
            label.sizeToFit()
            return CGSize(width: label.frame.width + 30, height: 40)
        default:
            return CGSize(width: 200, height: 200)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch collectionView{
        case self.collectionView:
            didTap?(arrayOfImageURL[indexPath.row])
        default:break
        }
    }
    
    // MARK: - UIScrollViewDelegate
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        guard scrollView == self.collectionView else { return }
        let layout = self.collectionView.collectionViewLayout as! UPCarouselFlowLayout
        let pageSide = (layout.scrollDirection == .horizontal) ? self.pageSize.width : self.pageSize.height
        let offset = (layout.scrollDirection == .horizontal) ? scrollView.contentOffset.x : scrollView.contentOffset.y
        currentPage = Int(floor((offset - pageSide / 2) / pageSide) + 1)
    }
}
