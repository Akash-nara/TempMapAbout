//
//  AddTripSecondStepVC.swift
//  MyMapp
//
//  Created by Chirag Pandya on 11/11/21.
//

import UIKit
import GooglePlaces
import SwiftyJSON

class KeyTripLocationFavouriteList{
    var locationDetail : Keylocation?
    var detailOfFavoruite : AddTripFavouriteLocationDetail?
    var lastRecord : Bool?
    var locationId = 0
    var locationHash = ""
    
}
class KeytripLocationList : NSObject{
    var location : Keylocation?
    var tags : String?
    var notes : String?
    var lastRecord : Bool?
    
    init(location:Keylocation,tags:String,notes:String,lastRecord:Bool) {
        
        self.location = location
        self.tags = tags
        self.notes = notes
        self.lastRecord = lastRecord
    }
    
    func toDictionary() -> [String:Any]{
        var dictionary = [String:Any]()
        if location != nil{
            dictionary["location"] = JSON(location!.toDictionary)
        }
        if tags != nil{
            dictionary["tags"] = tags?.description
        }
        if notes != nil{
            dictionary["notes"] = notes?.description
        }
        
        return dictionary
    }
}

class Keylocation : NSObject{
    var name : String?
    var latitude : Double?
    var longitude : Double?
    
    init(name:String,latitude:Double,longitude:Double) {
        
        self.name = name
        self.latitude = latitude
        self.longitude = longitude
    }
    
    func toDictionary() -> [String:Any]{
        var dictionary = [String:Any]()
        if name != nil{
            dictionary["name"] = name?.description
        }
        if latitude != nil{
            dictionary["latitude"] = latitude?.description
        }
        if longitude != nil{
            dictionary["longitude"] = longitude?.description
        }
        return dictionary
    }
}

enum EnumTripSection:Equatable{
    case topTips(String,String), travelStory(String,String), logisticsRoute(String,String), description,favouriteLocation, travelAdvice
}

var totalGlobalTripPhotoCount = 21
class AddTripSecondStepVC: UIViewController, GMSAutocompleteViewControllerDelegate{
    
    //MARK: - OUTLETS
    @IBOutlet weak var tblviewCity:UITableView!{
        didSet{
            tblviewCity.setDefaultProperties(vc: self)
            tblviewCity.registerCell(type: AddTripCityDescriptionHeaderCell.self, identifier: AddTripCityDescriptionHeaderCell.identifier)
            tblviewCity.registerCell(type: AddTripAddLocationsCell.self, identifier: AddTripAddLocationsCell.identifier)
            tblviewCity.registerCell(type: AddTripTravelAdviceLabelXIB.self, identifier: AddTripTravelAdviceLabelXIB.identifier)
            tblviewCity.registerCell(type: AddTripTopTipCollpaseXIB.self, identifier: AddTripTopTipCollpaseXIB.identifier)
            tblviewCity.registerCell(type: AddTripFavouriteCollpaseXIB.self, identifier: AddTripFavouriteCollpaseXIB.identifier)
            tblviewCity.registerCell(type: AddTripLogisticsCollpaseXIB.self, identifier: AddTripLogisticsCollpaseXIB.identifier)
            tblviewCity.registerCell(type: AddTripTopExpandXIB.self, identifier: AddTripTopExpandXIB.identifier)
            tblviewCity.registerCell(type: AddTripFavouriteExpandXIB.self, identifier: AddTripFavouriteExpandXIB.identifier)
            tblviewCity.registerCell(type: AddTripLogisticsExpandXIB.self, identifier: AddTripLogisticsExpandXIB.identifier)
            tblviewCity.registerCell(type: AddTripLogisticsExpandXIB.self, identifier: AddTripLogisticsExpandXIB.identifier)
        }
    }
    
    @IBOutlet weak var buttonAddToFeed: UIButton!
    @IBOutlet weak var buttonMakePrivate: UIButton!
    @IBOutlet weak var labelSubmitingText: UILabel!
    @IBOutlet weak var viewContainerOfSubmitFeed: UIControl!
    
