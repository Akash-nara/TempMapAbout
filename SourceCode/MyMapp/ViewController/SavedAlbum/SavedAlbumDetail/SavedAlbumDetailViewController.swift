//
//  SavedAlbumDetailViewController.swift
//  MyMapp
//
//  Created by Akash Nara on 30/03/22.
//

import UIKit

class SavedAlbumDetailViewController: UIViewController {
    
    //MARK: - OUTLETS
    @IBOutlet weak var labelTitle: UILabel!
    @IBOutlet weak var labelGotoCityPage: UILabel!
    @IBOutlet weak var tblviewData: UITableView!{
        didSet{
            tblviewData.setDefaultProperties(vc: self)
            tblviewData.registerCell(type: TitleHeaderTVCell.self, identifier: TitleHeaderTVCell.identifier)
            tblviewData.registerCell(type: ExploreTableDataCell.self, identifier: ExploreTableDataCell.identifier)
            tblviewData.registerCell(type: TripMainLocationCellXIB.self, identifier: TripMainLocationCellXIB.identifier)
            tblviewData.registerCell(type: ExploreTripTopCellXIB.self, identifier: ExploreTripTopCellXIB.identifier)
            tblviewData.registerCell(type: CollectionViewTVCell.self, identifier: CollectionViewTVCell.identifier)
            tblviewData.registerCellNib(identifier: ExpandableTVCell.identifier)
            
            tblviewData.contentInset = UIEdgeInsets.init(top: 0, left: 0, bottom: 30, right: 0)
        }
    }
    enum EnumSavedAlbumType:Int {
        case savedAlbums = 0, savedLocations, savedToptips
        var title:String{
            switch self{
            case .savedAlbums:
                return "Saved Albums"
            case .savedLocations:
                return "Saved Locations"
            case .savedToptips:
                return "Saved Advice"
            }
        }
    }
    var viewModel = SavedAlbumListViewModel()
    
    var arrayOfSections:[EnumSavedAlbumType] = []
    var arrayOfToolTips = [TravelAdviceDataModel]()
    var arraySavedAlbums = [TripDataModel]()
    var arraySavedLocations = [AddTripFavouriteLocationDetail]()
    var nextPageToken:String = ""
    var cityId = 0
    var cityName = "Spain"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        labelTitle.text = cityName
        labelTitle.numberOfLines = 2
        labelGotoCityPage.isHidden = false
        let tap = UITapGestureRecognizer.init(target: self, action: #selector(handleGestureGotoCityPage))
        tap.numberOfTapsRequired = 1
        labelGotoCityPage.addGestureRecognizer(tap)
        
        arrayOfSections.append(.savedAlbums)
        arrayOfSections.append(.savedLocations)
        arrayOfSections.append(.savedToptips)
        tblviewData.reloadData()
        
        getSavedTripListApi()
        //        getSavedLocationsListApi()
        //        getSavedTopTipListApi()
    }
    
    @objc func handleGestureGotoCityPage(){
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func buttonBackTapp(_ sender:UIButton){
        self.navigationController?.popViewController(animated: true)
    }
}

//MARK: - TABLEVIEW METHODS
extension SavedAlbumDetailViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch arrayOfSections[section]{
        case .savedLocations:
            return 5//arraySavedLocations.count
        case .savedAlbums:
            return arraySavedAlbums.count
        case .savedToptips:
            return arrayOfToolTips.count
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int{
        return arrayOfSections.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch arrayOfSections[indexPath.section]{
        case .savedAlbums:
            guard let cell = self.tblviewData.dequeueCell(
                withType: ExploreTableDataCell.self,
                for: indexPath) as? ExploreTableDataCell else {
                    return UITableViewCell()
                }
            return cell
        case .savedLocations:
            guard let cell = self.tblviewData.dequeueCell(
                withType: TripMainLocationCellXIB.self,
                for: indexPath) as? TripMainLocationCellXIB else {
                    return UITableViewCell()
                }
            cell.labelTitle.text = "Ahmdabad"//arrayLocation[indexPath.row].locationFav?.name
            cell.subTitle.text = ""//arrayLocation[indexPath.row].locationFav?.name
            cell.locationImage.showSkeleton()
            cell.locationImage.sd_setImage(with: URL.init(string: ""), placeholderImage: nil, options: .highPriority) { img, error, cache, url in
                cell.locationImage.hideSkeleton()
                if let image = img{
                    cell.locationImage.image = image
                }else{
                    /* temp commeneted code
                    cell.locationImage.image = UIImage.init(named: "not_icon")
                    cell.locationImage.contentMode = .scaleToFill
                    cell.locationImage.backgroundColor = .white
                    cell.locationImage.borderWidth = 0.5
                    cell.locationImage.borderColor = UIColor.App_BG_silver_Color
                     */
                    
                    cell.getGooglePhotoByCity(cityName: cell.labelTitle.text!)
                }
            }
            
            cell.buttonBookmark.setImage(UIImage(named: "ic_selected_saved"), for: .selected)
            cell.buttonBookmark.setImage(UIImage(named: "ic_saved_Selected_With_just_border"), for: .normal)
            cell.buttonBookmark.addTarget(self, action: #selector(buttonBookmarLocationkClicked(sender:)), for: .touchUpInside)
            cell.buttonBookmark.isSelected = false//arrayLocation[indexPath.row].isSaved
            
            cell.buttonBookmark.tag = indexPath.section
            cell.buttonBookmark.accessibilityHint = "\(indexPath.row)"
            
            cell.buttonBookmark.isHidden = false

            return cell
        case .savedToptips:
            guard let cell = self.tblviewData.dequeueCell(
                withType: ExploreTableDataCell.self,
                for: indexPath) as? ExploreTableDataCell else {
                    return UITableViewCell()
                }
            return cell
        }
    }
    
    @objc func buttonBookmarLocationkClicked(sender:UIButton){
        sender.isSelected.toggle()
        let indexRow = Int(sender.accessibilityHint ?? "") ?? 0
        if arraySavedLocations.indices.contains(indexRow){
            debugPrint("locationList:\(arraySavedLocations[indexRow])")
            if arraySavedLocations[indexRow].isSaved{
                self.unSaveLocationAndTravelApi(id: arraySavedLocations[indexRow].id, key:"location") {
                    sender.isSelected.toggle()
                    self.arraySavedLocations[indexRow].isSaved.toggle()
                }
            }else{
                self.saveLocationTripApi(id: arraySavedLocations[indexRow].id) {
                    sender.isSelected.toggle()
                    self.arraySavedLocations[indexRow].isSaved.toggle()
                }
            }
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){}
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let cell = self.tblviewData.dequeueCell(withType: TitleHeaderTVCell.self) as! TitleHeaderTVCell
        cell.cellConfig(title: arrayOfSections[section].title)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 60
    }
}
// apis
extension SavedAlbumDetailViewController{
    
