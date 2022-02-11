//
//  TripMainPageTableCell.swift
//  MyMapp
//
//  Created by Akash on 04/02/22.
//

import UIKit
import WaterfallLayout
import ELWaterFallLayout
import Combine

class TripMainPageTableCell: UITableViewCell {
    
    @IBOutlet weak var pageCtrl: UIPageControl!
    @IBOutlet weak var collectionViewTrip: UICollectionView!
    @IBOutlet weak var heightOfCollectionViewTrip: NSLayoutConstraint!
    
    var callbackAfterReload: ((CGFloat) -> Void)?
    var callbackImageZoom: ((TripMainPageCollectionCell,UIGestureRecognizer.State) -> Void)?
    var didTap: ((IndexPath) -> Void)?
    var collectionViewObserver: NSKeyValueObservation?
    
    var photoUploadedArray = [TripDataModel.TripPhotoDetails]()
    var heioght:CGFloat {
        return self.collectionViewTrip.contentSize.height
    }
    var isTripListFetched:Bool = false
    var arrayOfImageURL = [TripDataModel.TripPhotoDetails.TripImage]()
    
    
    func configureArray(){
        
        photoUploadedArray.forEach { obj in
            obj.arrayOfImageURL.forEach { obj1 in
                arrayOfImageURL.append(obj1)
            }
        }
        
        /*
        arrayOfImageURL.removeAll()
         arrayOfImageURL.append(TripDataModel.TripPhotoDetails.TripImage.init(isVerticle: false, image: ""))
         arrayOfImageURL.append(TripDataModel.TripPhotoDetails.TripImage.init(isVerticle: true, image: ""))
         arrayOfImageURL.append(TripDataModel.TripPhotoDetails.TripImage.init(isVerticle: true, image: ""))
         arrayOfImageURL.append(TripDataModel.TripPhotoDetails.TripImage.init(isVerticle: true, image: ""))
         //        arrayOfImageURL.append(TripDataModel.TripPhotoDetails.TripImage.init(isVerticle: false, image: ""))
         //        arrayOfImageURL.append(TripDataModel.TripPhotoDetails.TripImage.init(isVerticle: true, image: ""))
         //        arrayOfImageURL.append(TripDataModel.TripPhotoDetails.TripImage.init(isVerticle: false, image: ""))
         arrayOfImageURL.append(TripDataModel.TripPhotoDetails.TripImage.init(isVerticle: true, image: ""))
         arrayOfImageURL.append(TripDataModel.TripPhotoDetails.TripImage.init(isVerticle: true, image: ""))
         arrayOfImageURL.append(TripDataModel.TripPhotoDetails.TripImage.init(isVerticle: true, image: ""))
         
         
         arrayOfImageURL.append(TripDataModel.TripPhotoDetails.TripImage.init(isVerticle: true, image: ""))
         arrayOfImageURL.append(TripDataModel.TripPhotoDetails.TripImage.init(isVerticle: true, image: ""))
         */
    }
    
    var collectionViewHeight:CGFloat{
        return heightOfCollectionViewTrip.constant
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        //672 collectionView zepline
        //1827 whole screen zepline
        // big cell 231
        // small cell 140
        //1827 * 0.37
        
        heightOfCollectionViewTrip.constant  = UIScreen.main.bounds.size.height*0.75
        
        /*
         var collectionViewHeight:CGFloat = 500
         var longCellHeight = ((collectionViewHeight - 10 - 10)/5)*2 //231
         var smallCellHeight = (collectionViewHeight - 10 - 10)/5
         
         let localArray = arrayOfImageURL
         var dummyItemCount = 0
         var columHeight:CGFloat = 0
         
         
         for (i, obj) in localArray.enumerated(){
         var indexMain: Int { i + dummyItemCount }
         var itemHeight = arrayOfImageURL[indexMain].isVerticle ? longCellHeight : smallCellHeight
         print("columHeight Begin: \(columHeight)")
         if !columHeight.isZero {
         columHeight += 10
         }
         columHeight += itemHeight
         
         if columHeight > collectionViewHeight{
         columHeight -= itemHeight
         itemHeight = collectionViewHeight - columHeight
         columHeight += itemHeight
         arrayOfImageURL.insert(
         TripDataModel.TripPhotoDetails.TripImage(isVerticle: false, image: "", isDummyItem: true, itemHeight: itemHeight),
         at: indexMain)
         dummyItemCount += 1
         //                columHeight = 0
         }
         arrayOfImageURL[indexMain].itemHeight = itemHeight
         print("columHeight End: \(columHeight)")
         if columHeight == collectionViewHeight {
         columHeight = 0
         }
         }*/
        
        // Initialization code
        self.backgroundColor = .white//.green
        configureCollectionView()
        
    }
    