    @IBOutlet weak var dotLastView: UIView!
    @IBOutlet weak var sepratorLastView: UIView!
    
    //MARK: - VARIABLES
    var isTopTipExpand = Bool()
    var isFavouriteExpand = Bool()
    var isLogisticsExpand = Bool()
    var isTopDataAdded = Bool()
    var isFavouriteDataAdded = Bool()
    var isLogisticDataAdded = Bool()
    
    var height: CGFloat = 217
    var topCornerRadius: CGFloat = 35
    var presentDuration: Double = 1.0
    var dismissDuration: Double = 1.0
    let kHeightMaxValue: CGFloat = 600
    let kTopCornerRadiusMaxValue: CGFloat = 35
    let kPresentDurationMaxValue = 3.0
    let kDismissDurationMaxValue = 3.0
    
    var descriptionTextContent = ""
    var topTipContent = ""
    var favouriteStoryContent = ""
    var logisticContent = ""
    
    var arrayOfTripLocationListData = [KeyTripLocationFavouriteList]()
    
    var selectedAddDetailButtonTag = -1
    var tripBucketHash:String = ""
    
    var addTripModel = AddTripViewModel()
    var isPublicTrip:Bool = true{
        didSet{
            checkTripAddPrivateOrPublicButtonsTap()
        }
    }
    
    var arrayOfSection:[EnumTripSection] = [.description,.favouriteLocation]
    var tripId = 0
    var countryCode = ""
    
    //MARK: - VIEW DID LOAD
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.isTopTipExpand = false
        self.isFavouriteExpand = false
        self.isLogisticsExpand = false
        
        self.isTopDataAdded = false
        self.isFavouriteDataAdded = false
        self.isLogisticDataAdded = false
        
        arrayOfTripLocationListData.removeAll()
        
        let objectLocation = Keylocation.init(name: "", latitude: 0.0, longitude: 0.0)
        let objKeyTripLocationFavouriteList = KeyTripLocationFavouriteList()
        objKeyTripLocationFavouriteList.locationDetail = objectLocation
        self.arrayOfTripLocationListData.append(objKeyTripLocationFavouriteList)
        self.tblviewCity.reloadSections([1], with: .none)
        tblviewCity.contentInset = UIEdgeInsets.init(top: 0, left: 0, bottom: 20, right: 0)
        
        let example = NSAttributedString(string: "By submitting, you are making this trip public and adding it to your feed for other travelers to see!").withLineSpacing(0.5)
        labelSubmitingText.attributedText = example
        
        labelSubmitingText.font = .Montserrat.Medium(16)
        labelSubmitingText.numberOfLines = 0
        labelSubmitingText.textAlignment = .center
        checkTripAddPrivateOrPublicButtonsTap()
        
        let gesture:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(controlPopUpBackgroundTap))
        gesture.numberOfTapsRequired = 1
        viewContainerOfSubmitFeed.isUserInteractionEnabled = true
        viewContainerOfSubmitFeed.addGestureRecognizer(gesture)
        hideAndShowSubmitPopUp(isHidden: true)
        getAdviceForTripAPi()
    }
    
    func checkTripAddPrivateOrPublicButtonsTap(){
        
        if isPublicTrip == true{
            buttonMakePrivate.backgroundColor = UIColor.white
            buttonAddToFeed.backgroundColor = UIColor.App_BG_SeafoamBlue_Color
        }else if isPublicTrip == false{
            buttonMakePrivate.backgroundColor = UIColor.App_BG_SeafoamBlue_Color
            buttonAddToFeed.backgroundColor = UIColor.white
        }
        buttonMakePrivate.setTitleColor(UIColor.App_BG_SecondaryDark2_Color, for: .normal)
        buttonAddToFeed.setTitleColor(UIColor.App_BG_SecondaryDark2_Color, for: .normal)
    }
    
    func hideViewWithAnimation<T: UIView>(shouldHidden: Bool, objView: T) {
        if shouldHidden == true {
            UIView.animate(withDuration: 0.3, animations: {
                objView.alpha = 0
            }) { (finished) in
                objView.isHidden = shouldHidden
            }
        } else {
            objView.alpha = 0
            objView.isHidden = shouldHidden
            UIView.animate(withDuration: 0.3) {
                objView.alpha = 1
            }
        }
    }
}