    // get saved trips
    func getSavedTripListApi(isNextPageRequest: Bool = false, isPullToRefresh:Bool = false){
        let param = viewModel.getPageDict(isPullToRefresh)
        
        let paramDict:[String:Any] = ["INTEREST_CATEGORY":"feed", "pager":param]
        viewModel.getSavedTripListApi(paramDict: paramDict, success: { response in
            debugPrint("feed Response:-\(response)")
        })
    }
    
    // get saved locations
    func getSavedLocationsListApi(isNextPageRequest: Bool = false, isPullToRefresh:Bool = false){
        let param = viewModel.getPageDict(isPullToRefresh)
        let paramDict:[String:Any] = ["INTEREST_CATEGORY":"location", "pager":param]
        viewModel.getSavedTripListApi(paramDict: paramDict, success: { response in
            debugPrint("location Response:-\(response)")
        })
    }
    
    // get saved toptips
    func getSavedTopTipListApi(isNextPageRequest: Bool = false, isPullToRefresh:Bool = false){
        let param = viewModel.getPageDict(isPullToRefresh)
        let paramDict:[String:Any] = ["INTEREST_CATEGORY":"advice", "pager":param]
        viewModel.getSavedTripListApi(paramDict: paramDict, success: { response in
            debugPrint("topTips Response:-\(response)")
        })
    }
    
    func saveLocationTripApi(id:Int, success: (() -> ())? = nil){
        guard let userId = APP_USER?.userId else {
            return
        }
        let strJson = JSON(["location": ["id":id],
                            "userId":userId,
                            "INTEREST_CATEGORY": "location"]).rawString(.utf8, options: .sortedKeys) ?? ""
        let param: [String: Any] = ["requestJson" : strJson]
        
        API_SERVICES.callAPI(param, path: .saveTrip, method: .post) { [weak self] dataResponce in
            self?.HIDE_CUSTOM_LOADER()
            guard let status = dataResponce?["status"]?.intValue, status == 200 else {
                return
            }
            NotificationCenter.default.post(name: NSNotification.Name.init(rawValue: "reloadSavedTripList"), object: nil)
            success?()
        }  internetFailure: {
            API_LOADER.HIDE_CUSTOM_LOADER()
            debugPrint("internetFailure")
        } failureInform: {
            self.HIDE_CUSTOM_LOADER()
        }
    }
    
    // saved travel
    func saveTravelAdviceApi(id:Int, success: (() -> ())? = nil){
        guard let userId = APP_USER?.userId else {
            return
        }

        let strJson = JSON(["advice": ["id":id],
                            "userId":userId,
                            "INTEREST_CATEGORY": "advice"]).rawString(.utf8, options: .sortedKeys) ?? ""
        let param: [String: Any] = ["requestJson" : strJson]
        
        API_SERVICES.callAPI(param, path: .saveTrip, method: .post) { [weak self] dataResponce in
            self?.HIDE_CUSTOM_LOADER()
            guard let status = dataResponce?["status"]?.intValue, status == 200 else {
                return
            }
            NotificationCenter.default.post(name: NSNotification.Name.init(rawValue: "reloadSavedTripList"), object: nil)
            success?()
        }  internetFailure: {
            API_LOADER.HIDE_CUSTOM_LOADER()
            debugPrint("internetFailure")
        } failureInform: {
            self.HIDE_CUSTOM_LOADER()
        }
    }
    
    // un saved travel and location
    func unSaveLocationAndTravelApi(id:Int, key:String, success: (() -> ())? = nil){
        let strJson = JSON(["id":id,"INTEREST_CATEGORY": key]).rawString(.utf8, options: .sortedKeys) ?? ""
        let param: [String: Any] = ["requestJson" : strJson]
        API_SERVICES.callAPI(param, path: .unSaveTrip, method: .post) { [weak self] dataResponce in
            self?.HIDE_CUSTOM_LOADER()
            guard let status = dataResponce?["status"]?.intValue, status == 200 else {
                return
            }
            
            NotificationCenter.default.post(name: NSNotification.Name.init(rawValue: "reloadSavedTripList"), object: nil)
            success?()
        }  internetFailure: {
            API_LOADER.HIDE_CUSTOM_LOADER()
            debugPrint("internetFailure")
        } failureInform: {
            self.HIDE_CUSTOM_LOADER()
        }
    }
}
