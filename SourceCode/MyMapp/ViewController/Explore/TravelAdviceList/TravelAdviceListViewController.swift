//
//  TravelAdviceListViewController.swift
//  MyMapp
//
//  Created by Akash on 11/03/22.
//

import UIKit
//import MaterialDesignWidgets

class TravelAdviceListViewController: UIViewController {
    
    //MARK: - OUTLETS
    enum EnumTravelType:Int {
        case topTips = 0,stories, logistics
        
        var title:String{
            switch self {
            case .topTips:
                return "Top Tips"
                
            case .stories:
                return "Stories"
                
            case .logistics:
                return "Logistics"
                
            }
        }
    }
    var cityId = 0
    var cityName = "Spain"
    @IBOutlet weak var segmentedControl: UIView!
    
    /// Segmented Control
    @IBOutlet weak var labelTitle: UILabel!
    @IBOutlet weak var tblviewData: SayNoForDataTableView!{
        didSet{
            tblviewData.setDefaultProperties(vc: self)
            tblviewData.registerCell(type: ExploreTripTopCellXIB.self, identifier: ExploreTripTopCellXIB.identifier)
            tblviewData.sayNoSection = .noDataFound("No Top tips found")
            tblviewData.contentInset = UIEdgeInsets.init(top: 0, left: 0, bottom: 30, right: 0)
        }
    }
    
    var isShowWholeContent = false
    var arrayOfToolTips = [TravelAdviceDataModel]()
    var arrayOfStories = [TravelAdviceDataModel]()
    var arrayOfLogistics = [TravelAdviceDataModel]()
    
    var selectedTab:EnumTravelType = .topTips
    var savedAlbumTravelAdviceViewModel:SavedAlbumTravelAdviceViewModel!
    var objSavedDetailVc:SavedAlbumDetailViewController? = nil
    var saveUnSaveStatusUpdateCallback: ((Int) -> ())? = nil

    override func viewDidLoad() {
        super.viewDidLoad()
        
        labelTitle.text = cityName
        labelTitle.numberOfLines = 2
        
        arrayOfToolTips.append(TravelAdviceDataModel.init())
        arrayOfToolTips.append(TravelAdviceDataModel.init())
        arrayOfToolTips.append(TravelAdviceDataModel.init())
        
        arrayOfStories.append(TravelAdviceDataModel.init())
        arrayOfStories.append(TravelAdviceDataModel.init())
        arrayOfStories.append(TravelAdviceDataModel.init())
        
        arrayOfLogistics.append(TravelAdviceDataModel.init())
        arrayOfLogistics.append(TravelAdviceDataModel.init())
        arrayOfLogistics.append(TravelAdviceDataModel.init())
        
        setSampleSegments()
        
        self.preparedSectionAndArrayOfTraveAdvice()
    }
    
    @objc func segmentedControlTap(_ sender:MaterialSegmentedControl){
        debugPrint(sender.selectedSegmentIndex)
        self.selectedTab = EnumTravelType.init(rawValue: sender.selectedSegmentIndex) ?? .topTips
        tblviewData.sayNoSection = .noDataFound("No \(self.selectedTab.title.lowercased()) found.")
        tblviewData.reloadData()
        self.tblviewData.figureOutAndShowNoResults()
    }
    
    func setSampleSegments() {
        let segmentCn = MaterialSegmentedControl.init()
        segmentCn.preserveIconColor = false
        segmentCn.frame = CGRect.init(x: 20, y: segmentedControl.frame.origin.y, width: segmentedControl.frame.width - 60, height: segmentedControl.frame.height)
        //        segmentCn.frame = segmentedControl.frame
        //        segmentCn.backgroundColor = .red
        segmentCn.selectorStyle = .line
        segmentCn.foregroundColor = UIColor.App_BG_SecondaryDark2_Color
        segmentCn.selectorColor = UIColor.App_BG_SeafoamBlue_Color
        segmentCn.selectedForegroundColor = UIColor.App_BG_SeafoamBlue_Color
        segmentedControl.addSubview(segmentCn)
        
        let titles:[EnumTravelType] = [.topTips, .stories, .logistics]
        titles.forEach { enmType in
            segmentCn.appendTextSegment(text: enmType.title, textColor: .gray, font: UIFont.Montserrat.Medium(13), rippleColor: .lightGray)
        }
        segmentCn.addTarget(self, action: #selector(segmentedControlTap(_:)), for: .valueChanged)
    }
    
    @IBAction func buttonBackTapp(_ sender:UIButton){
        self.navigationController?.popViewController(animated: true)
    }
}

//MARK: - TABLEVIEW METHODS
extension TravelAdviceListViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int{
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch selectedTab {
        case .topTips:
            return arrayOfToolTips.count
        case .stories:
            return arrayOfStories.count
        case .logistics:
            return arrayOfLogistics.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch self.selectedTab{
        case .topTips:
            
            return configureAdvanceTravelCell(indexPath: indexPath, title: arrayOfToolTips[indexPath.row].userName, subTitle: arrayOfToolTips[indexPath.row].savedComment, icon: arrayOfToolTips[indexPath.row].userProfilePic, isExpadCell: arrayOfToolTips[indexPath.row].isExpand,isBookmark: arrayOfToolTips[indexPath.row].isSaved)
        case .stories:
            
            return configureAdvanceTravelCell(indexPath: indexPath, title: arrayOfStories[indexPath.row].userName, subTitle: arrayOfStories[indexPath.row].savedComment, icon: arrayOfStories[indexPath.row].userProfilePic, isExpadCell: arrayOfStories[indexPath.row].isExpand,isBookmark: arrayOfStories[indexPath.row].isSaved)
            
        case .logistics:
            return configureAdvanceTravelCell(indexPath: indexPath, title: arrayOfLogistics[indexPath.row].userName, subTitle: arrayOfLogistics[indexPath.row].savedComment, icon: arrayOfLogistics[indexPath.row].userProfilePic, isExpadCell: arrayOfLogistics[indexPath.row].isExpand,isBookmark: arrayOfLogistics[indexPath.row].isSaved)
        }
    }
    