//MARK: - Web service
extension AddTripSecondStepVC{
    
    func preparedParams() -> [String:Any] {
        var paramMain:[String:Any] = ["id":self.tripId,
                                      "bucketHash":tripBucketHash,
                                      "description":self.descriptionTextContent
        ]
        
        var paramAdvice : [String : Any] = [String : Any]()
        
        if !self.topTipContent.isEmpty{
            paramAdvice["1"] = self.topTipContent
        }
        
        if !self.favouriteStoryContent.isEmpty{
            paramAdvice["2"] = self.favouriteStoryContent
        }
        
        if !self.logisticContent.isEmpty{
            paramAdvice["3"] = self.logisticContent
        }
        
        if paramAdvice.count != 0{
            paramMain["additionalInfo"] = ["advice":paramAdvice]
        }
        
        var tempArrayRemovedFirstObject = arrayOfTripLocationListData
        tempArrayRemovedFirstObject.removeLast()
        var tripLocationList : [[String:Any]] = [[String:Any]]()
        for (_, objModel) in  tempArrayRemovedFirstObject.enumerated() {
            
            var locationDict : [String : Any] = [String : Any]()
            if objModel.locationId != 0{
                locationDict["id"] = objModel.locationId
            }
            
            if let tags = objModel.detailOfFavoruite?.combinedTag, !tags.isEmpty{
                locationDict["tags"] = tags
            }
            
            if let notes = objModel.detailOfFavoruite?.notes, !notes.isEmpty{
                locationDict["notes"] = notes
            }
            if !objModel.locationHash.isEmpty{
                locationDict["hash"] = objModel.locationHash
            }
            
            if let objLocation = objModel.locationDetail{
                locationDict["location"] = ["name" : objLocation.name ?? "-", "latitude" : objLocation.latitude ?? 0.0,"longitude":objLocation.longitude ?? 0.0]
            }
            
            if locationDict.count != 0{
                tripLocationList.append(locationDict)
            }
        }
        
        paramMain["tripLocationList"] = tripLocationList
        return paramMain
    }
    
    /*
    func callUpdateTripApi(){
        
        let param: [String: Any] = ["requestJson" : self.preparedParams().json]
        API_SERVICES.callAPI(param, path: .updateCityTrip, method: .put) { [weak self] response in
            
            URLSession.shared.invalidateAndCancel()
            
            guard let status = response?["status"]?.intValue, status == 200, let msg = response?["msg"]?.stringValue else {
                Utility.errorMessage(message: response?["msg"]?.stringValue ?? "")
                return
            }
            
            self?.hideAndShowSubmitPopUp(isHidden: true)
            Utility.successMessage(message: msg)
            NotificationCenter.default.post(name: Notification.Name("reloadUserTripList"), object: nil)
            self?.navigationController?.popToRootViewController(animated: true)
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3){
//                appDelegateShared.setTabbarRoot()
            }
        }
    }*/
    
