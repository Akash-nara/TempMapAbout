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
    var categoryId = 0{
        didSet{
            if let index = arrayOfTravelCategory.firstIndex(where: {$0.id == categoryId}){
                currentIndex = index
            }
        }
    }
    
    @IBOutlet weak var collectionViewTabs: UICollectionView!
    
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
    var objSavedDetailVc:SavedAlbumDetailViewController? = nil
    var saveUnSaveStatusUpdateCallback: ((Int) -> ())? = nil
    var arrayOfTravelCategory = [TravelAdviceDataModel]()
    var currentIndex = 0
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
//        arrayOfTravelCategory += arrayOfTravelCategory
        configureCollectionView()
        
        labelTitle.text = cityName
        labelTitle.numberOfLines = 2
        setSampleSegments()
        
        self.preparedSectionAndArrayOfTraveAdvice()
    }
    
    func configureCollectionView(){
        collectionViewTabs.registerCellNib(identifier: TabCVCell.identifier)
        collectionViewTabs.showsHorizontalScrollIndicator = false
        collectionViewTabs.dataSource = self
        collectionViewTabs.delegate = self
        collectionViewTabs.reloadData()
    }
    
    func setSampleSegments() {
        let segmentCn = MaterialSegmentedControl.init()
        segmentCn.preserveIconColor = false
        segmentCn.frame = CGRect.init(x: 20, y: segmentedControl.frame.origin.y, width: segmentedControl.frame.width - 60, height: segmentedControl.frame.height)
        segmentCn.selectorStyle = .line
        segmentCn.foregroundColor = UIColor.App_BG_SecondaryDark2_Color
        segmentCn.selectorColor = UIColor.App_BG_SeafoamBlue_Color
        segmentCn.selectedForegroundColor = UIColor.App_BG_SeafoamBlue_Color
        
        segmentedControl.addSubview(segmentCn)
        
        let titles:[EnumTravelType] =  [.topTips, .stories, .logistics, .topTips, .logistics, .stories]
//        titles.forEach { enmType in
        arrayOfTravelCategory.forEach { enmType in
            segmentCn.appendTextSegment(text: enmType.title, textColor: .gray, font: UIFont.Montserrat.Medium(13), rippleColor: .lightGray)
        }
        segmentCn.moveSegmentOnSelectedIndex = currentIndex
        self.tblviewData.reloadData()
        self.tblviewData.figureOutAndShowNoResults()
        segmentCn.addTarget(self, action: #selector(segmentedControlTap(_:)), for: .valueChanged)
    }

    @objc func segmentedControlTap(_ sender:MaterialSegmentedControl){
        debugPrint(sender.selectedSegmentIndex)
        currentIndex = sender.selectedSegmentIndex
//        self.selectedTab = EnumTravelType.init(rawValue: sender.selectedSegmentIndex) ?? .topTips
        tblviewData.sayNoSection = .noDataFound("No \(self.arrayOfTravelCategory[currentIndex].title.lowercased()) found.")
        tblviewData.reloadData()
        self.tblviewData.figureOutAndShowNoResults()
    }
    
    /*
    func setSampleSegments() {
        let segmentCn = MXSegmentedControl.init()
        segmentCn.frame = CGRect.init(x: 15, y: 0, width: segmentedControl.frame.width - 30, height: segmentedControl.frame.height)
        segmentCn.segmentWidth = (segmentedControl.frame.size.width - 30)/3
        segmentCn.font = UIFont.Montserrat.Medium(14)
        segmentCn.indicatorHeight = 2
        segmentCn.indicatorLeft = 10
        segmentCn.indicatorRight = 20
        segmentCn.selectedTextColor = UIColor.App_BG_SeafoamBlue_Color
        segmentCn.indicatorColor = UIColor.App_BG_SeafoamBlue_Color
        segmentCn.textColor = UIColor.App_BG_SecondaryDark2_Color
        segmentedControl.addSubview(segmentCn)
        
//        let titles:[EnumTravelType] = [.topTips, .stories, .logistics]
        arrayOfTravelCategory.forEach { enmType in
            segmentCn.append(title: enmType.title)
        }
        segmentCn.addTarget(self, action: #selector(segmentedControlTap(_:)), for: .valueChanged)
    }
    
    @objc func segmentedControlTap(_ sender:MXSegmentedControl){
        debugPrint(sender.selectedIndex)
        currentIndex = sender.selectedIndex
//        self.selectedTab = EnumTravelType.init(rawValue: sender.selectedSegmentIndex) ?? .topTips
        tblviewData.sayNoSection = .noDataFound("No \(self.arrayOfTravelCategory[currentIndex].title.lowercased()) found.")
        tblviewData.reloadData()
        self.tblviewData.figureOutAndShowNoResults()
    }*/
    
    
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
        arrayOfTravelCategory[currentIndex].viewModel?.arrayOfSavedTopTipsList.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let objMOdel = (arrayOfTravelCategory[currentIndex].viewModel?.arrayOfSavedTopTipsList ?? [])[indexPath.row]
        
        return configureAdvanceTravelCell(indexPath: indexPath, title: objMOdel.userName, subTitle: objMOdel.savedComment, icon: objMOdel.userProfilePic, isExpadCell: objMOdel.isExpand,isBookmark: objMOdel.isSaved)
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
        cell.buttonBookmark.accessibilityHint = "\(currentIndex)"
        
        cell.lblHeader.text = title
        cell.labelSubTitle.text = subTitle
        cell.bottomConstrainOfMainStackView.constant = isExpadCell ? 20 : 8
        
        cell.labelSubTitle.tag = indexPath.row
        cell.labelSubTitle.accessibilityHint = "\(currentIndex)"

        
        if isExpadCell{
            cell.viewExpand.layer.borderColor = UIColor.App_BG_Textfield_Unselected_Border_Color.cgColor
        }else{
            cell.viewExpand.layer.borderColor = UIColor.App_BG_SeafoamBlue_Color.cgColor
        }
        
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
                self.updateBoolFlagForExpand(index: cell.labelSubTitle.tag, section: Int(cell.labelSubTitle.accessibilityHint ?? "") ?? 0, flag: true)
                
                self.isShowWholeContent = true
                self.tblviewData.reloadData()
            }) {
                self.updateBoolFlagForExpand(index: cell.labelSubTitle.tag, section: Int(cell.labelSubTitle.accessibilityHint ?? "") ?? 0, flag: false)
                self.isShowWholeContent = false
                self.tblviewData.reloadData()
            }
        }
        return cell
    }
    
    func updateBoolFlagForExpand(index:Int,section:Int, flag:Bool){
        
        let sectionIndex = section
        let row = index
        
        let objMOdel = (arrayOfTravelCategory[sectionIndex].viewModel?.arrayOfSavedTopTipsList ?? [])[row].isExpand.toggle()

        /*
        switch self.selectedTab{
        case .topTips:
            self.arrayOfToolTips[index].isExpand = flag
        case .stories:
            self.arrayOfStories[index].isExpand = flag
        case .logistics:
            self.arrayOfLogistics[index].isExpand = flag
        }*/
    }
    
    @objc func buttonBookmarkClicked(sender:UIButton){
        let section = (Int(sender.accessibilityHint ?? "") ?? 0)
        let row = sender.tag

//        self.arrayOfTravelCategory[section].viewModel?.arrayOfSavedTopTipsList[row].id
        var id  = self.arrayOfTravelCategory[section].viewModel?.arrayOfSavedTopTipsList[row].id ?? 0
        /*
        switch self.selectedTab {
        case .topTips:
            id = arrayOfToolTips[sender.tag].id
        case .stories:
            id = arrayOfStories[sender.tag].id
        case .logistics:
            id = arrayOfLogistics[sender.tag].id
        }*/
        
        
        if let objVc = self.objSavedDetailVc{
            // from saved page
            self.unSaveLocationAndTravelApi(id: id, key: "advice") {
                
//                self.arrayOfTravelCategory[section].viewModel?.arrayOfSavedTopTipsList.remove(at: row)

                /*
                switch self.selectedTab {
                case .topTips:
                    self.arrayOfToolTips.remove(at: sender.tag)
                case .stories:
                    self.arrayOfStories.remove(at: sender.tag)
                case .logistics:
                    self.arrayOfLogistics.remove(at: sender.tag)
                }*/
//                self.savedAlbumTravelAdviceViewModel.removedSavedObject(id: id)
//                objVc.savedAlbumTravelAdviceViewModel.removedSavedObject(id: id)
                self.arrayOfTravelCategory[section].viewModel?.removedSavedObject(id: id)
                objVc.arrayAdviceListArrray[section].viewModel?.removedSavedObject(id: id)
                objVc.removedObject(id: id)
                objVc.tblviewData.reloadData()
                objVc.tblviewData.figureOutAndShowNoResults()
                
                self.tblviewData.reloadData()
                self.tblviewData.figureOutAndShowNoResults()
            }
        }else{
            // from city search
            if sender.isSelected{
                // un saved
                self.unSaveLocationAndTravelApi(id: id, key: "advice") {
                    sender.isSelected.toggle()
                    self.arrayOfTravelCategory[section].viewModel?.arrayOfSavedTopTipsList[row].isSaved.toggle()
                    
                    /*
                    switch self.selectedTab {
                    case .topTips:
                        self.arrayOfToolTips[sender.tag].isSaved.toggle()
                    case .stories:
                        self.arrayOfStories[sender.tag].isSaved.toggle()
                    case .logistics:
                        self.arrayOfLogistics[sender.tag].isSaved.toggle()
                    }*/
                    self.arrayOfTravelCategory[section].viewModel?.updateStatusSavedObject(id: id)
//                    self.savedAlbumTravelAdviceViewModel.updateStatusSavedObject(id: id)
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
        
        (arrayOfTravelCategory[section].viewModel?.arrayOfSavedTopTipsList ?? [])[row].isExpand.toggle()
        
/*
        switch self.selectedTab {
        case .topTips:
            arrayOfToolTips[IndexPath.init(row: row, section: section).row].isExpand.toggle()
        case .stories:
            arrayOfStories[IndexPath.init(row: row, section: section).row].isExpand.toggle()
        case .logistics:
            arrayOfLogistics[IndexPath.init(row: row, section: section).row].isExpand.toggle()
        }*/
        self.tblviewData.reloadData()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){}
}
extension  TravelAdviceListViewController{
    // get saved toptips
    func getSavedTopTipListApi(isNextPageRequest: Bool = false, isPullToRefresh:Bool = false){
        guard let viewModel = arrayOfTravelCategory[currentIndex].viewModel else {
            return
        }
        let categoryId = arrayOfTravelCategory[currentIndex].id
        let param = viewModel.getPageDict(isPullToRefresh)
        let paramDict:[String:Any] = ["INTEREST_CATEGORY":"advice", "categoryId": categoryId,"pager":param,"city":self.cityId]
        tblviewData.isAPIstillWorking = true
        viewModel.getSavedTravelAdvicesListApi(paramDict: paramDict, success: { [weak self] response in
            self?.tblviewData.isAPIstillWorking = false
            self?.preparedSectionAndArrayOfTraveAdvice()
        })
    }
    
    func preparedSectionAndArrayOfTraveAdvice(){
//        arrayOfToolTips = savedAlbumTravelAdviceViewModel.arrayOfSavedTopTipsList.filter({$0.travelEnumTypeValue == 1})
//        arrayOfStories = savedAlbumTravelAdviceViewModel.arrayOfSavedTopTipsList.filter({$0.travelEnumTypeValue == 2})
//        arrayOfLogistics = savedAlbumTravelAdviceViewModel.arrayOfSavedTopTipsList.filter({$0.travelEnumTypeValue == 3})
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
            
            guard let viewModel = arrayOfTravelCategory[currentIndex].viewModel else {
                return
            }

            if viewModel.getTotalElements > viewModel.getAvailableElements &&
                !self.tblviewData.isAPIstillWorking {
                self.getSavedTopTipListApi(isNextPageRequest: true, isPullToRefresh: false)
            }
        }
    }
}

struct GradientPoint {
   var location: CGFloat
   var color: UIColor
}

extension UIImageView{
    
    func gradated(gradientPoints: [GradientPoint]) {
        let gradientMaskLayer       = CAGradientLayer()
        gradientMaskLayer.frame     = frame
        gradientMaskLayer.colors    = gradientPoints.map { $0.color.cgColor }
        gradientMaskLayer.locations = gradientPoints.map { $0.location as NSNumber }
//        gradientMaskLayer.startPoint = CGPoint(x: 0.0, y: 1.0)
//        gradientMaskLayer.endPoint = CGPoint(x: 1.0, y: 1.0)

        self.layer.sublayers?.remove(at: 0)
        self.layer.insertSublayer(gradientMaskLayer, at: 0)
    }
    func addGradianColor(){
        let points = [GradientPoint(location: 0, color: .clear), GradientPoint(location: 0, color:UIColor.orange.withAlphaComponent(0.15))]
        self.gradated(gradientPoints: points)
    }
}

//MARK: - TABLEVIEW METHODS
extension TravelAdviceListViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrayOfTravelCategory.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TabCVCell.identifier, for: indexPath) as! TabCVCell
        cell.cellConfig(data: arrayOfTravelCategory[indexPath.row], selected: currentIndex == indexPath.row)
        return cell
    }
}

extension TravelAdviceListViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = arrayOfTravelCategory[indexPath.row].title.sized(UIFont.Montserrat.Medium(13)).width
        return CGSize(width: max(100, width + 2), height: 50)
    }
}

extension TravelAdviceListViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print(arrayOfTravelCategory[indexPath.row].title)
        currentIndex = indexPath.row
        collectionViewTabs.reloadData()
        tblviewData.sayNoSection = .noDataFound("No \(self.arrayOfTravelCategory[currentIndex].title.lowercased()) found.")
        tblviewData.reloadData()
        tblviewData.figureOutAndShowNoResults()
    }
}