    func configureAdvanceTravelCell(indexPath:IndexPath, title:String, subTitle:String, icon:String,isExpadCell:Bool, isBookmark:Bool) -> ExploreTripTopCellXIB{
        let cell = self.tblviewData.dequeueReusableCell(withIdentifier: "ExploreTripTopCellXIB", for: indexPath) as! ExploreTripTopCellXIB
        cell.userIcon.setImage(url: icon, placeholder: UIImage.init(named: "not_icon"))
        cell.userIcon.setBorderWithColor()
        cell.trealingViewExpand.constant = 50
        
        cell.buttonBookmark.isSelected = isBookmark
        cell.buttonBookmark.setImage(UIImage(named: "ic_selected_saved"), for: .selected)
        cell.buttonBookmark.setImage(UIImage(named: "ic_saved_Selected_With_just_border"), for: .normal)
        cell.buttonBookmark.addTarget(self, action: #selector(buttonBookmarkClicked(sender:)), for: .touchUpInside)
        cell.buttonBookmark.tag = indexPath.row
        cell.buttonBookmark.accessibilityHint = "\(indexPath.section)"
        
        cell.lblHeader.text = title
        cell.labelSubTitle.text = subTitle
        cell.bottomConstrainOfMainStackView.constant = isExpadCell ? 20 : 8
        
        cell.labelSubTitle.tag = indexPath.row
        let str = subTitle
        if str.isEmpty {
            cell.labelSubTitle.isHidden = true
        } else {
            cell.labelSubTitle.isHidden = false
            cell.labelSubTitle.isShowWholeContent = isExpadCell//self.arrayOfToolTips[cell.labelSubTitle.tag]
            cell.labelSubTitle.readLessText = " " + "see less"
            cell.labelSubTitle.readMoreText = " " + "see more"
            cell.labelSubTitle.isOneLinedContent = true
            cell.labelSubTitle.setContent(str, noOfCharacters: 120, readMoreTapped: {
                self.updateBoolFlagForExpand(index: cell.labelSubTitle.tag, flag: true)
                
                self.isShowWholeContent = true
                self.tblviewData.reloadData()
            }) {
                self.updateBoolFlagForExpand(index: cell.labelSubTitle.tag, flag: false)
                self.isShowWholeContent = false
                self.tblviewData.reloadData()
            }
        }
        return cell
    }
    
    func updateBoolFlagForExpand(index:Int,flag:Bool){
        switch self.selectedTab{
        case .topTips:
            self.arrayOfToolTips[index].isExpand = flag
        case .stories:
            self.arrayOfStories[index].isExpand = flag
        case .logistics:
            self.arrayOfLogistics[index].isExpand = flag
        }
    }
    
    @objc func buttonBookmarkClicked(sender:UIButton){
        
        var id  = 0
        switch self.selectedTab {
        case .topTips:
            id = arrayOfToolTips[sender.tag].savedId
        case .stories:
            id = arrayOfStories[sender.tag].savedId
        case .logistics:
            id = arrayOfLogistics[sender.tag].savedId
        }
        
        
        if let objVc = self.objSavedDetailVc{
            // from saved page
            self.unSaveLocationAndTravelApi(id: id, key: "advice") {
                
                switch self.selectedTab {
                case .topTips:
                    self.arrayOfToolTips.remove(at: sender.tag)
                case .stories:
                    self.arrayOfStories.remove(at: sender.tag)
                case .logistics:
                    self.arrayOfLogistics.remove(at: sender.tag)
                }
                
                self.savedAlbumTravelAdviceViewModel.removedSavedObject(id: id)
                objVc.savedAlbumTravelAdviceViewModel.removedSavedObject(id: id)
                objVc.removedObject(id: id)
                objVc.tblviewData.reloadData()
                objVc.tblviewData.figureOutAndShowNoResults()
            }
            self.tblviewData.reloadData()
            self.tblviewData.figureOutAndShowNoResults()
        }else{
            // from city search
            if sender.isSelected{
                // un saved
                self.unSaveLocationAndTravelApi(id: id, key: "advice") {
                    sender.isSelected.toggle()
                    switch self.selectedTab {
                    case .topTips:
                        self.arrayOfToolTips[sender.tag].isSaved.toggle()
                    case .stories:
                        self.arrayOfStories[sender.tag].isSaved.toggle()
                    case .logistics:
                        self.arrayOfLogistics[sender.tag].isSaved.toggle()
                    }
                    self.savedAlbumTravelAdviceViewModel.updateStatusSavedObject(id: id)
                    self.saveUnSaveStatusUpdateCallback?(id)
                    self.tblviewData.reloadData()
                    self.tblviewData.figureOutAndShowNoResults()
                }
            }else{
                
                // save again
                saveTravelAdviceApi(id: id) {
                    
                }
            }
            
        }
    }
    
    //MARK: - OTHER FUNCTIONS
    @objc func isExpandTravelAdvice(_ sender:UITapGestureRecognizer){
        let section = (Int(sender.accessibilityHint ?? "") ?? 0)
        let row = (Int(sender.accessibilityLabel ?? "") ?? 0)
        
        switch self.selectedTab {
        case .topTips:
            arrayOfToolTips[IndexPath.init(row: row, section: section).row].isExpand.toggle()
        case .stories:
            arrayOfStories[IndexPath.init(row: row, section: section).row].isExpand.toggle()
        case .logistics:
            arrayOfLogistics[IndexPath.init(row: row, section: section).row].isExpand.toggle()
        }
        self.tblviewData.reloadData()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){}
}
extension  TravelAdviceListViewController{
    // get saved toptips
    func getSavedTopTipListApi(isNextPageRequest: Bool = false, isPullToRefresh:Bool = false){
        
        let param = savedAlbumTravelAdviceViewModel.getPageDict(isPullToRefresh)
        let paramDict:[String:Any] = ["INTEREST_CATEGORY":"advice", "pager":param,"city":self.cityId]
        savedAlbumTravelAdviceViewModel.getSavedTravelAdvicesListApi(paramDict: paramDict, success: { [weak self] response in
            self?.preparedSectionAndArrayOfTraveAdvice()
        })
    }
    