    func getAdviceForTripAPi(){
        
        API_SERVICES.callAPI([:], path: .getAdviceForCityTrip, method: .get) { [weak self] response in
            guard let status = response?["status"]?.intValue, status == 200 else {
                Utility.errorMessage(message: response?["msg"]?.stringValue ?? "")
                return
            }
            
            self?.arrayOfSection.removeAll()
            self?.arrayOfSection = [.description, .favouriteLocation]
            
            guard let arrayOfAdvices = response?["responseJson"]?.dictionaryValue["advices"]?.arrayValue  else {
                return
            }
            
            if arrayOfAdvices.count > 0{
                self?.arrayOfSection.append(.travelAdvice)
            }
            
            arrayOfAdvices.forEach { jsonObj in
                let title = jsonObj["value"].stringValue
                let placeHolder = jsonObj["placeHolder"].stringValue
                switch jsonObj["id"].intValue{
                case 1:
                    self?.arrayOfSection.append(.topTips(title, placeHolder))
                case 2:
                    self?.arrayOfSection.append(.travelStory(title, placeHolder))
                case 3:
                    self?.arrayOfSection.append(.logisticsRoute(title, placeHolder))
                default:
                    break
                }
            }
            self?.tblviewCity.reloadData()
        } internetFailure: {
            debugPrint("internetFailure")
        }
    }
    
    
    func generateHashForLocationAddedApi(completion: ((String) -> Void)? = nil){
        let param: [String: Any] = ["requestJson" : ["id":tripId].json]
        API_SERVICES.callAPI(param, path: .generateLocationHash, method: .post) { response in
            guard let status = response?["status"]?.intValue, status == 200, let hashOfLocation = response?["responseJson"]?["hash"].stringValue else { return }
            completion?(hashOfLocation)
        }
    }
    
    func deleteLocationTripApi(index:Int){
        let hashLocation = self.arrayOfTripLocationListData[index].locationHash
        var paramDict:[String:Any] = ["locationHash":hashLocation]
        
        if self.arrayOfTripLocationListData[index].locationId != 0{
            paramDict["id"] = self.arrayOfTripLocationListData[index].locationId
        }
        
        let strJson = JSON(paramDict).rawString(.utf8, options: .sortedKeys) ?? ""
        let param: [String: Any] = ["requestJson" : strJson]
        
        API_SERVICES.callAPI(param, path: .deleteTripLocation, method: .post) { [weak self] dict in
            debugPrint(dict)
            if self?.arrayOfTripLocationListData.count ?? 0 == 1{
                self?.arrayOfTripLocationListData[index].detailOfFavoruite = nil
            }else{
                self?.arrayOfTripLocationListData.remove(at: index)
            }
            self?.tblviewCity.reloadSections([1], with: .none)
        }
    }
}

//MARK: - Autocomplete
extension AddTripSecondStepVC{
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace){
        
        if let _ = place.name{
            
            guard let _ = self.arrayOfTripLocationListData[self.selectedAddDetailButtonTag].detailOfFavoruite else {
                
                self.generateHashForLocationAddedApi { hashStr in
                    let objectLocation = Keylocation.init(name: place.formattedAddress!, latitude: place.coordinate.latitude, longitude: place.coordinate.longitude)
                    let obj = KeyTripLocationFavouriteList()
                    obj.locationDetail = objectLocation
                    obj.lastRecord = false
                    obj.locationHash = hashStr
//                    self.arrayOfTripLocationListData.append(obj)
                    self.arrayOfTripLocationListData.insert(obj, at: 0)
                    self.tblviewCity.reloadSections([1], with: .none)
                    self.dismiss(animated: true, completion: nil)
                }
                return
            }
            
            let objectLocation = Keylocation.init(name: place.formattedAddress!, latitude: place.coordinate.latitude, longitude: place.coordinate.longitude)
            
            self.arrayOfTripLocationListData[self.selectedAddDetailButtonTag].locationDetail = objectLocation
            self.arrayOfTripLocationListData[self.selectedAddDetailButtonTag].lastRecord = false
            
            // added deafult add new location
            let model = KeyTripLocationFavouriteList()
            model.locationDetail = nil
            model.lastRecord = true
            self.arrayOfTripLocationListData.insert(model, at: 0)
            
            self.tblviewCity.reloadSections([1], with: .none)
        }
        dismiss(animated: true, completion: nil)
    }
    
    func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
        // TODO: handle the error.
        print("Error: ", error.localizedDescription)
    }
    
    // User canceled the operation.
    func wasCancelled(_ viewController: GMSAutocompleteViewController) {
        dismiss(animated: true, completion: nil)
        self.selectedAddDetailButtonTag = -1
    }
    
    // Turn the network activity indicator on and off again.
    func didRequestAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
    }
    
    func didUpdateAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
    }
}

