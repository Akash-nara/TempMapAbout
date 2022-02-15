//
//  AddTripInfoVC.swift
//  MyMapp
//
//  Created by Chirag Pandya on 09/11/21.
//

import UIKit
import SwiftyJSON

class AddTripInfoVC: UIViewController,UITextFieldDelegate{
    
    //MARK: - OUTLETS
    @IBOutlet weak var txtDate:PaddingTextField!
    @IBOutlet weak var txtCity: PaddingTextField!
    @IBOutlet weak var tblviewSuggestion: UITableView!{
        didSet{
            tblviewSuggestion.setDefaultProperties(vc: self)
            tblviewSuggestion.registerCell(type: CityListCell.self, identifier: CityListCell.identifier)
        }
    }
    @IBOutlet weak var viewSuggestions: UIView!
    @IBOutlet weak var viewSuggestionHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var stackViewDate: UIStackView!

    //MARK: - VARIABLES
    var customNavigationController:UINavigationController?
    var selectedStartDate = String()
    var selectedEndDate = String()
    
    var personalViewModel = PersonalDetailsViewModel()
    var cityData = [CityModel]()
    var pageSize = Int()
    var currentPage = Int()
    var sortField = String()
    var sortOrder = String()
    var isPageRefreshing:Bool = false
    
    var tripDateStartTimeStamps:Int64 = 0
    var tripDateEndTimeStamps:Int64 = 0
    var selectedCityID = 0
    var countryCode = ""
    
    var objTirpDatModel:TripDataModel? = nil
    var isEditFlow = false
    

    //MARK: - VIEW DID LOAD
    override func viewDidLoad() {
        super.viewDidLoad()
        
        sortField = "cityName"
        sortOrder = "1"
        pageSize = 50
        currentPage = 1
        
        self.txtCity.delegate = self
        self.txtCity.tag = 1
        txtCity.tintColor = .App_BG_SeafoamBlue_Color
        txtDate.tintColor = .App_BG_SeafoamBlue_Color
        
        cityData.removeAll()
        self.placeSearch()
        
        self.getTagData()
        
        self.txtCity.layer.borderColor = UIColor.App_BG_Textfield_Unselected_Border_Color.cgColor
        self.txtDate.layer.borderColor = UIColor.App_BG_Textfield_Unselected_Border_Color.cgColor
        self.stackViewDate.layer.borderColor = UIColor.App_BG_Textfield_Unselected_Border_Color.cgColor
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.uiSetup()
    }
    
    //MARK: - OTHER FUNCTIONS
    func uiSetup() {
        
        self.viewSuggestions.layer.cornerRadius = 25
        self.viewSuggestions.layer.borderColor = UIColor.App_BG_Textfield_Unselected_Border_Color.cgColor
        self.viewSuggestions.layer.borderWidth = 2.0
        self.viewSuggestionHeightConstraint.constant = 0
        self.viewSuggestions.isHidden = true
        self.viewSuggestions.backgroundColor = UIColor.white
        self.tblviewSuggestion.backgroundColor = UIColor.white
        self.txtCity.layer.borderColor = UIColor.App_BG_Textfield_Unselected_Border_Color.cgColor
        self.txtCity.text = ""
        sortField = "cityName"
        sortOrder = "1"
        pageSize = 50
        currentPage = 1
        self.cityData.removeAll()
    }
    