    /*
     override func layoutSubviews() {
     super.layoutSubviews()
     //          layoutIfNeeded()
     }
     
     func addObserver() {
     
     collectionViewObserver = collectionViewTrip.observe(\.contentSize, changeHandler: { [weak self] (collectionViewTrip, change) in
     self?.collectionViewTrip.invalidateIntrinsicContentSize()
     self?.heightOfCollectionViewTrip.constant = collectionViewTrip.contentSize.height
     self?.setNeedsLayout()
     self?.layoutIfNeeded()
     debugPrint(collectionViewTrip.contentSize.height)
     })
     }
     
     deinit {
     collectionViewObserver = nil
     }
     
     
     //    override func systemLayoutSizeFitting(_ targetSize: CGSize, withHorizontalFittingPriority horizontalFittingPriority: UILayoutPriority, verticalFittingPriority: UILayoutPriority) -> CGSize {
     //        return collectionViewTrip.frame.size
     //    }
     
     func layoutConfigure1(){
     let layout = WaterfallLayout()
     //        layout.delegate = self
     layout.sectionInset = UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
     layout.minimumLineSpacing = 8.0
     layout.minimumInteritemSpacing = 8.0
     layout.headerHeight = 50.0
     collectionViewTrip.registerCellNib(identifier: "TripMainPageCollectionCell", commonSetting: true)
     collectionViewTrip.backgroundColor = .white//UIColor.red
     collectionViewTrip.collectionViewLayout = layout
     collectionViewTrip.delegate = self
     collectionViewTrip.dataSource = self
     }
     
     func layoutConfigure(){
     var flowLayout  = ELWaterFlowLayout()
     flowLayout.scrollDirection = .horizontal //.vertical
     collectionViewTrip.backgroundColor = .white//UIColor.red
     collectionViewTrip.collectionViewLayout = flowLayout
     //        collectionViewTrip.delegate = self
     //        collectionViewTrip.dataSource = self
     //
     collectionViewTrip.registerCellNib(identifier: "TripMainPageCollectionCell", commonSetting: true)
     flowLayout.totalNumber = 1
     //        flowLayout.delegate = self
     flowLayout.lineCount = 2//十列
     flowLayout.vItemSpace = 5//垂直间距10
     flowLayout.hItemSpace = 5//水平间距10
     flowLayout.edge = UIEdgeInsets.zero
     flowLayout.collectionView?.isPagingEnabled = true
     
     //        let layout = CHTCollectionViewWaterfallLayout()
     //        layout.minimumColumnSpacing = 4.0
     //        layout.minimumInteritemSpacing = 4.0
     ////        layout.headerHeight = 0
     //        collectionViewTrip.collectionViewLayout = layout
     }
     //    var arrayOfImageURL:[TripDataModel.TripPhotoDetails.TripImage]{
     //        var array = [TripDataModel.TripPhotoDetails.TripImage]()
     //        photoUploadedArray.forEach { obj in
     //            obj.arrayOfImageURL.forEach { obj1 in
     //                array.append(obj1)
     //            }
     //        }
     //        return array
     //    }*/
    
    func configureCollectionView(){
        //        layoutConfigure()
        
        self.collectionViewTrip.register(UINib(nibName: "AddTripFavouriteImageHeader", bundle: nil), forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "AddTripFavouriteImageHeader")
        self.collectionViewTrip.register(UINib(nibName: "AddTripFavouriteImageHeader", bundle: nil), forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: "AddTripFavouriteImageHeader")
        
        
//        pageCtrl.numberOfPages = photoUploadedArray.count
        collectionViewTrip.registerCellNib(identifier: "TripMainPageCollectionCell", commonSetting: true)
        collectionViewTrip.backgroundColor = .white//UIColor.red
        collectionViewTrip.delegate = self
        collectionViewTrip.dataSource = self
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        
        //        layout.minimumLineSpacing = 10
        //        layout.minimumInteritemSpacing = 10
        //        layout.sectionInset = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
        //        let size = CGSize(width:(collectionViewTrip!.bounds.width-30)/2, height: 250)
        //        layout.itemSize = size
        //        collectionViewTrip.collectionViewLayout = layout
        //        addObserver()
        //        layout.delegate = self
        
        //        layout.headerHeight = 0
        //        collectionViewTrip.reloadData()
        //        self.collectionViewTrip.layoutIfNeeded()
        //        collectionViewTrip.collectionViewLayout.invalidateLayout()
        //      self.heightOfCollectionViewTrip.constant = self.collectionViewTrip.contentSize.height
        //        collectionViewTrip.reloadData {
        //            self.callbackAfterReload?(self.heioght)
        //        }
        //        let contentSize = self.collectionViewTrip.collectionViewLayout.collectionViewContentSize
        
        //        collectionViewTrip.collectionViewLayout.invalidateLayout()
        //        collectionViewTrip.collectionViewLayout.prepare()
        //        collectionViewTrip.layoutIfNeeded()
        //        self.heightOfCollectionViewTrip.constant = self.collectionViewTrip.contentSize.height
        
        collectionViewTrip.isPagingEnabled = true
        /*
         collectionViewTrip.reloadData {
         self.layoutIfNeeded()
         self.heightOfCollectionViewTrip.constant = self.collectionViewTrip.contentSize.height
         self.layoutIfNeeded()
         self.callbackAfterReload?(self.heightOfCollectionViewTrip.constant)
         //            self.collectionPhotos?.collectionViewLayout.invalidateLayout()
         }*/
        setTotalPageNo()
    }