//MARK: - Custom Button Action
extension AddTripSecondStepVC{
    @objc func addnewAddress(sender:UIButton){
        let autocompletecontroller = GMSAutocompleteViewController()
        autocompletecontroller.delegate = self
        let filter = GMSAutocompleteFilter()
        filter.country = self.countryCode // here need to country code to pass
        filter.type = .city
        autocompletecontroller.autocompleteFilter = filter
        autocompletecontroller.tintColor = .App_BG_SeafoamBlue_Color
        self.selectedAddDetailButtonTag = sender.tag
        self.present(autocompletecontroller, animated: true, completion: nil)
    }
    
    func countTotalPhoto(){
//        self.arrayOfTripLocationListData.map({$0.detailOfFavoruite?.arrayOfImages.count ?? 0}).forEach { obj in
//            totalGlobalTripPhotoCount = obj
//        }
    }
    
    @objc func addDetailsButtonClicked(sender:UIButton){
        
        guard let name = self.arrayOfTripLocationListData[sender.tag].locationDetail?.name, !name.isEmpty else {
            Utility.errorMessage(message: "Please add location first")
            return
        }
        
        guard let popupVC = UIStoryboard.trip.addTripFavouriteLocationsVC else {
            return
        }
        
        popupVC.height = UIScreen.main.bounds.size.height -  200//700
        popupVC.topCornerRadius = topCornerRadius
        popupVC.presentDuration = 0.5
        popupVC.dismissDuration = 0.5
        popupVC.customNavigationController = navigationController!
        popupVC.tripId = self.tripId
        popupVC.tripBucketHash = self.tripBucketHash
        popupVC.locationBucketHash = self.arrayOfTripLocationListData[sender.tag].locationHash
        popupVC.selectedAddTripFavouriteLocationDetail = self.arrayOfTripLocationListData[sender.tag].detailOfFavoruite
        
        self.countTotalPhoto()
        popupVC.selectedTripDetailCallBackBlock = { [weak self] objModel in
            self?.arrayOfTripLocationListData[sender.tag].detailOfFavoruite = objModel
            self?.countTotalPhoto()
            self?.tblviewCity.reloadSections([1], with: .none)
        }
        DispatchQueue.main.async {
            self.present(popupVC, animated: true, completion: nil)
        }
    }
    
    @objc func removeLocation(sender:UIButton){
        
        deleteLocationTripApi(index: sender.tag)
    }
    
    @objc func isTopTipExpandView(sender:UIButton){
        self.isTopDataAdded = false
        
        if self.isTopTipExpand == false{
            self.isTopTipExpand = true
        }else{
            self.isTopTipExpand = false
            
            if let cell: AddTripTopExpandXIB = self.tblviewCity.cellForRow(at: IndexPath(row: 0, section: sender.tag)) as? AddTripTopExpandXIB{
                if cell.txtviewTopTip.text != ""{
                    self.isTopDataAdded = true
                    self.topTipContent = cell.txtviewTopTip.text
                }else{
                    self.isTopDataAdded = false
                    self.topTipContent = ""
                }
            }
        }
        self.tblviewCity.reloadData()
    }
    
    @objc func isFavouriteExpandView(sender:UIButton){
        
        self.isFavouriteDataAdded = false
        
        if self.isFavouriteExpand == false{
            self.isFavouriteExpand = true
        }else{
            self.isFavouriteExpand = false
            
            if let cell: AddTripFavouriteExpandXIB = self.tblviewCity.cellForRow(at: IndexPath.init(row: 0, section: sender.tag)) as? AddTripFavouriteExpandXIB{
                
                if cell.txtviewFavourite.text != ""{
                    self.isFavouriteDataAdded = true
                    self.favouriteStoryContent = cell.txtviewFavourite.text!
                }else{
                    self.isFavouriteDataAdded = false
                    self.favouriteStoryContent = ""
                }
            }
        }
        self.tblviewCity.reloadData()
    }
    
