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
//    var viewModel = SavedAlbumListViewModel()
    var arrayJsonCityArray = [CityModel]()
    var isTripListFetched: Bool = false

    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureCollectionView()
//        getTripListApi()
        getCountryListSavedApi()
        NotificationCenter.default.addObserver(self, selector: #selector(self.reCallTripListApi), name: Notification.Name("reloadSavedTripList"), object: nil)
    }
    
    @objc func reCallTripListApi() {
        stopLoaders()
        self.getCountryListSavedApi()
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
        
        collectionviewProfile.delegate = self
        collectionviewProfile.dataSource = self
        
        let layout = CHTCollectionViewWaterfallLayout()
        layout.minimumColumnSpacing = 4.0
        layout.minimumInteritemSpacing = 4.0
        layout.headerHeight = 0//CGSize(width: collectionviewProfile.frame.size.width, height: 420)
        
        self.collectionviewProfile.collectionViewLayout = layout
        collectionviewProfile.contentInset = UIEdgeInsets.init(top: 0, left: 0, bottom: 40, right: 0)

        collectionviewProfile.sayNoSection = .none//noSavedTripListFound("No Saved albums found")
        
        collectionviewProfile.addPagination { [weak self] in
            self?.isTripListFetched = false
            self?.stopLoaders()
            self?.getCountryListSavedApi(isPullToRefresh: true) // refresh
        }
    }
}

//MARK: - COLLECTIONVIEW METHODS
extension SavedAlbumListViewController: UICollectionViewDataSource,UICollectionViewDelegate{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard self.isTripListFetched else { return 20 }
        if self.arrayJsonCityArray.count == 0{
            return 1
        }
        return self.arrayJsonCityArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell{
        // show skelton while fetch firsyt time data or refresh data
        guard self.isTripListFetched else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SkeletonTripCVCell", for: indexPath) as! SkeletonTripCVCell
            cell.startAnimating(index: indexPath.row)
            return cell
        }
        
        if self.arrayJsonCityArray.count == 0{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PlaceHolderTripCell", for: indexPath) as! PlaceHolderTripCell
            return cell
        }
        
        // here trip image object load here
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AlbumCellDisplayXIB", for: indexPath) as! AlbumCellDisplayXIB
        let objModel = self.arrayJsonCityArray[indexPath.row]
        cell.imageTrip.tag = indexPath.row
        cell.buttonSaved.tag = indexPath.row
        cell.buttonSaved.addTarget(self, action: #selector(unSavedButtonClicked(sender:)), for: .touchUpInside)
        
        cell.configureCell(dataModel: objModel) { isVertical, index in
            cell.imageTrip.contentMode = .scaleToFill
            
            if self.arrayJsonCityArray.indices.contains(index){
                self.arrayJsonCityArray[index].isVerticle = isVertical
            }
            UIView.animate(withDuration: 0.2) {
                self.collectionviewProfile.collectionViewLayout.invalidateLayout()
            }
        }
        cell.layoutIfNeeded()
        return cell
    }
    
    @objc  func unSavedButtonClicked(sender:UIButton){
        unSaveFeedApi(indexRow: sender.tag)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
                
        if let savedAlbumDetailVC = UIStoryboard.tabbar.savedAlbumDetailVC, self.arrayJsonCityArray.indices.contains(indexPath.row){
            savedAlbumDetailVC.cityId = self.arrayJsonCityArray[indexPath.row].id
            savedAlbumDetailVC.cityName = self.arrayJsonCityArray[indexPath.row].name
            savedAlbumDetailVC.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(savedAlbumDetailVC, animated: true)
        }
    }
}

// CHTCollectionViewDelegateWaterfallLayout
extension SavedAlbumListViewController: CHTCollectionViewDelegateWaterfallLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if self.isTripListFetched, self.arrayJsonCityArray.indices.contains(indexPath.item){
            if self.arrayJsonCityArray[indexPath.row].isVerticle{
                return CGSize(width: 155, height: 231)
            }else{
                return CGSize(width: 155, height: 140)
            }
        }else if self.arrayJsonCityArray.count == 0 && !self.isTripListFetched{
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
        if !self.isTripListFetched{
            return 2//self.viewModel.arrayOfTripList.count == 0 ? 1 : 2 //2
        }
        return self.arrayJsonCityArray.count == 0 ? 1 : 2
    }
}

// CLLocationManagerDelegate
extension SavedAlbumListViewController{
    func getCountryListSavedApi(isNextPageRequest: Bool = false, isPullToRefresh:Bool = false){
        guard !self.collectionviewProfile.isAPIstillWorking else { return } // Shouldn't me making another call if already running.
        
        if !isNextPageRequest && !isPullToRefresh{
            // API_LOADER.show(animated: true)
            self.isTripListFetched = false // show skeleton
            self.collectionviewProfile.reloadData() // show skeleton
            self.collectionviewProfile.figureOutAndShowNoResults() // don't show no schedule or scene when skeleton is being shown.
        }
        
        self.collectionviewProfile.isAPIstillWorking = true
        API_SERVICES.callAPI([:],path: .getSavedCountriesList, method: .post) { [weak self] response in
            guard let cityList = response?["responseJson"]?["cityList"].arrayValue else {
                return
            }
            self?.isTripListFetched = true
            self?.arrayJsonCityArray.removeAll()
            cityList.forEach { objCity in
                self?.arrayJsonCityArray.append(CityModel.init(withSavedAlbum: objCity))
            }
            self?.collectionviewProfile.reloadData()
            debugPrint(cityList)
        } failureInform: {
        }
    }
    
    func updateCellWithStatus(index:Int){
        arrayJsonCityArray.remove(at: index)
        collectionviewProfile.reloadData()
        collectionviewProfile.figureOutAndShowNoResults()
    }

    func unSaveFeedApi(indexRow:Int){
        let id = arrayJsonCityArray[indexRow].id
        let strJson = JSON(["id":id,"INTEREST_CATEGORY":"location"]).rawString(.utf8, options: .sortedKeys) ?? ""
        let param: [String: Any] = ["requestJson" : strJson]
        API_SERVICES.callAPI(param, path: .unSaveTrip, method: .post) { [weak self] dataResponce in
            self?.HIDE_CUSTOM_LOADER()
            guard let status = dataResponce?["status"]?.intValue, status == 200 else {
                return
            }
            NotificationCenter.default.post(name: NSNotification.Name.init(rawValue: "reloadForSaveUnSaveTrip"), object: id)
            self?.updateCellWithStatus(index: indexRow)
        }  internetFailure: {
            API_LOADER.HIDE_CUSTOM_LOADER()
            debugPrint("internetFailure")
        } failureInform: {
            self.HIDE_CUSTOM_LOADER()
        }
    }
    
    func stopLoaders() {
        self.isTripListFetched = true
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
//            if viewModel.getTotalElements > viewModel.getAvailableElements &&
//                !self.collectionviewProfile.isAPIstillWorking {
//                self.getTripListApi(isNextPageRequest: true, isPullToRefresh: false)
//            }
        }
    }
}
