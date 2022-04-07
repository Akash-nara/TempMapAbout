//
//  ExploreTripDetailViewController.swift
//  MyMapp
//
//  Created by Akash on 09/03/22.
//

import UIKit
import SwiftyJSON
import MapKit


class ExploreTripDetailViewController: UIViewController {
    
    
    //MARK: - OUTLETS
    var cityId = 0
    var cityName = "Spain"
    @IBOutlet weak var labelTitle: UILabel!
    @IBOutlet weak var labelToSaved: UILabel!
    @IBOutlet weak var tblviewData: UITableView!{
        didSet{
            tblviewData.setDefaultProperties(vc: self)
            tblviewData.registerCell(type: TitleHeaderTVCell.self, identifier: TitleHeaderTVCell.identifier)
            tblviewData.registerCell(type: ExploreTableDataCell.self, identifier: ExploreTableDataCell.identifier)
            tblviewData.registerCell(type: MapExploreTVCell.self, identifier: MapExploreTVCell.identifier)
            tblviewData.registerCell(type: ExploreTripTopCellXIB.self, identifier: ExploreTripTopCellXIB.identifier)
            tblviewData.registerCell(type: CollectionViewTVCell.self, identifier: CollectionViewTVCell.identifier)
            tblviewData.registerCellNib(identifier: ExpandableTVCell.identifier)
            
            tblviewData.contentInset = UIEdgeInsets.init(top: 0, left: 0, bottom: 30, right: 0)
        }
    }
    //    var isShowWholeContent = false
    enum EnumTripType:Int {
        case maps = 0, expandableViews, popularCities, featuredPlaces, topTips
        var title:String{
            switch self{
            case .maps:
                return ""
            case .expandableViews:
                return ""
            case .popularCities:
                return "Most Popular Cities"
            case .featuredPlaces:
                return "Featured Places"
            case .topTips:
                return "Top Tips"
            }
        }
    }
    
    var arrayOfToolTips = [TravelAdviceDataModel]()
    var arrayOfSections:[EnumTripType] = []
    var arrayFeaturedPlaces = [JSON]()
    var arrayExpandable = [ExploreSuggestionDataModel]()
    var latLong:CLLocationCoordinate2D? = nil
    var nextPageToken:String = ""
    
    static var arrayStorePlaceId:[String]  = [String]()
    var savedAlbumTravelAdviceViewModel:SavedAlbumTravelAdviceViewModel = SavedAlbumTravelAdviceViewModel()
    var readMoreCount = 5
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        labelTitle.text = cityName
        labelTitle.numberOfLines = 2
        labelToSaved.isHidden = true
        
        ExploreTripDetailViewController.arrayStorePlaceId.removeAll()
        getSavedGooglePlaceIdListApi { [weak self] in
            self?.getAdminSuggestion()
        }
        
        // Maps
        arrayOfSections.append(.maps)
    }
    
    deinit {
        ExploreTripDetailViewController.arrayStorePlaceId.removeAll()
    }
    
    func configureTopTipsArray(){
        
        // here static displayed for kabul only
        //        if cityId == 1{
        //            // ToolTips
        //            arrayOfToolTips.append(false)
        //            arrayOfToolTips.append(false)
        //            arrayOfToolTips.append(false)
        //            if !arrayOfToolTips.count.isZero() {
        //                arrayOfSections.append(.topTips)
        //            }
        //        }
    }
    
    @IBAction func buttonBackTapp(_ sender:UIButton){
        self.navigationController?.popViewController(animated: true)
    }
}