    func placeSearch() {
        self.tblviewSuggestion.layoutIfNeeded()
        self.tblviewSuggestion.layoutSubviews()
        txtCity?.addTarget(self, action: #selector(textFieldDidChange(textField:)),for: .editingChanged)
        self.tblviewSuggestion.separatorStyle = .none
        tblviewSuggestion.delegate = self
        tblviewSuggestion.dataSource = self
        
        self.tblviewSuggestion.reloadData()
    }
    
    func loadEditData(){
        if let objTrip = objTirpDatModel{
            txtCity.text = objTrip.city.cityName
            selectedCityID = objTrip.city.id
            
            self.tripDateStartTimeStamps = objTrip.tripDate
            let startDateStr = getFormatedDate(timeStamp: objTrip.tripDate)
            self.txtDate.text = startDateStr
            self.selectedStartDate = startDateStr ?? ""

            
            self.tripDateEndTimeStamps = objTrip.tripEndDate
            let tripEndDateStr = getFormatedDate(timeStamp: objTrip.tripEndDate)
            self.txtDate.text = tripEndDateStr
            self.selectedEndDate = tripEndDateStr ?? ""

            self.txtDate.text =  selectedStartDate + " - " + selectedEndDate
        }
    }
    
    func getFormatedDate(timeStamp:Int64) -> String?{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/yyyy"
        let std = Date.init(timeIntervalSince1970: TimeInterval(timeStamp))
        return dateFormatter.string(from: std)
    }
}

//MARK: - BUTTON ACTIONS
extension AddTripInfoVC{
    @IBAction func btnHandlerNext(_ sender: Any){
        var paramCity = [String:Any]()
        if self.selectedStartDate == ""{
            Utility.errorMessage(message: LocalValidation.selectStartdate)
            return
        }
        
        if self.txtCity.text!.isEmpty{
            Utility.errorMessage(message: LocalValidation.enterCityname)
            return
        }
        
        if self.txtCity.text?.count != 0{
            var cityOfArray = [String]()
            for obj in self.cityData{
                cityOfArray.append(obj.name)
            }
            
            if cityOfArray.contains(self.txtCity.text!){
                for obj in self.cityData{
                    self.selectedCityID = obj.id
                    paramCity["id"] = obj.id
                    paramCity["cityName"] = obj.name
                    paramCity["country"] = obj.countryCode
                }
            }else{
                Utility.errorMessage(message: "City must be select or enter from the list")
                return
            }
        }
        
        if isEditFlow{
            self.objTirpDatModel = TripDataModel.init(param: JSON.init(paramCity))
        }
        
//        redirectNextScreen()
        addTripApi()
    }
    @IBAction func buttonBackTapped(sender:UIButton){
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func btnHandlerback(sender:UIButton){
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnHandlerSelectDate(_ sender: Any){
        DPPickerManager.shared.showPicker(title: "Select start date", selected: Date(), min: nil, max: Date()) { (date, cancel) in
            if !cancel{
                
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "MM/dd/yyyy"
                let startDateStr = dateFormatter.string(from: date!)
                self.tripDateStartTimeStamps = date?.currentTimeStamp ?? 0
                self.txtDate.text = startDateStr
                self.selectedStartDate = startDateStr
                self.selectedEndDate = ""
                self.tripDateEndTimeStamps = 0
                
                DPPickerManager.shared.showPicker(title: "Select end date", selected: date, min: date, max: Date()) { (date, cancel) in
                    if !cancel{
                        
                        let dateFormatter = DateFormatter()
                        dateFormatter.dateFormat = "MM/dd/yyyy"
                        let endDateStr = dateFormatter.string(from: date!)
                        self.txtDate.text = startDateStr + " - " + endDateStr
                        self.selectedEndDate = endDateStr
                        self.tripDateEndTimeStamps = date?.currentTimeStamp ?? 0
                        
                        if self.txtDate.text!.count == 0{
                            self.txtDate.layer.borderColor = UIColor.App_BG_Textfield_Unselected_Border_Color.cgColor
                            self.stackViewDate.layer.borderColor = UIColor.App_BG_Textfield_Unselected_Border_Color.cgColor

                        }else{
                            self.stackViewDate.layer.borderColor = UIColor.App_BG_SeafoamBlue_Color.cgColor
                            self.txtDate.layer.borderColor = UIColor.App_BG_SeafoamBlue_Color.cgColor
                        }
                    }else{
                        self.selectedEndDate = ""
                        self.tripDateEndTimeStamps = self.tripDateStartTimeStamps
                    }
                }
            }else{
                self.stackViewDate.layer.borderColor = UIColor.App_BG_Textfield_Unselected_Border_Color.cgColor
                self.txtDate.layer.borderColor = UIColor.App_BG_Textfield_Unselected_Border_Color.cgColor
                self.txtDate.text = ""
                self.selectedStartDate = ""
                self.selectedEndDate = ""
                self.tripDateStartTimeStamps = 0
                self.tripDateEndTimeStamps = 0
            }
        }
    }
}

//MARK: - TABLEVIEW METHODS
extension AddTripInfoVC: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cityData.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = self.tblviewSuggestion.dequeueCell(
            withType: CityListCell.self,
            for: indexPath) as? CityListCell else {
                return UITableViewCell()
            }
        
        cell.lblCity.textAlignment = NSTextAlignment.left
        if cityData.indices.contains(indexPath.row){
            cell.lblCity.text = cityData[indexPath.row].name
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.txtCity.text = cityData[indexPath.row].name
        countryCode = cityData[indexPath.row].countryCode
        
        self.viewSuggestions.isHidden = true
        self.viewSuggestionHeightConstraint.constant = 0
        sortField = "cityName"
        sortOrder = "1"
        pageSize = 50
        currentPage = 1
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if self.txtCity.text != ""{
            if(self.tblviewSuggestion.contentOffset.y >= (self.tblviewSuggestion.contentSize.height - self.tblviewSuggestion.bounds.size.height)) {
                if !isPageRefreshing {
                    isPageRefreshing = true
                    self.currentPage = self.currentPage + 1
                    self.pageSize = 50
                    self.getCityName(text: self.txtCity.text!)
                }
            }
        }
    }
}

//MARK: - TABLEVIEW METHODS
extension AddTripInfoVC{
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textFieldDidChange(textField: textField)
    }
    
