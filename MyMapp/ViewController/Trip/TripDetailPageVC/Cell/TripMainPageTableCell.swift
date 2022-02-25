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
    var pages = 0
    
    func configureArray(){
        
        arrayOfImageURL.removeAll()
        photoUploadedArray.forEach { obj in
            obj.arrayOfImageURL.forEach { obj1 in
                arrayOfImageURL.append(obj1)
            }
        }
        
        
//        tmpRearrageArrray()
        prepareDummyCellData()
        
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
    
//    var collectionViewHeight:CGFloat{
//        return heightOfCollectionViewTrip.constant - 1
//    }
    var collectionViewHeight:CGFloat = 0
    var isMinimizeCollectionView = false

    override func awakeFromNib() {
        super.awakeFromNib()
        
        //672 collectionView zepline
        //1827 whole screen zepline
        // big cell 231
        // small cell 140
        //1827 * 0.37
        
        heightOfCollectionViewTrip.constant  = UIScreen.main.bounds.size.height*0.75
        collectionViewHeight = heightOfCollectionViewTrip.constant - 5
        
        // Initialization code
        self.backgroundColor = .white//.green
        configureCollectionView()
        
    }
    
    func tmpRearrageArrray() {
        var index = 0
        
        moveNext(isVerticle: true)
        moveNext(isVerticle: true)
        moveNext(isVerticle: true)
//        moveVerticleNext()
//        moveVerticleNext()

        func moveNext(isVerticle: Bool) {
            guard index < arrayOfImageURL.count else { return }
            if let i = arrayOfImageURL.lastIndex(where: {
                if isVerticle {
                    return $0.isVerticle
                } else {
                    return !$0.isVerticle
                }
            } ) {
                let obj = arrayOfImageURL.remove(at: i)
                arrayOfImageURL.insert(obj, at: index)
            }
            index += 1
        }
    }
    

    func prepareDummyCellData(){
        //        var collectionViewHieght:CGFloat = 500
//        var longCellHeight = ((collectionViewHeight - 15 - 15)/5)*2 //231
//        var smallCellHeight = (collectionViewHeight - 15 - 15)/5
        
        let space: CGFloat = 5
        var smallCellHeight: CGFloat = 0
        var longCellHeight: CGFloat = 0

        func calculateSmallLongCell() {
            smallCellHeight = (collectionViewHeight - space - space) * 0.23
            longCellHeight = (collectionViewHeight - space - space - smallCellHeight) / 2 //231
        }
        
        calculateSmallLongCell()
        
        func minimizeCollectionViewHightIfNeeded() {
            
            // 4 small cell max possibility
            if arrayOfImageURL.count <= 4 {
                var totalHeight: CGFloat = 0
                arrayOfImageURL.forEach { obj in
                    totalHeight += obj.isVerticle ? longCellHeight : smallCellHeight
                }
                totalHeight += CGFloat(arrayOfImageURL.count - 1) * space
                if totalHeight < collectionViewHeight {
                    heightOfCollectionViewTrip.constant = totalHeight
                    isMinimizeCollectionView = true
                }
            }
        }

        minimizeCollectionViewHightIfNeeded()
        

        
//        /*
//        let collectionViewHeight:CGFloat = 500
//        let longCellHeight = ((collectionViewHeight - 10 - 10)/5)*2 //231
//        let smallCellHeight = (collectionViewHeight - 10 - 10)/5
        
        let localArray = arrayOfImageURL
        var dummyItemCount = 0
        var columHeight:CGFloat = 0
        let verticalSpace:CGFloat = 5
        
        var noOfColumn = 0
        print("localArray.count: \(localArray.count)")
        var i = 0
        while true {

            var itemHeight = arrayOfImageURL[i].isVerticle ? longCellHeight : smallCellHeight
            print("columHeight Begin: \(columHeight)")
            if !columHeight.isZero {
                columHeight += verticalSpace
            }
            columHeight += itemHeight
            
            func addDummyItem() {
                columHeight -= itemHeight
                itemHeight = collectionViewHeight - columHeight
                columHeight += itemHeight
                arrayOfImageURL.insert(
                    TripDataModel.TripPhotoDetails.TripImage(isDummyItem: true, itemHeight: itemHeight, image: "", height: itemHeight, width: 0),
//                    TripDataModel.TripPhotoDetails.TripImage(isVerticle: false, image: "", isDummyItem: true, itemHeight: itemHeight),
                    at: i)
                dummyItemCount += 1
                //                columHeight = 0
            }
            
            if columHeight > collectionViewHeight{
                addDummyItem()
            } else {
                arrayOfImageURL[i].itemHeight = itemHeight
            }
            print("columHeight End: \(columHeight)")
            if columHeight == collectionViewHeight {
                columHeight = 0
                noOfColumn += 1
            }

            i += 1
            if i == (localArray.count + dummyItemCount) {
                func addLastDummyCellIfNeeded() {
                    // last item closed
                    // now check if in last vertical line is there any space ?
                    guard columHeight != 0 else { return }
                    let itemHeight = collectionViewHeight - columHeight - verticalSpace
                    arrayOfImageURL.append(
                        TripDataModel.TripPhotoDetails.TripImage(isDummyItem: true, itemHeight: itemHeight, image: "", height: itemHeight, width: 0))
                    dummyItemCount += 1
                    noOfColumn += 1
                }

                func addDummyCellForHorizontalPagination() {
                    // last item closed
                    // now check if in last vertical line is there any space ?
                    guard columHeight != 0 else { return }
                    let itemHeight = isMinimizeCollectionView ? heightOfCollectionViewTrip.constant : collectionViewHeight
                    arrayOfImageURL.append(
                        TripDataModel.TripPhotoDetails.TripImage(isDummyItem: true, itemHeight: itemHeight, image: "", height: itemHeight, width: 0))
                    dummyItemCount += 1
                }

                if isMinimizeCollectionView {
                    noOfColumn += 1
                } else {
                    addLastDummyCellIfNeeded()
                }
                
                print("noOfColumn: \(noOfColumn)")
                if noOfColumn % 2 == 1 {
                    addDummyCellForHorizontalPagination()
                    noOfColumn += 1
                }
                
                pages = noOfColumn / 2
                
                break
            }
        }
        
    }
            
    func configureCollectionView(){
        //        layoutConfigure()
        
        self.collectionViewTrip.register(UINib(nibName: "AddTripFavouriteImageHeader", bundle: nil), forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "AddTripFavouriteImageHeader")
        self.collectionViewTrip.register(UINib(nibName: "AddTripFavouriteImageHeader", bundle: nil), forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: "AddTripFavouriteImageHeader")
        
        
        //        pageCtrl.numberOfPages = photoUploadedArray.count
        collectionViewTrip.registerCellNib(identifier: "TripMainPageCollectionCell", commonSetting: true)
        collectionViewTrip.backgroundColor = .white//UIColor.red
        collectionViewTrip.delegate = self
        collectionViewTrip.dataSource = self
//        collectionViewTrip.contentInset = UIEdgeInsets.init(top: 0, left: 20, bottom: 0, right: 20)
        
        collectionViewTrip.isPagingEnabled = true
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
            let pageNumber = scrollView.contentOffset.x / collectionviewWidth
            pageCtrl.currentPage = (startX < scrollView.contentOffset.x) ? Int(floor(pageNumber)) : Int(ceil(pageNumber))
        }
    }

    func setTotalPageNo() {
        var totalPage = Int(ceil(collectionViewTrip.contentSize.width / collectionviewWidth))
        if totalPage == 0 {
            totalPage = 1
        }
        pageCtrl.numberOfPages = pages == 0 ? totalPage : pages
    }

}