//MARK: - TABLEVIEW METHODS
extension ExploreTripDetailViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int{
        return arrayOfSections.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch arrayOfSections[section] {
        case .maps:
            return 1
        case .expandableViews:
            return arrayExpandable.count
        case .featuredPlaces:
            return 1
        case .topTips:
            return arrayOfToolTips.count >= readMoreCount ? readMoreCount : arrayOfToolTips.count
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch arrayOfSections[indexPath.section]{
        case .maps:
            guard let cell = self.tblviewData.dequeueCell(
                withType: MapExploreTVCell.self,
                for: indexPath) as? MapExploreTVCell else {
                    return UITableViewCell()
                }
            cell.cityName = self.cityName
            cell.latLong = self.latLong
            cell.loadDefaultPosition()
            //            cell.configureMap()
            return cell
        case .expandableViews:
            let cell = tblviewData.dequeueCell(withType: ExpandableTVCell.self, for: indexPath) as! ExpandableTVCell
            //            cell.cellConfigExpandable(isOpen: arrayExpandable[indexPath.row].isOpenCell)
            cell.cellConfig(data: arrayExpandable[indexPath.row])
            cell.buttonExpandToggle.tag = indexPath.row
            cell.buttonExpandToggle.addTarget(self, action: #selector(self.cellButtonExpandToggleClicked(_:)), for: .touchUpInside)
            cell.buttonHere.tag = indexPath.row
            cell.buttonHere.addTarget(self, action: #selector(self.cellButtonHereClicked(_:)), for: .touchUpInside)
            return cell
        case .featuredPlaces:
            let cell = tblviewData.dequeueCell(withType: CollectionViewTVCell.self, for: indexPath) as! CollectionViewTVCell
            cell.cellConfigFeaturedPlacesCell(data: arrayFeaturedPlaces)
            cell.cityId = self.cityId
            cell.reachedScrollEndTap = { [weak self] in
                if !(self?.nextPageToken.isEmpty ?? true){
                    self?.getGoogleTripsDetial(isNextPage: true)
                }else{
                    CollectionViewTVCell.isGooglelPageApiWorking = false
                }
            }
            
            return cell
        case .topTips:
            return configureAdvanceTravelCell(indexPath: indexPath, title: arrayOfToolTips[indexPath.row].userName, subTitle: arrayOfToolTips[indexPath.row].savedComment, icon: arrayOfToolTips[indexPath.row].userProfilePic, isExpadCell: arrayOfToolTips[indexPath.row].isExpand)
        default:
            return UITableViewCell()
        }
    }
    
    @objc func cellButtonExpandToggleClicked(_ sender: UIButton) {
        arrayExpandable[sender.tag].isOpenCell.toggle()
        tblviewData.reloadData()
    }
    
    @objc func cellButtonHereClicked(_ sender: UIButton) {
        print(arrayExpandable[sender.tag])
        
        guard let submitSuggestionOfTripVC = UIStoryboard.tabbar.submitSuggestionOfTripVC else {
            return
        }
        
        submitSuggestionOfTripVC.hidesBottomBarWhenPushed = true
        submitSuggestionOfTripVC.cityName = cityName
        submitSuggestionOfTripVC.cityId = cityId
        self.navigationController?.present(submitSuggestionOfTripVC, animated: true, completion: nil)
    }
    
    func configureAdvanceTravelCell(indexPath:IndexPath, title:String, subTitle:String, icon:String,isExpadCell:Bool) -> ExploreTripTopCellXIB{
        let cell = self.tblviewData.dequeueReusableCell(withIdentifier: "ExploreTripTopCellXIB", for: indexPath) as! ExploreTripTopCellXIB
        cell.userIcon.setImage(url: icon, placeholder: UIImage.init(named: "not_icon"))
        cell.userIcon.setBorderWithColor()
        cell.trealingViewExpand.constant = 50
        
        cell.buttonBookmark.setImage(UIImage(named: "ic_selected_saved"), for: .selected)
        cell.buttonBookmark.setImage(UIImage(named: "ic_saved_Selected_With_just_border"), for: .normal)
        cell.buttonBookmark.addTarget(self, action: #selector(buttonBookmarkClicked(sender:)), for: .touchUpInside)
        cell.buttonBookmark.tag = indexPath.row
        cell.buttonBookmark.accessibilityHint = "\(indexPath.section)"
        cell.buttonBookmark.isSelected  = arrayOfToolTips[indexPath.row].isSaved
        
        cell.lblHeader.text = title
        cell.labelSubTitle.text = subTitle
        cell.bottomConstrainOfMainStackView.constant = isExpadCell ? 20 : 8
        
        cell.labelSubTitle.tag = indexPath.row
        let str = subTitle
        if str.isEmpty {
            cell.labelSubTitle.isHidden = true
        } else {
            cell.labelSubTitle.isHidden = false
            cell.labelSubTitle.isShowWholeContent = self.arrayOfToolTips[cell.labelSubTitle.tag].isExpand
            cell.labelSubTitle.readLessText = " " + "see less"
            cell.labelSubTitle.readMoreText = " " + "see more"
            cell.labelSubTitle.isOneLinedContent = true
            cell.labelSubTitle.setContent(str, noOfCharacters: 120, readMoreTapped: {
                self.arrayOfToolTips[cell.labelSubTitle.tag].isExpand = true
                //                self.reloadToptipsSection(sender: cell.labelSubTitle.tag)
                self.tblviewData.reloadData()
            }) {
                self.arrayOfToolTips[cell.labelSubTitle.tag].isExpand = false
                //                self.reloadToptipsSection(sender: cell.labelSubTitle.tag)
                self.tblviewData.reloadData()
            }
        }
        return cell
    }
    
    func reloadToptipsSection(sender:Int){
        if let section = arrayOfSections.firstIndex(where: {$0 == .topTips}){
            self.tblviewData.reloadRows(at: [IndexPath.init(row: sender, section: section)], with: .automatic)
            //            self.tblviewData.reloadSections(IndexSet.init(integer: section), with: .automatic)
        }
    }
    
    @objc func buttonBookmarkClicked(sender:UIButton){
        let id  = arrayOfToolTips[sender.tag].savedId
        self.unSaveLocationAndTravelApi(id: id, key: "advice") {
            sender.isSelected.toggle()
            self.arrayOfToolTips[sender.tag].isSaved.toggle()
//            self.savedAlbumTravelAdviceViewModel.removedSavedObject(id: id)
            self.tblviewData.reloadData()
        }
    }
    
    //MARK: - OTHER FUNCTIONS
    @objc func isExpandTravelAdvice(_ sender:UITapGestureRecognizer){
        let section = (Int(sender.accessibilityHint ?? "") ?? 0)
        let row = (Int(sender.accessibilityLabel ?? "") ?? 0)
        arrayOfToolTips[IndexPath.init(row: row, section: section).row].isExpand.toggle()
        self.tblviewData.reloadSections(IndexSet.init(integer: section), with: .automatic)
        //        self.tblviewData.reloadData()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch arrayOfSections[indexPath.section]{
        case .featuredPlaces:
            return FeaturedPlacesCVCell.cellSize.height
        default:
            return UITableView.automaticDimension
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){}
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        switch arrayOfSections[section] {
        case .featuredPlaces, .topTips:
            let cell = self.tblviewData.dequeueCell(withType: TitleHeaderTVCell.self) as! TitleHeaderTVCell
            cell.cellConfig(title: arrayOfSections[section].title)
            
            return cell
        default:
            return nil
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        switch arrayOfSections[section] {
        case .featuredPlaces, .topTips:
            return 60
        default:
            return  0.01
        }
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        guard arrayOfToolTips.count != 0 else {
            return nil
        }
        switch arrayOfSections[section] {
        case .topTips:
            
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
            
            return arrayOfToolTips.count >= readMoreCount ? footerView : nil
            
        default:
            return  nil
        }
    }
    
    @objc func buttonReadMoreClikced(){
        
        guard let travelAdviceListVC = UIStoryboard.tabbar.travelAdviceListVC else {
            return
        }
        travelAdviceListVC.cityName = self.cityName
        travelAdviceListVC.cityId = cityId
        travelAdviceListVC.savedAlbumTravelAdviceViewModel = self.savedAlbumTravelAdviceViewModel
        travelAdviceListVC.saveUnSaveStatusUpdateCallback = { id in
            self.savedAlbumTravelAdviceViewModel.updateStatusSavedObject(id: id)
            self.tblviewData.reloadData()
        }
        self.navigationController?.pushViewController(travelAdviceListVC, animated: true)
        
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        guard arrayOfToolTips.count != 0 else {
            return 0.01
        }
        switch arrayOfSections[section] {
        case .topTips:
            return arrayOfToolTips.count >= readMoreCount ? 50 : 0.01
        default:
            return  0.01
        }
    }
}

extension ExploreTripDetailViewController{
    func getAdminSuggestion() {
        SHOW_CUSTOM_LOADER()
        let strJson = JSON(["id": "\(cityId)"]).rawString(.utf8, options: .sortedKeys) ?? ""
        let param: [String: Any] = ["requestJson" : strJson]
        API_SERVICES.callAPI(param, path: .getAdminSuggestions, method: .post) {  response in
            //            self?.HIDE_CUSTOM_LOADER()
            if let suggestionObjArray =  response?["responseJson"]?.dictionaryValue["suggestion"]?.arrayValue{
                
                self.arrayExpandable.removeAll()
                var languagesAndCurrenciesIndex = -1
                suggestionObjArray.forEach { suggestion in
                    let data = ExploreSuggestionDataModel(param: suggestion)
                    switch data.cellType {
                    case .languagesAndCurrencies:
                        if languagesAndCurrenciesIndex == -1 {
                            languagesAndCurrenciesIndex = self.arrayExpandable.count
                            self.arrayExpandable.append(data)
                        } else {
                            self.arrayExpandable[languagesAndCurrenciesIndex].mergeLanguagesAndCurrencies(data2: data)
                        }
                    default:
                        self.arrayExpandable.append(data)
                    }
                }
                debugPrint(suggestionObjArray)
                // ExpandableViews
                if !self.arrayExpandable.count.isZero() {
                    self.arrayOfSections.append(.expandableViews)
                }
            }
            
            DispatchQueue.getMain {
                self.tblviewData.reloadData()
            }
            
            self.getGoogleTripsDetial()
        } failure: { str in
        } internetFailure: {
        } failureInform: {
            self.HIDE_CUSTOM_LOADER()
        }
    }
    
    func getGoogleTripsDetial(isNextPage:Bool=false) {
        
        var serviceUrl:URL? = nil
        let key = appDelegateShared.googleKey
        
        if isNextPage{
            let queryItems = [URLQueryItem(name: "pageToken", value: nextPageToken),URLQueryItem(name: "key", value: key),URLQueryItem(name: "query", value: cityName),URLQueryItem(name: "type", value: "tourist_attraction"),URLQueryItem(name: "sensor", value: "false")]
            var urlComps = URLComponents(string: "https://maps.googleapis.com/maps/api/place/textsearch/json")
            urlComps?.queryItems = queryItems
            serviceUrl = urlComps?.url
            
        }else{
            let queryItems = [URLQueryItem(name: "key", value: key), URLQueryItem(name: "query", value: cityName),URLQueryItem(name: "type", value: "tourist_attraction")]
            var urlComps = URLComponents(string: "https://maps.googleapis.com/maps/api/place/textsearch/json")
            urlComps?.queryItems = queryItems
            serviceUrl = urlComps?.url
        }
        
        guard let urlGoogle = serviceUrl else { return }
        
        var request = URLRequest(url: urlGoogle)
        request.httpMethod = "GET"
        request.setValue("Application/json", forHTTPHeaderField: "Content-Type")
        let session = URLSession.shared
        session.dataTask(with: request) { (data, response, error) in
            self.HIDE_CUSTOM_LOADER()
            if let data = data {
                do {
                    let json = try JSONSerialization.jsonObject(with: data, options: [])
                    let jsonObj = JSON.init(json)
                    let placeIdsArray = jsonObj["results"].arrayValue
                    
                    self.nextPageToken = ""
                    if let nextToken = jsonObj["next_page_token"].string, !nextToken.isEmpty{
                        self.nextPageToken = nextToken
                    }
                    
                    CollectionViewTVCell.isGooglelPageApiWorking = false
                    
                    var ids = [String]()
                    self.arrayFeaturedPlaces.forEach { objJson in
                        if let id = objJson.dictionaryValue["place_id"]?.stringValue{
                            ids.append(id)
                        }
                    }
                    
                    if !isNextPage{
                        self.arrayFeaturedPlaces.removeAll()
                        self.arrayFeaturedPlaces = placeIdsArray
                        
                        if !self.arrayFeaturedPlaces.count.isZero() {
                            self.arrayOfSections.append(.featuredPlaces)
                        }
                        
                        DispatchQueue.main.async {
                            self.configureTopTipsArray()
                            self.tblviewData.reloadData()
                        }
                    }else{
                        let arrayCount = self.arrayFeaturedPlaces.count
                        placeIdsArray.forEach { obj in
                            if let id = obj.dictionaryValue["place_id"]?.stringValue, !ids.contains(id){
                                self.arrayFeaturedPlaces.append(obj)
                            }
                        }
                        
                        if arrayCount == self.arrayFeaturedPlaces.count{
                            self.nextPageToken = ""
                        }
                        
                        DispatchQueue.main.async {
                            self.tblviewData.reloadData()
                        }
                    }
                    
                    self.getSavedTopTipListApi()
                } catch {
                    print(error)
                }
            }
        }.resume()
    }
    
    func getSavedGooglePlaceIdListApi(success: (() -> ())? = nil){
        let strJson = JSON(["city":self.cityId]).rawString(.utf8, options: .sortedKeys) ?? ""
        let param: [String: Any] = ["requestJson" : strJson]
        API_SERVICES.callAPI(param, path: .getSavedGoogleList, method: .post) { [weak self] dataResponce in
            guard let status = dataResponce?["status"]?.intValue, status == 200, let arrayOfList = dataResponce?["responseJson"]?.dictionaryValue["googleLocations"]?.arrayValue else {
                self?.getAdminSuggestion()
                return
            }
            ExploreTripDetailViewController.arrayStorePlaceId = arrayOfList.map({$0.dictionaryValue["placeId"]?.stringValue ?? ""})
            success?()
        }  internetFailure: { [weak self] in
            debugPrint("internetFailure")
        } failureInform: { [weak self] in
            self?.getAdminSuggestion()
        }
    }
    
    func getSavedTopTipListApi(isNextPageRequest: Bool = false, isPullToRefresh:Bool = false){
        
        savedAlbumTravelAdviceViewModel.pageSize = 200
        let param = savedAlbumTravelAdviceViewModel.getPageDict(isPullToRefresh)
        let paramDict:[String:Any] = ["INTEREST_CATEGORY":"advice", "pager":param,"city":self.cityId]
        savedAlbumTravelAdviceViewModel.getSavedTravelAdvicesListApi(paramDict: paramDict, success: { [weak self] response in
            self?.preparedSectionAndArrayOfTraveAdvice()
            self?.tblviewData.reloadData()
        })
    }
    
    func preparedSectionAndArrayOfTraveAdvice(){
        
        let toolTips = savedAlbumTravelAdviceViewModel.arrayOfSavedTopTipsList.filter({$0.travelEnumTypeValue == 1})
        //        let favoriteTravelStorys = savedAlbumTravelAdviceViewModel.arrayOfSavedTopTipsList.filter({$0.travelEnumTypeValue == 2})
        //        let logisticsAndRoutes = savedAlbumTravelAdviceViewModel.arrayOfSavedTopTipsList.filter({$0.travelEnumTypeValue == 3})
        self.arrayOfToolTips = toolTips
        
        if !arrayOfToolTips.count.isZero() {
            arrayOfSections.append(.topTips)
        }
        tblviewData.reloadData()
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