    var startX = CGFloat(0)

}

// MARK: - ScrollView Delegates
extension TripMainPageTableCell {
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        if scrollView == collectionViewTrip{
            startX = scrollView.contentOffset.x
        }
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        setTotalPageNo()
        if scrollView == collectionViewTrip{
            let pageNumber = scrollView.contentOffset.x / (cueSize.screen.width - 20)
            pageCtrl.currentPage = (startX < scrollView.contentOffset.x) ? Int(floor(pageNumber)) : Int(ceil(pageNumber))
        }
    }

    func setTotalPageNo() {
        var totalPage = Int(ceil(collectionViewTrip.contentSize.width / (cueSize.screen.width - 20)))
        if totalPage == 0 {
            totalPage = 1
        }
        pageCtrl.numberOfPages = totalPage
    }

}

//MARK: - COLLECTIONVIEW METHODS
extension TripMainPageTableCell: UICollectionViewDataSource,UICollectionViewDelegate {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1//photoUploadedArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrayOfImageURL.count//photoUploadedArray[section].arrayOfImageURL.count
    }
    
//    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath){
//        pageCtrl.currentPage = indexPath.section
//    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell{
        let cell = self.collectionViewTrip.dequeueReusableCell(withReuseIdentifier: "TripMainPageCollectionCell", for: indexPath) as! TripMainPageCollectionCell
        cell.lblName.text = "INDEX : \(indexPath.row)"
        
        if arrayOfImageURL[indexPath.row].isDummyItem{
            cell.contentView.backgroundColor = .red
            cell.contentView.alpha = 0
        }else{
//            cell.contentView.backgroundColor = .green
            cell.contentView.alpha = 1
        }
        
        
         let img = arrayOfImageURL[indexPath.row].image//photoUploadedArray[indexPath.section].arrayOfImageURL[indexPath.row].image
        cell.imgviewZoom.sd_setImage(with: URL.init(string: img), placeholderImage: nil, options: .highPriority) { img, error, cache, url in
            cell.imgviewZoom.image = img
            //            self.stopAnimating()
            if let sizeOfImage = cell.imgviewZoom.image?.size, sizeOfImage.width > sizeOfImage.height {
                //since the width > height we may fit it and we'll have bands on top/bottom
                cell.imgviewZoom.contentMode = .scaleAspectFill
                //                self.photoUploadedArray[indexPath.section].arrayOfImageURL[indexPath.row].isVerticle = true
                self.arrayOfImageURL[indexPath.row].isVerticle = true
            } else {
                //width < height we fill it until width is taken up and clipped on top/bottom
                cell.imgviewZoom.contentMode = .scaleToFill
                self.arrayOfImageURL[indexPath.row].isVerticle = false
                //                self.photoUploadedArray[indexPath.section].arrayOfImageURL[indexPath.row].isVerticle = false
            }
            collectionView.collectionViewLayout.invalidateLayout()
        }
        
        //        if !arrayOfImageURL[indexPath.row].isDummyItem{
        let longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(self.longPressGestureHandler))
        longPressGesture.accessibilityLabel = "\(indexPath.row)"
        longPressGesture.accessibilityHint = "\(indexPath.section)"
        cell.backgroundColor = .clear
        cell.viewBG.backgroundColor = .clear
        cell.isUserInteractionEnabled = true
        cell.addGestureRecognizer(longPressGesture)
        //        }
        cell.layoutIfNeeded()
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if !arrayOfImageURL[indexPath.row].isDummyItem{
            debugPrint("didTap\(indexPath.row)")
            didTap?(indexPath)
        }
    }
    
    @objc func longPressGestureHandler(recognizer: UILongPressGestureRecognizer) {
        let section = Int(recognizer.accessibilityHint ?? "0") ?? 0
        let row = Int(recognizer.accessibilityLabel ?? "0") ?? 0
        
        if !arrayOfImageURL[row].isDummyItem{
            if let cell: TripMainPageCollectionCell = self.collectionViewTrip.cellForItem(at: IndexPath(item: row, section: section)) as? TripMainPageCollectionCell {
                callbackImageZoom?(cell, recognizer.state)
            }
        }
    }
    
    
    // func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize{
    //
    //        //            return CGSize(width: collectionView.frame.size.width/2 - 16 , height: collectionView.frame.size.width/2 )
    //
    //        if self.photoUploadedArray[indexPath.section].arrayOfImageURL[indexPath.row].isVerticle {
    //            return CGSize(width: 155, height: 231)
    //        }else{
    //            return CGSize(width: 155, height: 140)
    //        }
    //
    //        //            let randomInt = Int.random(in: 1...100)
    //        //            if indexPath.row % 2 == 0{
    //        //                return CGSize(width: 155, height: 140)
    //        //            }else{
    //        //                return CGSize(width: 155, height: 231)
    //        //            }
    //    }
}

