//
//  ProfileHomeVC.swift
//  MyMapp
//
//  Created by Chirag Pandya on 07/11/21.
//

import UIKit
import WaterfallLayout
import MapKit
import CoreLocation
import SwiftyJSON



class ProfileHomeVC: UIViewController {
    enum EnumMap {
        case map, tripData
    }
    
    enum EnumProfileTab {
        case albums, map([EnumMap]?), saved
    }
    
    //MARK: - VARIABLES
    lazy var locationManager: CLLocationManager = {
        var manager = CLLocationManager()
        manager.distanceFilter = 10
        manager.desiredAccuracy = kCLLocationAccuracyBest
        return manager
    }()
    
    var collectionviewData:UICollectionView?
    
    //MARK: - OUTLETS
    @IBOutlet weak var collectionviewProfile: SayNoForDataCollectionView!
    
    //MARK: - VARIABLES
    var selectedTab: EnumProfileTab = .albums
    var viewModel = ProfileHomeViewModel()
    var statusOfTrip = "C"
    var searchValue = ""
    var searchTimer: Timer?

    //MARK: - VIEW DID LOAD
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        
        configureCollectionView()
        getTripListApi()
        NotificationCenter.default.addObserver(self, selector: #selector(self.reCallTripListApi), name: Notification.Name("reloadUserTripList"), object: nil)
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
        collectionviewProfile.register(UINib(nibName: "ProfileMapCellXIB", bundle: nil), forCellWithReuseIdentifier: "ProfileMapCellXIB")
        collectionviewProfile.register(UINib(nibName: "AlbumCellDisplayXIB", bundle: nil), forCellWithReuseIdentifier: "AlbumCellDisplayXIB")
        collectionviewProfile.register(UINib(nibName: "LoadingActivityIndicatorMoreCVCell", bundle: nil), forCellWithReuseIdentifier: "LoadingActivityIndicatorMoreCVCell")
        collectionviewProfile.register(UINib(nibName: "PlaceHolderTripCell", bundle: nil), forCellWithReuseIdentifier: "PlaceHolderTripCell")
        
        collectionviewProfile.dataSource = self
        collectionviewProfile.dataSource = self
        let layout = CHTCollectionViewWaterfallLayout()
        layout.minimumColumnSpacing = 4.0
        layout.minimumInteritemSpacing = 4.0
        layout.headerHeight = 390//CGSize(width: collectionviewProfile.frame.size.width, height: 420)
        
        self.collectionviewProfile.collectionViewLayout = layout
        self.collectionviewProfile.reloadData()
        
        self.collectionviewProfile.register(UINib(nibName: "ProfileHeaderCellXIB", bundle: nil), forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "ProfileHeaderCellXIB")
        collectionviewProfile.contentInset = UIEdgeInsets.init(top: 0, left: 0, bottom: 40, right: 0)
        
        collectionviewProfile.sayNoSection = .none
        
        collectionviewProfile.addPagination { [weak self] in
            self?.viewModel.isTripListFetched = false
            self?.stopLoaders()
            self?.getTripListApi(isPullToRefresh: true) // refresh
        }
    }
    
    //MARK: - BUTTON ACTIONS
    @IBAction func btnHandlerSetting(_ sender: Any) {
        UserManager.logoutMethod()
    }
    
    //MARK: - OTHER FUNCTIONS
    @objc func selectFirstTab(sender:UIButton){
        self.selectedTab = .albums
        //        collectionviewProfile.invalidateIntrinsicContentSize()
        //        collectionviewProfile.reloadData()
        collectionviewProfile.reloadData()
        collectionviewProfile.collectionViewLayout.invalidateLayout()
    }
    
    @objc func selectSecondTab(sender:UIButton){
        self.selectedTab = .map([.map, .tripData])
        collectionviewProfile.collectionViewLayout.invalidateLayout()
        collectionviewProfile.reloadData()
    }
    
    @objc func selectThirdTab(sender:UIButton){
        self.selectedTab = .saved
        collectionviewProfile.collectionViewLayout.invalidateLayout()
        collectionviewProfile.reloadData()
    }
}