    @objc func isLogisticsExpandView(sender:UIButton){
        
        self.isLogisticDataAdded = false
        if self.isLogisticsExpand == false{
            self.isLogisticsExpand = true
        }else{
            self.isLogisticsExpand = false
            
            if let cell: AddTripLogisticsExpandXIB = self.tblviewCity.cellForRow(at: IndexPath.init(row: 0, section: sender.tag)) as? AddTripLogisticsExpandXIB{
                
                if cell.txtviewLogistics.text != ""{
                    self.isLogisticDataAdded = true
                    self.logisticContent = cell.txtviewLogistics.text!
                }else{
                    self.isLogisticDataAdded = false
                    self.logisticContent = ""
                }
            }
        }
        self.tblviewCity.reloadData()
    }
}

//MARK: - TABLEVIEW METHODS
extension AddTripSecondStepVC:UITableViewDelegate,UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return arrayOfSection.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch arrayOfSection[section]{
        case .favouriteLocation:
            return self.arrayOfTripLocationListData.count
        default:
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch arrayOfSection[indexPath.section]{
        case .description:
            
            guard let cell = self.tblviewCity.dequeueCell(
                withType: AddTripCityDescriptionHeaderCell.self,
                for: indexPath) as? AddTripCityDescriptionHeaderCell else {
                    return UITableViewCell()
                }
            cell.cityDescriptionHeaderProtoColDelegate = self
            return cell
        case .favouriteLocation:
            
            guard let cell = self.tblviewCity.dequeueCell(
                withType: AddTripAddLocationsCell.self,
                for: indexPath) as? AddTripAddLocationsCell else {
                    return UITableViewCell()
                }
            
            cell.btnTitleAddDetails.addTarget(self, action: #selector(self.addDetailsButtonClicked(sender:)), for: .touchUpInside)
            cell.btnTitleAddDetails.tag = indexPath.row
            
            cell.btnTitleRemove.addTarget(self, action: #selector(self.removeLocation(sender:)), for: .touchUpInside)
            cell.btnTitleRemove.tag = indexPath.row
            
            cell.btnHandlerGooglePicker.addTarget(self, action: #selector(self.addnewAddress(sender: )), for: .touchUpInside)
            cell.btnHandlerGooglePicker.tag = indexPath.row
            
            cell.btnHandlerGooglePicker.titleEdgeInsets.left = 20; // add left padding.
            cell.btnHandlerGooglePicker.titleEdgeInsets.right = 10; // add right padding.
            
            cell.btnTitleAddDetails.setTitle("Add details", for: .normal)
            cell.btnHandlerGooglePicker.layer.borderColor = UIColor.App_BG_Textfield_Unselected_Border_Color.cgColor

            if self.arrayOfTripLocationListData[indexPath.row].lastRecord == true{
                cell.btnTitleAddDetails.isHidden = false
                cell.btnTitleRemove.isHidden = true
                cell.btnHandlerGooglePicker.setTitleColor(UIColor.App_BG_Textfield_Unselected_Border_Color, for: .normal)
                cell.btnHandlerGooglePicker.setTitle("Add new location", for: .normal)
                cell.btnHandlerGooglePicker.setTitleColor(.gray, for: .normal)
            }else{
                
                if self.arrayOfTripLocationListData[indexPath.row].locationDetail?.name == ""{
                    cell.btnHandlerGooglePicker.setTitle("Add location here", for: .normal)
                    cell.btnHandlerGooglePicker.setTitleColor(.lightGray, for: .normal)
                    cell.btnTitleRemove.isHidden = true
                }else{
                    if self.arrayOfTripLocationListData[indexPath.row].detailOfFavoruite != nil{
                        cell.btnTitleAddDetails.setTitle("Edit details", for: .normal)
                    }

                    cell.btnHandlerGooglePicker.layer.borderColor = UIColor.App_BG_SeafoamBlue_Color.cgColor
                    cell.btnTitleRemove.isHidden = false
                    cell.btnHandlerGooglePicker.setTitle(self.arrayOfTripLocationListData[indexPath.row].locationDetail?.name!, for: .normal)
                    cell.btnHandlerGooglePicker.setTitleColor(UIColor.getColorIntoHex(Hex: "382239"), for: .normal)
                }
                cell.btnTitleAddDetails.isHidden = false
            }
            return cell
            
        case .travelAdvice:
            
            guard let cell = self.tblviewCity.dequeueCell(
                withType: AddTripTravelAdviceLabelXIB.self,
                for: indexPath) as? AddTripTravelAdviceLabelXIB else {
                    return UITableViewCell()
                }
            return cell
            
        case .topTips(let title, let placeHolderText):
            if self.isTopTipExpand == false{
                guard let cell = self.tblviewCity.dequeueCell(
                    withType: AddTripTopTipCollpaseXIB.self,
                    for: indexPath) as? AddTripTopTipCollpaseXIB else {
                        return UITableViewCell()
                    }
                cell.selectionStyle = .none
                cell.btnHandlerExpand.accessibilityHint = placeHolderText
                cell.labelTitle.text = title
                
                cell.btnHandlerExpand.addTarget(self, action: #selector(self.isTopTipExpandView(sender: )), for: .touchUpInside)
                cell.btnHandlerExpand.tag = indexPath.section
                
                if self.isTopDataAdded == false{
                    cell.viewBG.layer.borderColor = UIColor.App_BG_Textfield_Unselected_Border_Color.cgColor
                }else{
                    cell.viewBG.layer.borderColor = UIColor.App_BG_SeafoamBlue_Color.cgColor
                }
                return cell
            }else{
                guard let cell = self.tblviewCity.dequeueCell(
                    withType: AddTripTopExpandXIB.self,
                    for: indexPath) as? AddTripTopExpandXIB else {
                        return UITableViewCell()
                    }
                cell.selectionStyle = .none
                cell.txtviewTopTip.placeholder = placeHolderText
                cell.btnTitleExpand.addTarget(self, action: #selector(self.isTopTipExpandView(sender: )), for: .touchUpInside)
                cell.AddTripTopExpandDelegate = self
                cell.btnTitleExpand.tag = indexPath.section
                
                return cell
            }
        case .travelStory(let title, let placeHolderText):
            if self.isFavouriteExpand == false{
                guard let cell = self.tblviewCity.dequeueCell(
                    withType: AddTripFavouriteCollpaseXIB.self,
                    for: indexPath) as? AddTripFavouriteCollpaseXIB else {
                        return UITableViewCell()
                    }
                cell.selectionStyle = .none
                cell.btnTitleExpand.accessibilityHint = placeHolderText
                cell.labelTitle.text = title
                cell.btnTitleExpand.addTarget(self, action: #selector(self.isFavouriteExpandView(sender:)), for: .touchUpInside)
                cell.btnTitleExpand.tag = indexPath.section
                
                if self.isFavouriteDataAdded == false{
                    cell.viewBG.layer.borderColor = UIColor.App_BG_Textfield_Unselected_Border_Color.cgColor
                }else{
                    cell.viewBG.layer.borderColor = UIColor.App_BG_SeafoamBlue_Color.cgColor
                }
                return cell
            }else{
                
                guard let cell = self.tblviewCity.dequeueCell(
                    withType: AddTripFavouriteExpandXIB.self,
                    for: indexPath) as? AddTripFavouriteExpandXIB else {
                        return UITableViewCell()
                    }
                cell.selectionStyle = .none
                cell.txtviewFavourite.placeholder = placeHolderText
                cell.btnTitleExpand.addTarget(self, action: #selector(self.isFavouriteExpandView(sender:)), for: .touchUpInside)
                cell.btnTitleExpand.tag = indexPath.section
                
                cell.AddTripFavouriteExpandDelegate = self
                return cell
            }
        case .logisticsRoute(let title, let placeHolderText):
            
            if self.isLogisticsExpand == false{
                guard let cell = self.tblviewCity.dequeueCell(
                    withType: AddTripLogisticsCollpaseXIB.self,
                    for: indexPath) as? AddTripLogisticsCollpaseXIB else {
                        return UITableViewCell()
                    }
                cell.selectionStyle = .none
                cell.btnTitleExpand.accessibilityHint = placeHolderText
                cell.labelTitle.text = title
                cell.btnTitleExpand.addTarget(self, action: #selector(Self.isLogisticsExpandView(sender:)), for: .touchUpInside)
                cell.btnTitleExpand.tag = indexPath.section
                
                if self.isLogisticDataAdded == false{
                    cell.viewBG.layer.borderColor = UIColor.App_BG_Textfield_Unselected_Border_Color.cgColor
                }else{
                    cell.viewBG.layer.borderColor = UIColor.App_BG_SeafoamBlue_Color.cgColor
                }
                return cell
            }else{
                
                guard let cell = self.tblviewCity.dequeueCell(
                    withType: AddTripLogisticsExpandXIB.self,
                    for: indexPath) as? AddTripLogisticsExpandXIB else {
                        return UITableViewCell()
                    }
                cell.txtviewLogistics.placeholder = placeHolderText
                cell.selectionStyle = .none
                cell.AddTripLogisticsExpandDelegate = self
                cell.btnTitleExpand.addTarget(self, action: #selector(Self.isLogisticsExpandView(sender:)), for: .touchUpInside)
                cell.btnTitleExpand.tag = indexPath.section
                return cell
            }
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {}
}

// AddTripCityDescriptionHeaderProtoCol
extension AddTripSecondStepVC: AddTripCityDescriptionHeaderProtoCol{
    func getDescriptionContentString(textContent StringData: String) {
        debugPrint(StringData)
        self.descriptionTextContent = StringData
    }
}

// AddTripTopExpandProtocol
extension AddTripSecondStepVC: AddTripTopExpandProtocol{
    func getData(DataString: String) {
        debugPrint(DataString)
        self.topTipContent = DataString
    }
}

// AddTripFavouriteExpandProtocol
extension AddTripSecondStepVC:AddTripFavouriteExpandProtocol{
    func getDataFavourite(DataString: String) {
        debugPrint(DataString)
        self.favouriteStoryContent = DataString
    }
}

// AddTripLogisticsExpandProtocol
extension AddTripSecondStepVC:AddTripLogisticsExpandProtocol{
    func getDataLogistics(DataString: String) {
        debugPrint(DataString)
        self.logisticContent = DataString
    }
}

//MARK: - BUTTON ACTIONS
extension AddTripSecondStepVC{
    @IBAction func buttonMakePrivateTapp(sender:UIButton){
        isPublicTrip = false
    }
    
    @IBAction func buttonAddToFeedTap(sender:UIButton){
        isPublicTrip = true
//        callUpdateTripApi()
    }
    
    @IBAction func buttonCancelPopUp(sender:UIButton){
        hideAndShowSubmitPopUp(isHidden: true)
    }
    
    @objc func controlPopUpBackgroundTap(){
        hideAndShowSubmitPopUp(isHidden: true)
    }
    
    func hideAndShowSubmitPopUp(isHidden:Bool){
        hideViewWithAnimation(shouldHidden: isHidden, objView: viewContainerOfSubmitFeed)
        sepratorLastView.backgroundColor = isHidden ? .App_BG_silver_Color : .App_BG_SeafoamBlue_Color
        dotLastView.backgroundColor = isHidden ? UIColor.App_BG_silver_Color : .App_BG_SeafoamBlue_Color
    }
    
    @IBAction func btnHandlerback(sender:UIButton){
        URLSession.shared.invalidateAndCancel()
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnHandlerNext(sender:UIButton){
//        if self.descriptionTextContent == ""{
//            Utility.errorMessage(message: "Please enter description")
//            return
//        }
        
        if self.arrayOfTripLocationListData.count == 1{
            Utility.errorMessage(message: "Please fill the details of the location")
            return
        }
        
        guard let tripImagesUploadVC = UIStoryboard.trip.tripImagesUploadVC else {
            return
        }
        tripImagesUploadVC.arrayOfImageUpload = self.arrayOfTripLocationListData
        tripImagesUploadVC.paramDict = self.preparedParams()
        self.navigationController?.pushViewController(tripImagesUploadVC, animated: true)

//        hideAndShowSubmitPopUp(isHidden: false)
    }
}