    func preparedSectionAndArrayOfTraveAdvice(){
        arrayOfToolTips = savedAlbumTravelAdviceViewModel.arrayOfSavedTopTipsList.filter({$0.travelEnumTypeValue == 1})
        arrayOfStories = savedAlbumTravelAdviceViewModel.arrayOfSavedTopTipsList.filter({$0.travelEnumTypeValue == 2})
        arrayOfLogistics = savedAlbumTravelAdviceViewModel.arrayOfSavedTopTipsList.filter({$0.travelEnumTypeValue == 3})
        self.tblviewData.reloadData()
        self.tblviewData.figureOutAndShowNoResults()
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

    
//    func saveTravelAdviceApi(id:Int, success: (() -> ())? = nil){
//        guard let userId = detailTripDataModel?.userCreatedTrip?.userId else {
//            return
//        }
//
//        let strJson = JSON(["advice": ["id":id],
//                            "userId":userId,
//                            "INTEREST_CATEGORY": "advice"]).rawString(.utf8, options: .sortedKeys) ?? ""
//        let param: [String: Any] = ["requestJson" : strJson]
//
//        API_SERVICES.callAPI(param, path: .saveTrip, method: .post) { [weak self] dataResponce in
//            self?.HIDE_CUSTOM_LOADER()
//            guard let status = dataResponce?["status"]?.intValue, status == 200 else {
//                return
//            }
//            NotificationCenter.default.post(name: NSNotification.Name.init(rawValue: "reloadSavedTripList"), object: nil)
//            success?()
//        }  internetFailure: {
//            API_LOADER.HIDE_CUSTOM_LOADER()
//            debugPrint("internetFailure")
//        } failureInform: {
//            self.HIDE_CUSTOM_LOADER()
//        }
//    }
}
// MARK: - UIScrollViewDelegate
extension TravelAdviceListViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        let height = scrollView.frame.size.height
        let contentYoffset = scrollView.contentOffset.y
        let distanceFromBottom = scrollView.contentSize.height - contentYoffset
        if distanceFromBottom < height {
            // pagination
            
            if savedAlbumTravelAdviceViewModel.getTotalElements > savedAlbumTravelAdviceViewModel.getAvailableElements &&
                !self.tblviewData.isAPIstillWorking {
                self.getSavedTopTipListApi(isNextPageRequest: true, isPullToRefresh: false)
            }
        }
    }
}