//MARK: - COLLECTIONVIEW METHODS
extension ProfileHomeVC: UICollectionViewDataSource,UICollectionViewDelegate{
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        //        return 0
        if collectionView == self.collectionviewData{
            return 10
        }else{
            switch selectedTab{
            case .albums:
                guard self.viewModel.isTripListFetched else { return 10 }
                
                /*
                 if (self.viewModel.getTotalElements > self.viewModel.arrayOfTripList.count)
                 && self.viewModel.arrayOfTripList.count != 0 {
                 return viewModel.arrayOfTripList.count + 1
                 }else{
                 return viewModel.arrayOfTripList.count
                 }*/
                
                if viewModel.arrayOfTripList.count == 0{
                    return 1
                }
                return viewModel.arrayOfTripList.count
                
                
            case  .map(let arrayOfMap):
                return arrayOfMap?.count ?? 0
            case .saved:
                return 10 // static data array of book marked trip list
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell{
        if collectionView == self.collectionviewData{
            
            let cell = self.collectionviewData!.dequeueReusableCell(withReuseIdentifier: "mapinsideScrollCell", for: indexPath) as! mapinsideScrollCell
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1, execute: {
                cell.viewBG.dropShadow()
            })
            return cell
        }else{
            switch self.selectedTab{
                // albums
            case .albums:
                
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
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ProfileImagesCellXIB", for: indexPath) as! ProfileImagesCellXIB
                cell.imgviewBG.tag = indexPath.row
                cell.loadCellData(objTripModel: viewModel.arrayOfTripList[indexPath.row]) { (isVertical, index, imgheight) in
                    if self.viewModel.arrayOfTripList.indices.contains(index){
                        self.viewModel.arrayOfTripList[index].isVerticalImage = isVertical                        
                    }
                    UIView.animate(withDuration: 0.2) {
                        self.collectionviewProfile.collectionViewLayout.invalidateLayout()
//                        self.collectionviewProfile.reloadItems(at: [IndexPath.init(row: index, section: 0)])
                    }
                    //                    collectionView.reloadItems(at: [IndexPath.init(item: index, section: 0)])
                }
                cell.layoutIfNeeded()
                return cell
                
            case .map(let arrayOfMap):
                let section = (arrayOfMap ?? [])[indexPath.item]
                
                switch section{
                case .map:
                    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ProfileMapCellXIB", for: indexPath) as! ProfileMapCellXIB
                    
                    cell.layoutIfNeeded()
                    return cell
                    
                case .tripData:
                    
                    let cell = self.collectionviewProfile.dequeueReusableCell(withReuseIdentifier: "MapScrollCell", for: indexPath) as! MapScrollCell
                    
                    cell.collectionviewScroll.delegate = self
                    cell.collectionviewScroll.dataSource = self
                    (cell.collectionviewScroll.collectionViewLayout as? CHTCollectionViewWaterfallLayout)?.headerHeight = 0
                    self.collectionviewData = cell.collectionviewScroll
                    
                    return cell
                }
                // saved
            case .saved:
                
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AlbumCellDisplayXIB", for: indexPath) as! AlbumCellDisplayXIB
                
                cell.layoutIfNeeded()
                return cell
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == self.collectionviewProfile{
            switch self.selectedTab {
            case .albums:
                if let tripPageDetailVC = UIStoryboard.trip.tripPageDetailVC, self.viewModel.arrayOfTripList.indices.contains(indexPath.row){
                    tripPageDetailVC.hidesBottomBarWhenPushed = true
                    tripPageDetailVC.detailTripDataModel = self.viewModel.arrayOfTripList[indexPath.row]
                    self.navigationController?.pushViewController(tripPageDetailVC, animated: true)
                }
            default:
                break
            }
        }
    }
}

// CHTCollectionViewDelegateWaterfallLayout
extension ProfileHomeVC: CHTCollectionViewDelegateWaterfallLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if collectionView == self.collectionviewData{
            
            return CGSize(width: 325, height: 1500)
        }else{
            switch selectedTab {
                
                // albums
            case .albums:
                
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
                
                // map
            case .map(let arrayOfMap):
                let row = (arrayOfMap ?? [])[indexPath.item]
                
                switch row {
                case .map:
                    return CGSize(width: self.view.frame.width, height: 240)
                case .tripData:
                    return CGSize(width: self.view.frame.width, height: 260)
                }
                
                // save
            case .saved:
                
                var width1 = ( self.collectionviewProfile.frame.width - 15 / 2)
                width1 = width1 / 2
                debugPrint(width1)
                
                if indexPath.item == 0{
                    return CGSize(width: width1 , height: ( width1 / 2))
                }else{
                    let Width1 = (self.collectionviewProfile.frame.width)
                    return CGSize(width: Width1, height: Width1)
                }
            }
        }
    }
    
    // here return total colum need to show
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, columnCountFor section: Int) -> Int {
        
        if collectionView == self.collectionviewData{
            return 1
            
        }else{
            
            switch self.selectedTab {
                // albums
            case .albums:
                if !viewModel.isTripListFetched{
                    return 2//self.viewModel.arrayOfTripList.count == 0 ? 1 : 2 //2
                }
                return self.viewModel.arrayOfTripList.count == 0 ? 1 : 2
                
                // map
            case .map:
                return 1//arrrayofMap?.count ?? 0
                
                // save
            case .saved:
                return 2
            }
        }
    }
    
