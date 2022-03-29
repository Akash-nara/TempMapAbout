//
//  SavedAlbumListViewController.swift
//  MyMapp
//
//  Created by Akash Nara on 29/03/22.
//

import UIKit

class SavedAlbumListViewController: UIViewController {
    
    //MARK: - OUTLETS
    @IBOutlet weak var collectionviewProfile: SayNoForDataCollectionView!
    var viewModel = SavedAlbumListViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureCollectionView()
        getTripListApi()
        NotificationCenter.default.addObserver(self, selector: #selector(self.reCallTripListApi), name: Notification.Name("reloadSavedTripList"), object: nil)
    }
    
    @objc func reCallTripListApi() {
        stopLoaders()
        self.getTripListApi(isPullToRefresh: true)
    }
    
    deinit{
        NotificationCenter.default.removeObserver(self)
    }
    
    func configureCollectionView(){
        collectionviewProfile.register(UINib(nibName: "ProfileImagesCellXIB", bundle: nil), forCellWithReuseIdentifier: "ProfileImagesCellXIB")
        collectionviewProfile.register(UINib(nibName: "SkeletonTripCVCell", bundle: nil), forCellWithReuseIdentifier: "SkeletonTripCVCell")
        collectionviewProfile.register(UINib(nibName: "AlbumCellDisplayXIB", bundle: nil), forCellWithReuseIdentifier: "AlbumCellDisplayXIB")
        collectionviewProfile.register(UINib(nibName: "LoadingActivityIndicatorMoreCVCell", bundle: nil), forCellWithReuseIdentifier: "LoadingActivityIndicatorMoreCVCell")
        collectionviewProfile.register(UINib(nibName: "PlaceHolderTripCell", bundle: nil), forCellWithReuseIdentifier: "PlaceHolderTripCell")
        
        collectionviewProfile.dataSource = self
        collectionviewProfile.dataSource = self
        let layout = CHTCollectionViewWaterfallLayout()
        layout.minimumColumnSpacing = 4.0
        layout.minimumInteritemSpacing = 4.0
        layout.headerHeight = 0//CGSize(width: collectionviewProfile.frame.size.width, height: 420)
        
        self.collectionviewProfile.collectionViewLayout = layout
        self.collectionviewProfile.reloadData()
        
        collectionviewProfile.contentInset = UIEdgeInsets.init(top: 0, left: 0, bottom: 40, right: 0)
        
        collectionviewProfile.sayNoSection = .none
        
        collectionviewProfile.addPagination { [weak self] in
            self?.viewModel.isTripListFetched = false
            self?.stopLoaders()
            self?.getTripListApi(isPullToRefresh: true) // refresh
        }
    }
}

//MARK: - COLLECTIONVIEW METHODS
extension SavedAlbumListViewController: UICollectionViewDataSource,UICollectionViewDelegate{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard self.viewModel.isTripListFetched else { return 20 }
        if viewModel.arrayOfTripList.count == 0{
            return 1
        }
        return viewModel.arrayOfTripList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell{
        // show skelton while fetch firsyt time data or refresh data
        guard self.viewModel.isTripListFetched else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SkeletonTripCVCell", for: indexPath) as! SkeletonTripCVCell
            cell.startAnimating(index: indexPath.row)
            return cell
        }
        
        if viewModel.arrayOfTripList.count == 0{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PlaceHolderTripCell", for: indexPath) as! PlaceHolderTripCell
            return cell
        }
        
        /*
         // show loader while fetching new page
         guard self.viewModel.arrayOfTripList.indices.contains(indexPath.row) else {
         let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "LoadingActivityIndicatorMoreCVCell", for: indexPath) as! LoadingActivityIndicatorMoreCVCell
         cell.activityIndicatot.startAnimating()
         cell.backgroundColor = .clear
         return cell
         }*/
        
        // here trip image object load here
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AlbumCellDisplayXIB", for: indexPath) as! AlbumCellDisplayXIB
        let objModel = self.viewModel.arrayOfTripList[indexPath.row]
        cell.imageTrip.tag = indexPath.row
        cell.buttonSaved.tag = indexPath.row
        cell.buttonSaved.addTarget(self, action: #selector(unSavedButtonClicked(sender:)), for: .touchUpInside)
        cell.labelBookmarkCount.text = "\(objModel.bookmarkedTotalCount)"
        cell.labelBookmarkCount.isHidden = objModel.bookmarkedTotalCount.isZero()
        cell.tripTitle.text = objModel.city.cityName
        cell.tripSubTitle.text = objModel.city.countryName
        
        var defaultKey = objModel.defaultImageKey
        if defaultKey.isEmpty, let firstObject = objModel.photoUploadedArray.first?.arrayOfImageURL.first{
            defaultKey = firstObject.image
        }
        
        if !defaultKey.isEmpty{
            
            cell.imageTrip.sd_setImage(with: URL.init(string: defaultKey), placeholderImage: nil, options: .highPriority) { [weak self] img, error, cache, url in
                
                if let image = img{
                    cell.imageTrip.image = image
                    //since the width > height we may fit it and we'll have bands on top/bottom
                    cell.imageTrip.contentMode = .scaleAspectFill
                }else{
                    //width < height we fill it until width is taken up and clipped on top/bottom
                    cell.imageTrip.contentMode = .scaleToFill
                    if let foundImage = objModel.photoUploadedArray.first?.arrayOfImageURL.first?.image, !foundImage.isEmpty{
                        cell.imageTrip.setImage(url: foundImage, placeholder: UIImage.init(named: "not_icon"))
                    }else{
                        cell.imageTrip.image = UIImage.init(named: "not_icon")
                    }
                }
            }
            
            cell.imageTrip.clipsToBounds = true
            
            UIView.animate(withDuration: 0.2) {
                self.collectionviewProfile.collectionViewLayout.invalidateLayout()
            }
        }else{
            //            startAnimating()
            cell.imageTrip.backgroundColor = .clear
            cell.imageTrip.contentMode = .scaleToFill
            cell.imageTrip.image = UIImage.init(named: "not_icon")
            //            self.imgviewBG.image = UIImage.init(named: "ic_Default_city_image_one")
        }
        cell.layoutIfNeeded()
        return cell
    }
    