    @objc func textFieldDidChange(textField: UITextField) {
        
        if textField.tag == 1{
            if textField.text?.count == 0{
                self.txtCity.layer.borderColor = UIColor.App_BG_Textfield_Unselected_Border_Color.cgColor
            }else{
                self.txtCity.layer.borderColor = UIColor.App_BG_SeafoamBlue_Color.cgColor
            }
            
            if textField.text!.count > 1  {
                sortField = "cityName"
                sortOrder = "1"
                pageSize = 50
                currentPage = 1
                self.cityData.removeAll()
                self.getCityName(text: self.txtCity.text!)
                
            }else{
                self.txtCity.rightView = nil
                self.txtCity.rightViewMode = .never
                self.viewSuggestions.isHidden = true
                self.viewSuggestionHeightConstraint.constant = 0
                sortField = "cityName"
                sortOrder = "1"
                pageSize = 50
                currentPage = 1
                self.cityData.removeAll()
            }
        }
    }
}

//MARK: - Web Services
extension AddTripInfoVC{
    func getCityName(text:String){
        let param1: [String: Any] = ["pager" : [kpageSize: "\(pageSize)",
                                             kcurrentPage:"\(currentPage)","sortField":sortField,"sortOrder":sortOrder,"searchValue":text] ]
        
        let strJson = JSON(param1).rawString(.utf8, options: .sortedKeys) ?? ""
        let param: [String: Any] = ["requestJson" : strJson ]
        
        self.personalViewModel.getCityListAPI(param: param) { response in
            
            guard let cityList = response?["responseJson"]?["cityList"].arrayObject, let _ = response?["responseJson"]?["totalRecord"].intValue else{
                
                self.sortField = "cityName"
                self.sortOrder = "1"
                self.pageSize = 50
                self.currentPage = 1
                self.cityData.removeAll()
                self.viewSuggestions.isHidden = true
                self.viewSuggestionHeightConstraint.constant = 0
                self.cityData.removeAll()
                self.tblviewSuggestion.reloadData()
                self.HIDE_CUSTOM_LOADER()
                Utility.errorMessage(message: response?["msg"]?.stringValue ?? "")
                return
            }
            
            if cityList.count >= self.pageSize{
                self.isPageRefreshing = false
            }else{
                self.isPageRefreshing = true
            }
            
            if cityList.count > 0{
                cityList.forEach { (singleObj) in
                    let sampleModel = CityModel(fromJson: JSON(singleObj))
                    self.cityData.append(sampleModel)
                }
            }else{
                self.cityData.removeAll()
            }
            
            if self.cityData.count > 0 {
                self.viewSuggestions.isHidden = false
                
                if self.cityData.count > 4{
                    self.viewSuggestionHeightConstraint.constant = 200
                }else{
                    self.viewSuggestionHeightConstraint.constant = CGFloat(self.cityData.count * 50)
                }
            } else {
                self.viewSuggestions.isHidden = true
                self.sortField = "cityName"
                self.sortOrder = "1"
                self.pageSize = 50
                self.currentPage = 1
                self.cityData.removeAll()
                self.viewSuggestionHeightConstraint.constant = 0
            }
            
            self.tblviewSuggestion.reloadData()
            self.HIDE_CUSTOM_LOADER()
        } failure: { jsonObject in
        }
    }
    