    // declaring the header collection view
    func collectionView(_ collectionView: UICollectionView,
                        viewForSupplementaryElementOfKind kind: String, at indexPath:
                        IndexPath) -> UICollectionReusableView {
        
        let cell =
        collectionView.dequeueReusableSupplementaryView(ofKind: kind,
                                                        withReuseIdentifier: "ProfileHeaderCellXIB", for: indexPath) as! ProfileHeaderCellXIB
        
        cell.viewSearchStack.isHidden = true
        cell.segmentControll.isHidden = false
        cell.segmentControll.addTarget(self, action: #selector(segmentValueChanged), for: .valueChanged)
        cell.searchtextField.delegate = self
        cell.searchtextField.addTarget(self, action: #selector(didChangeTextField(textField:)), for: .editingChanged)
        cell.searchtextField.clearButtonMode = .whileEditing
        cell.searchtextField.clearsOnInsertion = false
        cell.searchtextField.clearsOnBeginEditing = false
        switch self.selectedTab {
            
            // albums
        case .albums:
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1, execute: {
                cell.viewAlbum.ShadowWithColor()
                cell.viewMap.LightdropShadow()
                cell.viewSaved.LightdropShadow()
            })
            
            cell.segmentControll.isHidden = true
            cell.viewSearchStack.isHidden = false

            // map
        case .map:
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1, execute: {
                cell.viewAlbum.LightdropShadow()
                cell.viewMap.ShadowWithColor()
                cell.viewSaved.LightdropShadow()
            })
            
            cell.segmentControll.isHidden = true
            
            // saved
        case .saved:
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1, execute: {
                cell.viewAlbum.LightdropShadow()
                cell.viewMap.LightdropShadow()
                cell.viewSaved.ShadowWithColor()
            })
            
            cell.segmentControll.isHidden = true
            cell.viewSearchStack.isHidden = false
        }
        
