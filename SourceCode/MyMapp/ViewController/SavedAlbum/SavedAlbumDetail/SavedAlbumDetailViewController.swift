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
            tblviewData.sayNoSection = .noDataFound("\(cityName.capitalized)'s data not found.")
            tblviewData.tableHeaderView = UIView(frame: CGRect(origin: .zero, size: CGSize(width: 0.0, height: CGFloat.leastNormalMagnitude)))

            tblviewData.contentInset = UIEdgeInsets.init(top: 0, left: 0, bottom: 30, right: 0)
            tblviewData.reloadData()
        }
    }
    
    enum EnumSection:Int {
        case savedAlbums = 0, savedLocations, savedAdvice
        var title:String{
            switch self{
            case .savedAlbums:
                return "Saved Albums"
            case .savedLocations:
                return "Saved Locations"
            case .savedAdvice:
                return "Saved Advice"
            }
        }
    }
    
    var viewModel = SavedAlbumListViewModel()
    var savedAlbumLocationViewModel = SavedAlbumLocationViewModel()
    var savedAlbumTravelAdviceViewModel = SavedAlbumTravelAdviceViewModel()
    
    var sections:[SectionModel] = []
    var arrayAdviceListArrray = [JSON]() // get list of top tips
    
    var nextPageToken:String = ""
    var cityId = 1
    var cityName = "Spain"
    var isShowWholeContent = false
    var isApiDataFeched = false

    struct SectionModel {
        var sectionType: EnumSection
        var sectionTitle = ""
        var subTitle = ""
        var isOpenCell = false
        var array = [TravelAdviceDataModel]()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        self.getAdviceForTripAPi()
        self.getSavedTripListApi()

        labelTitle.text = cityName
        labelTitle.numberOfLines = 2
        labelGotoCityPage.isHidden = false
        labelGotoCityPage.text = "go to saved page"
        let tap = UITapGestureRecognizer.init(target: self, action: #selector(handleGestureGotoCityPage))
        tap.numberOfTapsRequired = 1
        labelGotoCityPage.addGestureRecognizer(tap)
        
        /*
         //savedAlbums
         arraySavedAlbums.append(TripDataModel())
         arraySavedAlbums.append(TripDataModel())
         arraySavedAlbums.append(TripDataModel())
         arraySavedAlbums.append(TripDataModel())
         arraySavedAlbums.append(TripDataModel())
         
         if !arraySavedAlbums.count.isZero() {
         sections.append(SectionModel(sectionType: .savedAlbums))
         }
         
         sections.append(SectionModel(sectionType: .savedLocations))
         
         var toolTips = [TravelAdviceDataModel]()
         toolTips.append(TravelAdviceDataModel())
         toolTips.append(TravelAdviceDataModel())
         toolTips.append(TravelAdviceDataModel())
         
         if !toolTips.count.isZero() {
         sections.append(SectionModel(sectionType: .savedAdvice, sectionTitle: "Saved Advice" , subTitle: "Top Tips", isOpenCell: false, array: toolTips))
         }
         
         var favoriteTravelStorys = [TravelAdviceDataModel]()
         favoriteTravelStorys.append(TravelAdviceDataModel())
         favoriteTravelStorys.append(TravelAdviceDataModel())
         favoriteTravelStorys.append(TravelAdviceDataModel())
         
         if !favoriteTravelStorys.count.isZero() {
         sections.append(SectionModel(sectionType: .savedAdvice, sectionTitle: "" , subTitle: "Favorite Travel Story", isOpenCell: false, array: favoriteTravelStorys))
         }
         
         var logisticsAndRoutes = [TravelAdviceDataModel]()
         logisticsAndRoutes.append(TravelAdviceDataModel())
         logisticsAndRoutes.append(TravelAdviceDataModel())
         logisticsAndRoutes.append(TravelAdviceDataModel())
         
         if !logisticsAndRoutes.count.isZero() {
         sections.append(SectionModel(sectionType: .savedAdvice, sectionTitle: "" , subTitle: "Logistics & Routes", isOpenCell: false, array: logisticsAndRoutes))
         }
         
         
         tblviewData.reloadData()
         */
        
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
    func numberOfSections(in tableView: UITableView) -> Int{
        if !isApiDataFeched{
            return 1
        }
        return sections.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard isApiDataFeched else {
            return 5
        }
        
        switch sections[section].sectionType{
        case .savedAlbums:
            return viewModel.arrayOfTripList.count.isZero() ? 0 : 1
        case .savedLocations:
            let count  = savedAlbumLocationViewModel.arrayOfSavedLocationList.count
            return count >= 4 ? 4 : count
        case .savedAdvice:
            if sections[section].isOpenCell {
                let count  = sections[section].array.count
                return (count >= 4 ? 4 : count) + 1
            } else {
                return 1
            }
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard isApiDataFeched else {
            let cell = tblviewData.dequeueReusableCell(withIdentifier: "SkeletonTripTVCell", for: indexPath) as! SkeletonTripTVCell
            cell.startAnimating(index: indexPath.row)
            return cell
        }

        switch sections[indexPath.section].sectionType{
        case .savedAlbums:
            let cell = self.tblviewData.dequeueCell(withType: CollectionViewTVCell.self, for: indexPath) as! CollectionViewTVCell
            cell.cellConfigSavedAlbums(data: viewModel.arrayOfTripList)
            return cell
            
        case .savedLocations:
            guard let cell = self.tblviewData.dequeueCell(
                withType: TripMainLocationCellXIB.self,
                for: indexPath) as? TripMainLocationCellXIB else {
                    return UITableViewCell()
                }
            
            cell.labelTitle.text = savedAlbumLocationViewModel.arrayOfSavedLocationList[indexPath.row].locationFav?.name
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
            cell.buttonBookmark.isSelected = savedAlbumLocationViewModel.arrayOfSavedLocationList[indexPath.row].isSaved
            
            cell.buttonBookmark.tag = indexPath.section
            cell.buttonBookmark.accessibilityHint = "\(indexPath.row)"
            
            cell.buttonBookmark.isHidden = false
            
            return cell
            
        case .savedAdvice:
            if indexPath.row.isZero() {
                let cell = self.tblviewData.dequeueCell(withType: SavedAdviceParentBottomViewCell.self, for: indexPath) as! SavedAdviceParentBottomViewCell
                cell.cellConfig(isOpenCell: sections[indexPath.section].isOpenCell)
                cell.buttonDropDown.tag = indexPath.section
                cell.buttonDropDown.addTarget(self, action: #selector(dropDownActionListenerSavedAdviceParentCell(_:)), for: .touchUpInside)
                return cell
                
            } else {
                let row = getChildCellRow(indexPath: indexPath)
                let cell = self.tblviewData.dequeueCell(withType: SavedAdviceChildCell.self, for: indexPath) as! SavedAdviceChildCell
                cell.cellConfig(data: sections[indexPath.section].array[row], isLastCell: sections[indexPath.section].array.isLastIndex(row))
                cell.buttonSaveToggle.tag = indexPath.section
                cell.buttonSaveToggle.accessibilityHint = "\(indexPath.row)"
                cell.buttonSaveToggle.addTarget(self, action: #selector(saveToggleActionListenerSavedAdviceChildCell(_:)), for: .touchUpInside)
                
                cell.labelTips.tag = row
                let str = sections[indexPath.section].array[row].savedComment
                if str.isEmpty {
                    cell.labelTips.isHidden = true
                } else {
                    cell.labelTips.isHidden = false
                    cell.labelTips.isShowWholeContent = sections[indexPath.section].array[row].isExpand
                    cell.labelTips.readLessText = " " + "see less"
                    cell.labelTips.readMoreText = " " + "see more"
                    cell.labelTips.isOneLinedContent = true
                    cell.labelTips.setContent(str, noOfCharacters: 120, readMoreTapped: {
                        self.sections[indexPath.section].array[row].isExpand = true

                        self.isShowWholeContent = true
                        self.tblviewData.reloadData()
                    }) {
                        self.sections[indexPath.section].array[row].isExpand = false
                        self.isShowWholeContent = false
                        self.tblviewData.reloadData()
                    }
                }

                return cell
            }
        }
    }
        
    @objc func saveToggleActionListenerSavedAdviceChildCell(_ sender : UIButton){
        guard let rowString = sender.accessibilityHint, let rowCell = Int(rowString) else { return }
        let row = getChildCellRow(indexPath: IndexPath(row: rowCell, section: sender.tag))
        
        let id = sections[sender.tag].array[row].id
        self.unSaveLocationAndTravelApi(id: id, key: "advice") { [self] in
            self.removeTravelAdvice(id: id, indexpath: IndexPath.init(row: row, section: sender.tag))
        }
    }
    
    func removeTravelAdvice(id:Int,indexpath:IndexPath){
        
        self.savedAlbumTravelAdviceViewModel.removedSavedObject(id: id)
        self.sections[indexpath.section].array[indexpath.row].isSaved.toggle()
        self.sections[indexpath.section].array.remove(at: indexpath.row)
        
        let sectionTitle = self.sections[indexpath.section].sectionTitle
        if self.sections[indexpath.section].array.count == 0{
            self.sections.remove(at: indexpath.section)
            
            if !sectionTitle.isEmpty{
                if sections.count > indexpath.section, sections[indexpath.section].sectionType == .savedAdvice{
                    sections[indexpath.section].sectionTitle = sectionTitle
                }
            }
        }
        
        self.tblviewData.reloadData()
        self.tblviewData.figureOutAndShowNoResults()

    }
    
    @objc func buttonBookmarLocationkClicked(sender:UIButton){
        let indexRow = Int(sender.accessibilityHint ?? "") ?? 0
        if savedAlbumLocationViewModel.arrayOfSavedLocationList.indices.contains(indexRow){
            debugPrint("locationList:\(savedAlbumLocationViewModel.arrayOfSavedLocationList[indexRow])")
            let id = savedAlbumLocationViewModel.arrayOfSavedLocationList[indexRow].id
            if savedAlbumLocationViewModel.arrayOfSavedLocationList[indexRow].isSaved{
                self.unSaveLocationAndTravelApi(id: id, key:"location") {
                    sender.isSelected.toggle()
                    self.savedAlbumLocationViewModel.arrayOfSavedLocationList[indexRow].isSaved.toggle()
                    self.savedAlbumLocationViewModel.removedSavedObject(id: id)
                    
                    if self.savedAlbumLocationViewModel.arrayOfSavedLocationList.count == 0{
                        self.sections.removeAll { enumCase in
                           return enumCase.sectionType == .savedLocations
                        }
                    }
                    self.tblviewData.reloadData()
                    self.tblviewData.figureOutAndShowNoResults()
                }
            }else{
                self.saveLocationTripApi(id: id) {
                    sender.isSelected.toggle()
                    self.savedAlbumLocationViewModel.arrayOfSavedLocationList[indexRow].isSaved.toggle()
                }
            }
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        guard isApiDataFeched else {
            return 100
        }

        switch sections[indexPath.section].sectionType{
        case .savedAlbums:
            return SavedAlbumCVCell.cellSize.height
        default:
            return UITableView.automaticDimension
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        guard isApiDataFeched else {
            return
        }

        switch sections[indexPath.section].sectionType{
        case .savedAdvice:
            let row = getChildCellRow(indexPath: indexPath)
        default:
            break
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        guard isApiDataFeched else {
            return nil
        }

        switch sections[section].sectionType{
        case .savedAdvice:
            let cell = self.tblviewData.dequeueCell(withType: SavedAdviceParentCell.self) as! SavedAdviceParentCell
            cell.cellConfig(data: sections[section])
            cell.buttonDropDown.tag = section
            cell.buttonDropDown.addTarget(self, action: #selector(dropDownActionListenerSavedAdviceParentCell(_:)), for: .touchUpInside)
            return cell
        default:
            let cell = self.tblviewData.dequeueCell(withType: TitleHeaderTVCell.self) as! TitleHeaderTVCell
            cell.cellConfig(title: sections[section].sectionType.title)
            return cell
        }
    }
    
    @objc func dropDownActionListenerSavedAdviceParentCell(_ sender : UIButton){
        sections[sender.tag].isOpenCell.toggle()
        tblviewData.reloadData()
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        guard isApiDataFeched else {
            return 0
        }
        switch sections[section].sectionType{
        case .savedAdvice:
            return SavedAdviceParentCell.getCellHeight(sectionTitle: sections[section].sectionTitle)
        default:
            return 60
        }
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        guard isApiDataFeched else {
            return 0.01
        }

        switch sections[section].sectionType{
        case .savedLocations:
            return savedAlbumLocationViewModel.arrayOfSavedLocationList.count > 4 ? 50 : 0.01
        case .savedAdvice:
            return SavedAdviceFooterCell.getHeight(isOpenCell: sections[section].isOpenCell)
        default:
            return 0.01
        }
    }
    
    func getChildCellRow(indexPath: IndexPath) -> Int {
        return indexPath.row - 1
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        guard isApiDataFeched else {
            return nil
        }

        switch sections[section].sectionType {
        case .savedLocations:
            let yourAttributes: [NSAttributedString.Key: Any] = [
                NSAttributedString.Key.font: UIFont.Montserrat.Medium(15),
                NSAttributedString.Key.foregroundColor: UIColor.darkGray,
                NSAttributedString.Key.underlineStyle: NSUnderlineStyle.single.rawValue
            ] // .styleDouble.rawValue, .styleThick.rawValue, .styleNone.rawValue
            
            let attributeString = NSMutableAttributedString(
                string: "Read more",
                attributes: yourAttributes
            )
            
            let footerView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 44.0))
            let doneButton = UIButton(frame: CGRect(x: tableView.frame.width - 130, y: 0, width: 130, height: 44.0))
            doneButton.setAttributedTitle(attributeString, for: .normal)
            doneButton.layer.cornerRadius = 10.0
            doneButton.addTarget(self, action: #selector(buttonReadMoreClikced), for: .touchUpInside)
            footerView.addSubview(doneButton)
            
            return savedAlbumLocationViewModel.arrayOfSavedLocationList.count > 4 ? footerView : nil

        case .savedAdvice:
            let cell = self.tblviewData.dequeueCell(withType: SavedAdviceFooterCell.self) as! SavedAdviceFooterCell
            cell.cellConfig(isOpenCell: sections[section].isOpenCell)
            return cell
        default:
            return nil
        }
    }
    
    @objc func buttonReadMoreClikced(){
        guard let savedLocationListVC = UIStoryboard.tabbar.savedLocationListVC else {
            return
        }
        savedLocationListVC.cityName = self.cityName
        savedLocationListVC.cityId = cityId
        savedLocationListVC.savedAlbumLocationViewModel = self.savedAlbumLocationViewModel
        savedLocationListVC.objSavedDetailVc = self
        self.navigationController?.pushViewController(savedLocationListVC, animated: true)
    }
    
    @objc func buttonReadMoreTravelAdviceClikced(){
        guard let travelAdviceListVC = UIStoryboard.tabbar.travelAdviceListVC else {
            return
        }
        travelAdviceListVC.cityName = self.cityName
        travelAdviceListVC.cityId = cityId
        travelAdviceListVC.savedAlbumTravelAdviceViewModel = self.savedAlbumTravelAdviceViewModel
        travelAdviceListVC.objSavedDetailVc = self
        self.navigationController?.pushViewController(travelAdviceListVC, animated: true)
    }
}

// apis
extension SavedAlbumDetailViewController{
    
    // get saved trips
    func getSavedTripListApi(isNextPageRequest: Bool = false, isPullToRefresh:Bool = false){
        let param = viewModel.getPageDict(isPullToRefresh)
        let paramDict:[String:Any] = ["INTEREST_CATEGORY":"feed", "pager":param, "city":self.cityId]
        viewModel.getSavedTripListApi(paramDict: paramDict, success: { [weak self] response in
            
            // add saved albums section
            if !(self?.viewModel.arrayOfTripList.count.isZero() ?? false) {
                self?.sections.append(SectionModel(sectionType: .savedAlbums))
            }
            self?.getSavedLocationsListApi()
        })
    }
    
    // get saved locations
    func getSavedLocationsListApi(isNextPageRequest: Bool = false, isPullToRefresh:Bool = false){
        let param = savedAlbumLocationViewModel.getPageDict(isPullToRefresh)
        let paramDict:[String:Any] = ["INTEREST_CATEGORY":"location", "pager":param,"city":self.cityId]
        savedAlbumLocationViewModel.getSavedLocationListApi(paramDict: paramDict, success: { [weak self] response in
            
            // add saved location section
            if !(self?.savedAlbumLocationViewModel.arrayOfSavedLocationList.count.isZero() ?? false) {
                self?.sections.append(SectionModel(sectionType: .savedLocations))
            }
            self?.getSavedTopTipListApi()
        })
    }
    
    // get saved toptips
    func getSavedTopTipListApi(isNextPageRequest: Bool = false, isPullToRefresh:Bool = false){
        let param = savedAlbumTravelAdviceViewModel.getPageDict(isPullToRefresh)
        let paramDict:[String:Any] = ["INTEREST_CATEGORY":"advice", "pager":param,"city":self.cityId]
        savedAlbumTravelAdviceViewModel.getSavedTravelAdvicesListApi(paramDict: paramDict, success: { [weak self] response in
            
            // add saved advices section
            if !(self?.savedAlbumTravelAdviceViewModel.arrayOfSavedTopTipsList.count.isZero() ?? false) {
                self?.preparedSectionAndArrayOfTraveAdvice()
            }
            self?.isApiDataFeched = true
            self?.tblviewData.reloadData()
            self?.tblviewData.figureOutAndShowNoResults()
        })
    }
    
    func removedObject(id:Int){
//        let toolTips = savedAlbumTravelAdviceViewModel.arrayOfSavedTopTipsList.filter({$0.travelEnumTypeValue == 1})
//        let favoriteTravelStorys = savedAlbumTravelAdviceViewModel.arrayOfSavedTopTipsList.filter({$0.travelEnumTypeValue == 2})
//        let logisticsAndRoutes = savedAlbumTravelAdviceViewModel.arrayOfSavedTopTipsList.filter({$0.travelEnumTypeValue == 3})
        
        if let indexSection = sections.firstIndex(where: {$0.sectionType == .savedAdvice}), let row = sections[indexSection].array.firstIndex(where: {$0.id == id}){
            removeTravelAdvice(id: id, indexpath: IndexPath.init(row: row, section: indexSection))
        }
    }
    
    
    func preparedSectionAndArrayOfTraveAdvice(){
        
        let toolTips = savedAlbumTravelAdviceViewModel.arrayOfSavedTopTipsList.filter({$0.travelEnumTypeValue == 1})
        let favoriteTravelStorys = savedAlbumTravelAdviceViewModel.arrayOfSavedTopTipsList.filter({$0.travelEnumTypeValue == 2})
        let logisticsAndRoutes = savedAlbumTravelAdviceViewModel.arrayOfSavedTopTipsList.filter({$0.travelEnumTypeValue == 3})
        
        var sectionName = ""
        arrayAdviceListArrray.forEach { jsonObj in
            let title = jsonObj["value"].stringValue
            let placeHolder = jsonObj["placeHolder"].stringValue
            switch jsonObj["id"].intValue{
            case 1:
                if !toolTips.count.isZero() {
                    sectionName = "Saved Advice"
                    sections.append(SectionModel(sectionType: .savedAdvice, sectionTitle: sectionName, subTitle: title, isOpenCell: false, array: toolTips))
                }
            case 2:
                if !favoriteTravelStorys.count.isZero() {
                    if !sectionName.isEmpty{
                        sectionName = ""
                    }else{
                        sectionName = "Saved Advice"
                    }
                    sections.append(SectionModel(sectionType: .savedAdvice, sectionTitle: sectionName , subTitle: title, isOpenCell: false, array: favoriteTravelStorys))
                }
            case 3:
                if !logisticsAndRoutes.count.isZero() {
                    if !sectionName.isEmpty{
                        sectionName = ""
                    }else{
                        sectionName = "Saved Advice"
                    }
                    sections.append(SectionModel(sectionType: .savedAdvice, sectionTitle: sectionName , subTitle: title, isOpenCell: false, array: logisticsAndRoutes))
                }
            default:
                break
            }
        }
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
            NotificationCenter.default.post(name: NSNotification.Name.init(rawValue: "reloadUserTripList"), object: nil)
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
            
            
            NotificationCenter.default.post(name: NSNotification.Name.init(rawValue: "reloadUserTripList"), object: nil)
            NotificationCenter.default.post(name: NSNotification.Name.init(rawValue: "reloadSavedTripList"), object: nil)
            success?()
        }  internetFailure: {
            API_LOADER.HIDE_CUSTOM_LOADER()
            debugPrint("internetFailure")
        } failureInform: {
            self.HIDE_CUSTOM_LOADER()
        }
    }
    
    func getAdviceForTripAPi(){
        
        API_SERVICES.callAPI([:], path: .getAdviceForCityTrip, method: .get) { [weak self] response in
            guard let status = response?["status"]?.intValue, status == 200 else {
                Utility.errorMessage(message: response?["msg"]?.stringValue ?? "")
                return
            }
            
            guard let arrayOfAdvices = response?["responseJson"]?.dictionaryValue["advices"]?.arrayValue  else {
                return
            }
            self?.arrayAdviceListArrray = arrayOfAdvices
        } internetFailure: {
            debugPrint("internetFailure")
        }
    }
}