    func getTagData(){
        API_SERVICES.callAPI([:], path: .getTags, method: .get) { [weak self] dataResponce in
            
            self?.HIDE_CUSTOM_LOADER()
            guard let status = dataResponce?["status"]?.intValue, status == 200, let listArray =  dataResponce?["responseJson"]?["tagList"].arrayObject else {
                return
            }
            
            appDelegateShared.tagsData.removeAll()
            listArray.forEach { (singleObj) in
                let sampleModel = TagListModel(fromJson: JSON(singleObj))
                appDelegateShared.tagsData.append(sampleModel)
            }
        }  internetFailure: {
            debugPrint("internetFailure")
        } failureInform: {
            self.HIDE_CUSTOM_LOADER()
        }
    }
    
    func addTripApi(){
//        SHOW_CUSTOM_LOADER()
        var dictParam:[String:Any] =  ["city":selectedCityID, "tripDate":tripDateStartTimeStamps]
        if tripDateStartTimeStamps != tripDateEndTimeStamps{
            dictParam["tripEndDate"] = tripDateEndTimeStamps
        }
        
        let strJson = JSON(dictParam).rawString(.utf8, options: .sortedKeys) ?? ""
        let param: [String: Any] = ["requestJson" : strJson]

        API_SERVICES.callAPI(param, path: .addTrip, method: .post) { [weak self] dataResponce in
            
//            self?.HIDE_CUSTOM_LOADER()
            guard let status = dataResponce?["status"]?.intValue, status == 200, let bucketHash = dataResponce?["responseJson"]?["bucketHash"].stringValue, let id = dataResponce?["responseJson"]?["id"].intValue else {
                return
            }
            
            if self?.objTirpDatModel == nil{
                self?.objTirpDatModel = TripDataModel()
            }
            self?.objTirpDatModel?.city = TripDataModel.TripCity()
            self?.objTirpDatModel?.city.countryName = self?.countryCode ?? ""
            self?.objTirpDatModel?.id = id
            self?.objTirpDatModel?.bucketHash = bucketHash
            self?.redirectNextScreen(bucketHash: bucketHash , tripId: id)
            
        } internetFailure: {
            debugPrint("internetFailure")
        } failureInform: {
            self.HIDE_CUSTOM_LOADER()
        }
    }
    
    func redirectNextScreen(bucketHash:String, tripId:Int){
        guard let addTripSecondStepVC = UIStoryboard.trip.addTripSecondStepVC else {
            return
        }
        
        totalGlobalTripPhotoCount = (objTirpDatModel?.photoCount == 0 ? 21 : objTirpDatModel?.photoCount ?? 0)
//        addTripSecondStepVC.countryCode = self.countryCode
//        addTripSecondStepVC.tripId = tripId
//        addTripSecondStepVC.tripBucketHash = bucketHash
        addTripSecondStepVC.objTirpDatModel = objTirpDatModel
        self.navigationController?.pushViewController(addTripSecondStepVC, animated: true)
    }
}

extension Dictionary {
    var json: String {
        let invalidJson = "Not a valid JSON"
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: self, options: .prettyPrinted)
            return String(bytes: jsonData, encoding: String.Encoding.utf8) ?? invalidJson
        } catch {
            return invalidJson
        }
    }
    
    func printJson() {
        print(json)
    }
}

extension Date {
     var currentTimeStamp: Int64{
        return Int64(self.timeIntervalSince1970)
    }
}