    @objc  func unSavedButtonClicked(sender:UIButton){
        unSaveFeedApi(indexRow: sender.tag)
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        //        if let tripPageDetailVC = UIStoryboard.trip.tripPageDetailVC, self.viewModel.arrayOfTripList.indices.contains(indexPath.row){
        //            guard let userId = self.viewModel.arrayOfTripList[indexPath.row].userCreatedTrip?.userId, let loginUserId = APP_USER?.userId else {
        //                return
        //            }
        //            tripPageDetailVC.hidesBottomBarWhenPushed = true
        //            tripPageDetailVC.detailTripDataModel = self.viewModel.arrayOfTripList[indexPath.row]
        //            tripPageDetailVC.enumCurrentFlow = userId == loginUserId ? .personal : .otherUser
        //            self.navigationController?.pushViewController(tripPageDetailVC, animated: true)
        //        }
    }
}

// CHTCollectionViewDelegateWaterfallLayout
extension SavedAlbumListViewController: CHTCollectionViewDelegateWaterfallLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if self.viewModel.isTripListFetched, self.viewModel.arrayOfTripList.indices.contains(indexPath.item){
            if self.viewModel.arrayOfTripList[indexPath.row].isVerticalImage{
                return CGSize(width: 155, height: 231)
            }else{
                return CGSize(width: 155, height: 140)
            }
        }else if self.viewModel.arrayOfTripList.count == 0 && !self.viewModel.isTripListFetched{
            if indexPath.item % 2 == 0{
                return CGSize(width: 155, height: 100)
            }else{
                return CGSize(width: 155, height: 80)
            }
            //                    return CGSize(width: collectionView.frame.size.width, height: 80)
        }else{
            if indexPath.item % 2 == 0{
                return CGSize(width: 155, height: 231)
            }else{
                return CGSize(width: 155, height: 140)
            }
        }
    }
    
    // here return total colum need to show
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, columnCountFor section: Int) -> Int {
        if !viewModel.isTripListFetched{
            return 2//self.viewModel.arrayOfTripList.count == 0 ? 1 : 2 //2
        }
        return self.viewModel.arrayOfTripList.count == 0 ? 1 : 2
    }
}

// CLLocationManagerDelegate
extension SavedAlbumListViewController{
    func getTripListApi(isNextPageRequest: Bool = false, isPullToRefresh:Bool = false){
        guard !self.collectionviewProfile.isAPIstillWorking else { return } // Shouldn't me making another call if already running.
        
        if !isNextPageRequest && !isPullToRefresh{
            // API_LOADER.show(animated: true)
            self.viewModel.isTripListFetched = false // show skeleton
            self.collectionviewProfile.reloadData() // show skeleton
            self.collectionviewProfile.figureOutAndShowNoResults() // don't show no schedule or scene when skeleton is being shown.
        }
        
        let param = viewModel.getPageDict(isPullToRefresh)
        self.collectionviewProfile.isAPIstillWorking = true
        
        let paramDict:[String:Any] = ["INTEREST_CATEGORY":"feed", "pager":param]
        viewModel.getSavedTripListApi(paramDict: paramDict, success: { response in
            self.stopLoaders()
            self.collectionviewProfile.reloadData()
            if isPullToRefresh{
                self.collectionviewProfile.setContentOffset(.zero, animated: true)
            }
        })
    }
    
    func unSaveFeedApi(indexRow:Int){
        let id = viewModel.arrayOfTripList[indexRow].id
        let strJson = JSON(["id":id,"INTEREST_CATEGORY":"feed"]).rawString(.utf8, options: .sortedKeys) ?? ""
        let param: [String: Any] = ["requestJson" : strJson]
        API_SERVICES.callAPI(param, path: .unSaveTrip, method: .post) { [weak self] dataResponce in
            self?.HIDE_CUSTOM_LOADER()
            guard let status = dataResponce?["status"]?.intValue, status == 200 else {
                return
            }
            NotificationCenter.default.post(name: NSNotification.Name.init(rawValue: "reloadForSaveUnSaveTrip"), object: id)
            self?.viewModel.updateCount(id: id)
            self?.collectionviewProfile.reloadData()
            self?.collectionviewProfile.figureOutAndShowNoResults()
        }  internetFailure: {
            API_LOADER.HIDE_CUSTOM_LOADER()
            debugPrint("internetFailure")
        } failureInform: {
            self.HIDE_CUSTOM_LOADER()
        }
    }
    
    func stopLoaders() {
        self.viewModel.isTripListFetched = true
        self.collectionviewProfile.isAPIstillWorking = false
        self.collectionviewProfile.stopPullToRefresh()
        self.collectionviewProfile.reloadData()
        self.collectionviewProfile.figureOutAndShowNoResults()
    }
}

// MARK: - UIScrollViewDelegate
extension SavedAlbumListViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        let height = scrollView.frame.size.height
        let contentYoffset = scrollView.contentOffset.y
        let distanceFromBottom = scrollView.contentSize.height - contentYoffset
        if distanceFromBottom < height {
            // pagination
            if viewModel.getTotalElements > viewModel.getAvailableElements &&
                !self.collectionviewProfile.isAPIstillWorking {
                self.getTripListApi(isNextPageRequest: true, isPullToRefresh: false)
            }
        }
    }
}