// UICollectionViewDelegateFlowLayout
extension TripMainPageTableCell: UICollectionViewDelegateFlowLayout,UIScrollViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        //                let randomInt = Int.random(in: 1...100)
        //        if randomInt%2 == 0{
        //            arrayHeight.append(231)
        //            return CGSize(width: widthPerItem, height: 231)
        //        }else{
        //            arrayHeight.append(140)
        //            return CGSize(width: widthPerItem, height:  140)
        //        }
        
        //        if self.photoUploadedArray[indexPath.section].arrayOfImageURL[indexPath.row].isVerticle{
        
        let widthPerItem = collectionView.frame.width / 2 - 20
        //        var collectionViewHieght:CGFloat = 500
//        var longCellHeight = ((collectionViewHeight - 15 - 15)/5)*2 //231
//        var smallCellHeight = (collectionViewHeight - 15 - 15)/5
        
        let space:CGFloat = 5
//       let space:CGFloat = 10
        let smallCellHeight = (collectionViewHeight - space - space)*0.23
        let longCellHeight = (collectionViewHeight - space - space - smallCellHeight)/2 //231

        //        return CGSize(width: widthPerItem, height:  arrayOfImageURL[indexPath.row].itemHeight)
        
        if arrayOfImageURL[indexPath.row].isVerticle{//arrayOfImageURL[indexPath.section+indexPath.row].isVerticle{
            return CGSize(width: widthPerItem, height: longCellHeight)
        }else{
            return CGSize(width: widthPerItem, height:  smallCellHeight)
        }
        
        //        if arrayOfImageURL[indexPath.row].isVerticle{
        //            return CGSize(width: widthPerItem, height: longCellHeight)
        //        }else{
        //            return CGSize(width: widthPerItem, height:  smallCellHeight)
        //        }
    }
    
    // here return total colum need to show
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, columnCountFor section: Int) -> Int {
        if isTripListFetched{
            return photoUploadedArray[section].arrayOfImageURL.count == 0 ? 1 : 2 //2
        }
        return 1//self.viewModel.arrayOfTripList.count == 0 ? 1 : 2
    }
    
//        func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
//            let pageWidth = scrollView.frame.size.width
//            let page = Int(floor((scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1)
//            print("page = \(page)")
//            pageCtrl.currentPage = page+1
//        }
    
    // MARK: UIScrollViewDelegate
//    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool){
//        if decelerate == false {
//            let currentPage = scrollView.currentPage
//            // Do something with your page update
//            print("scrollViewDidEndDragging: \(currentPage)")
//            pageCtrl.currentPage = currentPage
//        }
//    }
//
//    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
//        let currentPage = scrollView.currentPage
//        // Do something with your page update
//        print("scrollViewDidEndDecelerating: \(currentPage)")
//        pageCtrl.currentPage = currentPage
//    }
    
//    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
//        if pageCtrl.currentPage != scrollView.currentPage {
//            pageCtrl.currentPage = scrollView.currentPage
//            // Do something with your page update
//            print("scrollViewDidEndDecelerating: \(pageCtrl.currentPage)")
////            pageCtrl.currentPage = scrollViewPage
//        }
//    }

    
}

extension UIScrollView {
    var currentPage: Int {
        return Int((self.contentOffset.x+(0.5*self.frame.size.width))/self.frame.width)+1
    }
}
