//
//  SavedLocationListViewController.swift
//  MyMapp
//
//  Created by Akash Nara on 06/04/22.
//

import UIKit

class SavedLocationListViewController: UIViewController {
    
    @IBOutlet weak var labelTitle: UILabel!
    var cityId = 0
    var cityName = "Spain"
    @IBOutlet weak var tblviewData: SayNoForDataTableView!{
        didSet{
            tblviewData.setDefaultProperties(vc: self)
            tblviewData.registerCellNib(identifier: TitleHeaderTVCell.identifier)
            tblviewData.registerCellNib(identifier: TripMainLocationCellXIB.identifier)
            tblviewData.registerCellNib(identifier: CollectionViewTVCell.identifier)
            
            tblviewData.registerCellNib(identifier: SavedAdviceParentCell.identifier)
            tblviewData.registerCellNib(identifier: SavedAdviceParentBottomViewCell.identifier)
            tblviewData.registerCellNib(identifier: SavedAdviceChildCell.identifier)
            tblviewData.registerCellNib(identifier: SavedAdviceFooterCell.identifier)
            tblviewData.registerCellNib(identifier: SkeletonTripTVCell.identifier)
            tblviewData.sayNoSection = .noDataFound("No saved location found.")
            tblviewData.contentInset = UIEdgeInsets.init(top: 0, left: 0, bottom: 30, right: 0)
            tblviewData.reloadData()
        }
    }
    
    var savedAlbumLocationViewModel:SavedAlbumLocationViewModel? = nil
    var objSavedDetailVc:SavedAlbumDetailViewController? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        labelTitle.text = cityName
        labelTitle.numberOfLines = 2
    }
    
    @IBAction func buttonBackTapp(_ sender:UIButton){
        self.navigationController?.popViewController(animated: true)
    }
    
}

//MARK: - TABLEVIEW METHODS
extension SavedLocationListViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int{
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.savedAlbumLocationViewModel?.arrayOfSavedLocationList.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = self.tblviewData.dequeueCell(
            withType: TripMainLocationCellXIB.self,
            for: indexPath) as? TripMainLocationCellXIB else {
                return UITableViewCell()
            }
        guard let viewModel = savedAlbumLocationViewModel else {
            return cell
        }
        
        
        cell.labelTitle.text = viewModel.arrayOfSavedLocationList[indexPath.row].locationFav?.name
        //            cell.subTitle.text = ""//arrayLocation[indexPath.row].locationFav?.name
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
        
        cell.trealingBookmarkConstrain.constant = 10
        cell.buttonBookmark.setImage(UIImage(named: "ic_selected_saved"), for: .selected)
        cell.buttonBookmark.setImage(UIImage(named: "ic_saved_Selected_With_just_border"), for: .normal)
        cell.buttonBookmark.addTarget(self, action: #selector(buttonBookmarLocationkClicked(sender:)), for: .touchUpInside)
        cell.buttonBookmark.isSelected = viewModel.arrayOfSavedLocationList[indexPath.row].isSaved
        
        cell.buttonBookmark.tag = indexPath.section
        cell.buttonBookmark.accessibilityHint = "\(indexPath.row)"
        
        cell.buttonBookmark.isHidden = false
        
        return cell
        
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){}
    
    @objc func buttonBookmarLocationkClicked(sender:UIButton){
        guard let viewModel = savedAlbumLocationViewModel else {
            return
        }
        
        let indexRow = Int(sender.accessibilityHint ?? "") ?? 0
        if viewModel.arrayOfSavedLocationList.indices.contains(indexRow){
            debugPrint("locationList:\(viewModel.arrayOfSavedLocationList[indexRow])")
            let id = viewModel.arrayOfSavedLocationList[indexRow].id
            if viewModel.arrayOfSavedLocationList[indexRow].isSaved{
                self.unSaveLocationAndTravelApi(id: id, key:"location") {
                    sender.isSelected.toggle()
                    viewModel.arrayOfSavedLocationList[indexRow].isSaved.toggle()
                    viewModel.removedSavedObject(id: id)
                    
                    if  viewModel.arrayOfSavedLocationList.count == 0{
                        self.objSavedDetailVc?.sections.removeAll { enumCase in
                            return enumCase.sectionType == .savedLocations
                        }
                    }
                    
                    self.tblviewData.reloadData()
                    self.tblviewData.figureOutAndShowNoResults()
                    self.objSavedDetailVc?.tblviewData.reloadData()
                    self.objSavedDetailVc?.tblviewData.figureOutAndShowNoResults()
                }
            }
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

// MARK: - UIScrollViewDelegate
extension SavedLocationListViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard let viewModel = savedAlbumLocationViewModel else {
            return
        }
        
        let height = scrollView.frame.size.height
        let contentYoffset = scrollView.contentOffset.y
        let distanceFromBottom = scrollView.contentSize.height - contentYoffset
        if distanceFromBottom < height {
            // pagination
            
            if viewModel.getTotalElements > viewModel.getAvailableElements &&
                !self.tblviewData.isAPIstillWorking {
                self.getSavedLocationsListApi(isNextPageRequest: true, isPullToRefresh: false)
            }
        }
    }
}
extension SavedLocationListViewController{
    // get saved locations
    func getSavedLocationsListApi(isNextPageRequest: Bool = false, isPullToRefresh:Bool = false){
        guard let viewModel = savedAlbumLocationViewModel else {
            return
        }
        
        let param = self.savedAlbumLocationViewModel?.getPageDict(isPullToRefresh)
        let paramDict:[String:Any] = ["INTEREST_CATEGORY":"location", "pager":param,"city":self.cityId]
        viewModel.getSavedLocationListApi(paramDict: paramDict, success: { [weak self] response in
            self?.tblviewData.reloadData()
        })
    }
}