//MARK: - COLLECTIONVIEW METHODS
extension TripMainPageTableCell: UICollectionViewDataSource,UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        switch kind {
        case UICollectionView.elementKindSectionHeader:
            let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "AddTripFavouriteImageHeader", for: indexPath) as! AddTripFavouriteImageHeader

            headerView.backgroundColor = UIColor.blue
            return headerView

        case UICollectionView.elementKindSectionFooter:
            let footerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "AddTripFavouriteImageHeader", for: indexPath) as! AddTripFavouriteImageHeader
            footerView.backgroundColor = UIColor.green
            return footerView

        default:
            let footerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "AddTripFavouriteImageHeader", for: indexPath) as! AddTripFavouriteImageHeader
            footerView.backgroundColor = UIColor.green
            return footerView
        }
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1//photoUploadedArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrayOfImageURL.count//photoUploadedArray[section].arrayOfImageURL.count
    }
        
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell{
        let cell = self.collectionViewTrip.dequeueReusableCell(withReuseIdentifier: "TripMainPageCollectionCell", for: indexPath) as! TripMainPageCollectionCell
        cell.lblName.text = "INDEX : \(indexPath.row)"
        
        if arrayOfImageURL[indexPath.row].isDummyItem{
//            cell.contentView.backgroundColor = .red
//            cell.contentView.alpha = 0
        }else{
//            cell.contentView.backgroundColor = .green
//            cell.contentView.alpha = 1
        }
        
        if !arrayOfImageURL[indexPath.row].isDummyItem{
            
            let img = arrayOfImageURL[indexPath.row].image//photoUploadedArray[indexPath.section].arrayOfImageURL[indexPath.row].image
            cell.configureSkelton()
            cell.startAnimating()
            cell.imgviewZoom.sd_setImage(with: URL.init(string: img), placeholderImage: nil, options: .highPriority) { img, error, cache, url in
                cell.imgviewZoom.image = img
                //            self.stopAnimating()
                if let sizeOfImage = cell.imgviewZoom.image?.size, sizeOfImage.width > sizeOfImage.height {
                    //since the width > height we may fit it and we'll have bands on top/bottom
                    cell.imgviewZoom.contentMode = .scaleAspectFill
                    //                self.photoUploadedArray[indexPath.section].arrayOfImageURL[indexPath.row].isVerticle = true
                    //                self.arrayOfImageURL[indexPath.row].isVerticle = true
                } else {
                    //width < height we fill it until width is taken up and clipped on top/bottom
                    cell.imgviewZoom.contentMode = .scaleToFill
                    //                self.arrayOfImageURL[indexPath.row].isVerticle = false
                    //                self.photoUploadedArray[indexPath.section].arrayOfImageURL[indexPath.row].isVerticle = false
                }
                
                if self.arrayOfImageURL[indexPath.row].isVerticle{
                    cell.imgviewZoom.contentMode = .scaleAspectFill
                }else{
                    cell.imgviewZoom.contentMode = .scaleToFill
                }
                
                if let lodedImage = img{
                    cell.stopAnimating()
                    cell.imgviewZoom.cornerRadius = 15
                    cell.imgviewZoom.image = lodedImage //.withRoundedCorners(radius: 15)
                    //                cell.imgviewZoom.image = cell.imgviewZoom.image?.drawOutlie()
                }
                
                //            cell.imgviewZoom.clipsToBounds = true
                collectionView.collectionViewLayout.invalidateLayout()
            }
        }else{
            cell.imgviewZoom.image = nil
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
}

// UICollectionViewDelegateFlowLayout
extension TripMainPageTableCell: UICollectionViewDelegateFlowLayout,UIScrollViewDelegate {
    
    var collectionviewWidth: CGFloat {
        return cueSize.screen.width - 20 - 40
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
//        let widthPerItem = collectionView.frame.width / 2 - 20
        let widthPerItem = (collectionviewWidth - 5) / 2

        return CGSize(width: widthPerItem, height:  arrayOfImageURL[indexPath.row].itemHeight)
    }
    
    
    // here return total colum need to show
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, columnCountFor section: Int) -> Int {
        if isTripListFetched{
            return photoUploadedArray[section].arrayOfImageURL.count == 0 ? 1 : 2 //2
        }
        return 1//self.viewModel.arrayOfTripList.count == 0 ? 1 : 2
    }
}