        cell.btnHandlerAlbums.addTarget(self, action: #selector(self.selectFirstTab(sender: )), for: .touchUpInside)
        cell.btnHandlerMaps.addTarget(self, action: #selector(self.selectSecondTab(sender: )), for: .touchUpInside)
        cell.btnHandlerSaved.addTarget(self, action: #selector(self.selectThirdTab(sender: )), for: .touchUpInside)
        
        cell.invalidateIntrinsicContentSize()
        
        return collectionView != collectionviewData ? cell : UICollectionReusableView()
    }
    
    
   @objc func segmentValueChanged(sengment:UISegmentedControl) {
       if sengment.selectedSegmentIndex == 0{
           statusOfTrip = "C"
       }else{
           statusOfTrip = "P"
        }
       self.self.viewModel.arrayOfTripList.removeAll()
       self.viewModel.isTripListFetched = false
       self.stopLoaders()
       self.getTripListApi()
    }
    
    // header section hieght
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, heightForHeaderIn section: Int) -> CGFloat {
        if collectionView == collectionviewProfile{
            
            switch self.selectedTab{
            case .map:
                return 320//320
            case .saved:
                return 390
            default:
                return 390//467//390
            }
        }
        return 0
    }
}

// CLLocationManagerDelegate
extension ProfileHomeVC: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager,
                         didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse || status == .authorizedAlways {
            locationManager.startUpdatingLocation()
        }
    }
}

extension ProfileHomeVC:UITextFieldDelegate{
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
       return true
   }
        
   @objc func didChangeTextField(textField:UITextField) {
       searchValue = textField.text!
       // if a timer is already active, prevent it from firing
       if searchTimer != nil {
           searchTimer?.invalidate()
           searchTimer = nil
       }

       // reschedule the search: in 1.0 second, call the searchForKeyword method on the new textfield content
       searchTimer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(callSearchAPi), userInfo: nil, repeats: false)
    }
    
    @objc func callSearchAPi(){
        self.viewModel.arrayOfTripList.removeAll()
        self.stopLoaders()
        self.getTripListApi()

    }
}
// CLLocationManagerDelegate
extension ProfileHomeVC{
    /*
     {
     "status": "P",
     "userId": 1,
     "pager": {
     "pageSize": 4,
     "currentPage": 3,
     "sortOrder": 1
     }
     }
     */
    func getTripListApi(isNextPageRequest: Bool = false, isPullToRefresh:Bool = false){
        guard !self.collectionviewProfile.isAPIstillWorking else { return } // Shouldn't me making another call if already running.
        
        if !isNextPageRequest && !isPullToRefresh{
            // API_LOADER.show(animated: true)
            self.viewModel.isTripListFetched = false // show skeleton
            self.collectionviewProfile.reloadData() // show skeleton
            self.collectionviewProfile.figureOutAndShowNoResults() // don't show no schedule or scene when skeleton is being shown.
        }
        
        var param = viewModel.getPageDict(isPullToRefresh)
//        if !searchValue.isEmpty{
            param["searchValue"] = searchValue
//        }
        self.collectionviewProfile.isAPIstillWorking = true
        
        guard let userId  = APP_USER?.userId else {
            return
        }
        
        let paramDict:[String:Any] = ["userId":userId,"status":statusOfTrip, "pager":param]
        viewModel.getTripListApi(paramDict: paramDict, success: { response in
            self.stopLoaders()
            self.collectionviewProfile.reloadData()
            if isPullToRefresh{
                self.collectionviewProfile.setContentOffset(.zero, animated: true)
            }
        })
    }
    
    func stopLoaders() {
        self.viewModel.isTripListFetched = true
        self.collectionviewProfile.isAPIstillWorking = false
        self.collectionviewProfile.stopPullToRefresh()
        self.collectionviewProfile.reloadData()
        self.collectionviewProfile.figureOutAndShowNoResults()
    }
}

extension Dictionary where Value: Equatable {
    func key(from value: Value) -> Key? {
        return self.first(where: { $0.value == value })?.key
    }
}

// MARK: - UIScrollViewDelegate
extension ProfileHomeVC: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        let height = scrollView.frame.size.height
        let contentYoffset = scrollView.contentOffset.y
        let distanceFromBottom = scrollView.contentSize.height - contentYoffset
        if distanceFromBottom < height {
            // pagination
            
            switch self.selectedTab {
            case .albums:
                if viewModel.getTotalElements > viewModel.getAvailableElements &&
                    !self.collectionviewProfile.isAPIstillWorking {
                    self.getTripListApi(isNextPageRequest: true, isPullToRefresh: false)
                }
            default:
                break
            }
        }
    }
}
