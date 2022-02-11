//
//  PersonalDetailsVC.swift
//  MyMapp
//
//  Created by Chirag Pandya on 31/10/21.
//

import UIKit
import IQKeyboardManagerSwift
import SwiftyJSON
import Alamofire

class PersonalDetailsVC: UIViewController,UITextFieldDelegate,UITextViewDelegate{
    
    //MARK: - OUTLETS
    @IBOutlet weak var viewSuggestionsHeightContraint: NSLayoutConstraint!
    @IBOutlet weak var btnTitleSubmit: UIButton!
    @IBOutlet weak var txtDisplayName:UITextField!
    @IBOutlet weak var txtCity:UITextField!
    @IBOutlet weak var txtPersonalDescription:IQTextView!
    @IBOutlet weak var viewPersonalDescritption: UIView!
    @IBOutlet weak var viewSuggestion: UIView!
    @IBOutlet weak var tblviewSuggestions: UITableView!{
        didSet{
            tblviewSuggestions.setDefaultProperties(vc: self)
            tblviewSuggestions.registerCell(type: CityListCell.self, identifier: CityListCell.identifier)
        }
    }
    
    //MARK: - VARIABLES
    var isUserNameAvalible = Bool()
    var personalViewModel = PersonalDetailsViewModel()
    var cityData = [CityModel]()
    var pageSize = Int()
    var currentPage = Int()
    var sortField = String()
    var sortOrder = String()
    var isPageRefreshing:Bool = false
    
    //MARK: - VIEW DID LOAD
    override func viewDidLoad() {
        super.viewDidLoad()
        
        sortField = "cityName"
        sortOrder = "1"
        pageSize = 50
        currentPage = 1
        
        self.btnTitleSubmit.backgroundColor = UIColor.getColorIntoHex(Hex: "F0F1F2")
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1, execute: {
            self.btnTitleSubmit.removeShadowButton()
        })
        
        cityData.removeAll()
        
        isUserNameAvalible = false
        self.txtCity.delegate = self
        self.txtDisplayName.delegate = self
        self.txtPersonalDescription.delegate = self
        
        self.txtCity.tag = 1
        self.txtDisplayName.tag = 2
        
        self.placeSearch()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.uiSetup()
    }
    
    //MARK: - BUTTON ACTIONS
    @IBAction func btnHandlerSelectCity(_ sender: Any){ }
    
    @IBAction func btnHandlerSubmit(_ sender: Any){
        
        if self.txtDisplayName.text == ""{
            Utility.errorMessage(message: LocalValidation.enterDisplayname)
            return
        }
        
        if self.isUserNameAvalible == false{
            Utility.errorMessage(message: "Please enter valid display name")
            return
        }
        
        if self.txtCity.text?.count != 0{
            
            var cityOfArr = [String]()
            for obj in self.cityData{
                cityOfArr.append(obj.name)
            }
            
            if cityOfArr.contains(self.txtCity.text!){
            }else{
                Utility.errorMessage(message: "City must be select or enter from the list")
                return
            }
        }
        updateProfileApi()
    }
    
    func updateProfileApi(){
        
        SHOW_CUSTOM_LOADER()
        let strJson = JSON(["displayName": self.txtDisplayName.text?.removeWhiteSpace() ?? "",
                            "city": self.txtCity.text ?? "","personalDescription":self.txtPersonalDescription.text!]).rawString(.utf8, options: .sortedKeys) ?? ""
        let param: [String: Any] = ["requestJson" : strJson]
        
        API_SERVICES.callAPI(param, path: .user, method: .patch) { response in
            //            self.HIDE_CUSTOM_LOADER()
            debugPrint(response)
            self.getUserProfile(success: response?["msg"]?.stringValue ?? "")
        } internetFailure: {
            self.HIDE_CUSTOM_LOADER()
            Utility.errorMessage(message: "Internet failure")
        } failureInform: {
            self.HIDE_CUSTOM_LOADER()
        }
    }
    
    //MARK: - OTHER FUNCTIONS
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if self.txtCity.text != ""{
            if(self.tblviewSuggestions.contentOffset.y >= (self.tblviewSuggestions.contentSize.height - self.tblviewSuggestions.bounds.size.height)) {
                if !isPageRefreshing {
                    isPageRefreshing = true
                    self.currentPage = self.currentPage + 1
                    self.pageSize = 50
                    self.getCityName(text: self.txtCity.text!)
                }
            }
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField == txtDisplayName{
            if txtDisplayName.text!.count > 0{
                self.checkUserName()
            }
        }
    }
    
    func getCityName(text:String){
        
        let param1: [String: Any] = ["pager" : [kpageSize: "\(pageSize)",
                                             kcurrentPage:"\(currentPage)","sortField":sortField,"sortOrder":sortOrder,"searchValue":text]]
        
        let strJson = JSON(param1).rawString(.utf8, options: .sortedKeys) ?? ""
        let param: [String: Any] = ["requestJson" : strJson ]
        
        print(param)
        
        self.personalViewModel.getCityListAPI(param: param) { (response) in
            
            print(response)
            guard let cityList = response?["responseJson"]?["cityList"].arrayObject, let totalRecord = response?["responseJson"]?["totalRecord"].intValue else {
                
                self.sortField = "cityName"
                self.sortOrder = "1"
                self.pageSize = 50
                self.currentPage = 1
                self.cityData.removeAll()
                self.viewSuggestion.isHidden = true
                self.viewSuggestionsHeightContraint.constant = 0
                self.cityData.removeAll()
                self.tblviewSuggestions.reloadData()
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
            }
            else{
                self.cityData.removeAll()
            }
            
            if self.cityData.count > 0 {
                self.viewSuggestion.isHidden = false
                
                if self.cityData.count > 4{
                    self.viewSuggestionsHeightContraint.constant = 200
                }else{
                    self.viewSuggestionsHeightContraint.constant = CGFloat(self.cityData.count * 50)
                }
            } else {
                self.viewSuggestion.isHidden = true
                self.sortField = "cityName"
                self.sortOrder = "1"
                self.pageSize = 50
                self.currentPage = 1
                self.cityData.removeAll()
                self.viewSuggestionsHeightContraint.constant = 0
            }
            self.tblviewSuggestions.reloadData()
            self.HIDE_CUSTOM_LOADER()
        } failure: { errorResponse in
            
        }
    }
    
    /*
     var headers: HTTPHeaders  {
     let header : HTTPHeaders = ["Authorization" : "Bearer" +  " " + appDelegateShared.authToken]
     return header
     }
     
     print(headers)
     
     var TempUrl = "http://54.160.11.28:8081/api/private/config/getCityList?criteria="
     
     TempUrl = TempUrl + text
     
     if !TempUrl.isValidURL
     {
     Utility.errorMessage(message: "Please enter valid city name.")
     return
     }
     
     self.cityData.removeAll()
     
     let url = URL.init(string: TempUrl)!
     
     AF.request(url, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: headers).responseJSON { response in
     switch response.result
     {
     case .success(let json):
     let jsonData = json as! Any
     print(jsonData)
     
     var jsonResponse = JSON(jsonData)
     let dataResponce:Dictionary = jsonResponse.dictionaryValue
     
     print(dataResponce)
     
     let errorMessage1 : String = dataResponce["msg"]?.string ?? "Something went wrong."
     let statusCode1 : Int = dataResponce["status"]!.intValue
     
     if statusCode1 == 404
     {
     self.viewSuggestion.isHidden = true
     self.viewSuggestionsHeightContraint.constant = 0
     self.cityData.removeAll()
     self.tblviewSuggestions.reloadData()
     self.HIDE_CUSTOM_LOADER()
     // Utility.errorMessage(message: dataResponce["msg"]!.stringValue)
     return
     }
     else if statusCode1 == 200
     {
     
     
     var AuthToken = ""
     
     if response.response?.headers != nil
     {
     if response.response?.headers["Authorization"] != nil
     {
     AuthToken = (response.response?.headers["Authorization"]) as! String
     
     let newString = AuthToken.replacingOccurrences(of: "Bearer ", with: "", options: .literal, range: nil)
     print(newString)
     
     if appDelegateShared.isKeyPresentInUserDefaults(key: "authToken")
     {
     appDelegateShared.authToken = newString
     UserDefaults.standard.set(appDelegateShared.authToken, forKey: "authToken")
     UserDefaults.standard.synchronize()
     }
     else
     {
     appDelegateShared.authToken = newString
     UserDefaults.standard.set(appDelegateShared.authToken, forKey: "authToken")
     UserDefaults.standard.synchronize()
     }
     }
     
     let Array1 = jsonResponse["responseJson"]["cityList"].arrayObject
     
     print(Array1?.count)
     
     if Array1!.count > 0
     {
     self.cityData.removeAll()
     Array1!.forEach { (singleObj) in
     let sampleModel = CityModel(fromJson: JSON(singleObj))
     self.cityData.append(sampleModel)
     
     }
     }
     else
     {
     self.cityData.removeAll()
     }
     
     if self.cityData.count > 0 {
     self.viewSuggestion.isHidden = false
     
     if self.cityData.count > 4
     {
     self.viewSuggestionsHeightContraint.constant = 200
     }
     else
     {
     self.viewSuggestionsHeightContraint.constant = CGFloat(self.cityData.count * 50)
     }
     
     
     } else {
     self.viewSuggestion.isHidden = true
     
     self.viewSuggestionsHeightContraint.constant = 0
     
     }
     
     self.tblviewSuggestions.reloadData()
     
     }
     
     self.HIDE_CUSTOM_LOADER()
     
     }
     else
     {
     self.viewSuggestion.isHidden = true
     self.viewSuggestionsHeightContraint.constant = 0
     self.cityData.removeAll()
     self.tblviewSuggestions.reloadData()
     self.HIDE_CUSTOM_LOADER()
     Utility.errorMessage(message: dataResponce["msg"]!.stringValue)
     return
     }
     
     
     case .failure(let error):
     print(error.localizedDescription)
     
     self.HIDE_CUSTOM_LOADER()
     Utility.errorMessage(message: error.localizedDescription)
     return
     }
     
     }
     */
    //    }
    
    func uiSetup() {
        
        sortField = "cityName"
        sortOrder = "1"
        pageSize = 50
        currentPage = 1
        self.cityData.removeAll()
        self.viewSuggestion.layer.cornerRadius = 25
        self.viewSuggestion.layer.borderColor = UIColor.App_BG_Textfield_Unselected_Border_Color.cgColor
        self.viewSuggestion.layer.borderWidth = 2.0
        self.viewSuggestionsHeightContraint.constant = 0
        self.viewSuggestion.isHidden = true
        self.viewSuggestion.backgroundColor = UIColor.white
        self.tblviewSuggestions.backgroundColor = UIColor.white
        self.txtDisplayName.layer.borderColor = UIColor.App_BG_Textfield_Unselected_Border_Color.cgColor
        self.txtCity.layer.borderColor = UIColor.App_BG_Textfield_Unselected_Border_Color.cgColor
        self.viewPersonalDescritption.layer.borderColor = UIColor.App_BG_Textfield_Unselected_Border_Color.cgColor
        
        // self.btnTitleSubmit.isUserInteractionEnabled = false
        self.btnTitleSubmit.backgroundColor = UIColor.getColorIntoHex(Hex: "F0F1F2")
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1, execute: {
            self.btnTitleSubmit.removeShadowButton()
        })
        
        self.txtCity.text = ""
        sortField = "cityName"
        sortOrder = "1"
        pageSize = 50
        currentPage = 1
        self.cityData.removeAll()
    }
    
    func placeSearch() {
        self.tblviewSuggestions.layoutIfNeeded()
        self.tblviewSuggestions.layoutSubviews()
        txtCity?.addTarget(self, action: #selector(textFieldDidChange(textField:)),for: .editingChanged)
        txtDisplayName?.addTarget(self, action: #selector(textFieldDidChange(textField:)),for: .editingChanged)
        self.tblviewSuggestions.separatorStyle = .none
        tblviewSuggestions.delegate = self
        tblviewSuggestions.dataSource = self
        
        self.tblviewSuggestions.reloadData()
    }
    
    func textViewDidChange(_ textView: UITextView) {
        if self.viewSuggestion.isHidden == false{
            self.viewSuggestion.isHidden = true
        }
        
        if textView.text.count == 0{
            self.viewPersonalDescritption.layer.borderColor = UIColor.App_BG_Textfield_Unselected_Border_Color.cgColor
        }else{
            self.viewPersonalDescritption.layer.borderColor = UIColor.App_BG_SeafoamBlue_Color.cgColor
        }
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        let newText = (textView.text as NSString).replacingCharacters(in: range, with: text)
        let numberOfChars = newText.count
        return numberOfChars < 250
    }
    
    @objc func textFieldDidChange(textField: UITextField) {
        if textField.tag == 1{
            if textField.text?.count == 0{
                self.txtCity.layer.borderColor = UIColor.App_BG_Textfield_Unselected_Border_Color.cgColor
            }else{
                self.txtCity.layer.borderColor = UIColor.App_BG_SeafoamBlue_Color.cgColor
            }
            
            if textField.text!.count > 1{
                debugPrint(textField.text!)
                
                sortField = "cityName"
                sortOrder = "1"
                pageSize = 50
                currentPage = 1
                self.cityData.removeAll()
                self.getCityName(text: self.txtCity.text!)
                
            }else{
                self.txtCity.rightView = nil
                self.txtCity.rightViewMode = .never
                
                self.viewSuggestion.isHidden = true
                sortField = "cityName"
                sortOrder = "1"
                pageSize = 50
                currentPage = 1
                self.cityData.removeAll()
                self.viewSuggestionsHeightContraint.constant = 0
            }
        }
        
        if textField.tag == 2{
            if self.viewSuggestion.isHidden == false{
                self.viewSuggestion.isHidden = true
            }
            
            if textField.text?.count == 0{
                self.txtDisplayName.layer.borderColor = UIColor.App_BG_Textfield_Unselected_Border_Color.cgColor
                
            }else{
                self.txtDisplayName.layer.borderColor = UIColor.App_BG_SeafoamBlue_Color.cgColor
                
                /*
                 if (textField.text?.count)! >= 5 && (textField.text?.count)! <= 10
                 {
                 
                 if textField.text!.isValidPassword() == false
                 {
                 self.btnTitleSubmit.backgroundColor = getColorIntoHex(Hex: "F0F1F2")
                 DispatchQueue.main.asyncAfter(deadline: .now() + 0.1, execute: {
                 self.btnTitleSubmit.removeShadowButton()
                 })
                 }
                 else
                 {
                 self.btnTitleSubmit.backgroundColor = getColorIntoHex(Hex: "6CD4C4")
                 DispatchQueue.main.asyncAfter(deadline: .now() + 0.1, execute: {
                 self.btnTitleSubmit.dropShadowButton()
                 })
                 }
                 }
                 else
                 {
                 self.btnTitleSubmit.backgroundColor = getColorIntoHex(Hex: "F0F1F2")
                 DispatchQueue.main.asyncAfter(deadline: .now() + 0.1, execute: {
                 self.btnTitleSubmit.removeShadowButton()
                 })
                 }
                 */
            }
        }
    }
    
    //MARK: - WEBSERVICE CALL
    func getUserProfile(success:String){
        
        API_SERVICES.callAPI([:], path: .user, method: .get, encoding: JSONEncoding.default) { response in
            self.HIDE_CUSTOM_LOADER()
            Utility.successMessage(message: success)
            
            guard let status = response?["status"]?.intValue,
                  status == 200, let responseJson = response?["responseJson"] else {
                      return
                  }
            
            // here store user data model
            APP_USER = AppUser.init(loginResponse: responseJson, authToken: API_SERVICES.getAuthorization() ?? TOKEN_STATIC)
            UserManager.saveUser()
            
            guard let locationServicesVC =  UIStoryboard.authentication.locationServicesVC else {
                return
            }
            self.navigationController?.pushViewController(locationServicesVC, animated: true)
        } failureInform: {
            self.HIDE_CUSTOM_LOADER()
        }
    }
    
    @objc func checkUserName(){
        
        SHOW_CUSTOM_LOADER()
        API_SERVICES.callAPI([:], path: .is_display_name_unique(self.txtDisplayName.text!.trimSpace()), method: .get, encoding: JSONEncoding.default) { response in
            
            guard let status = response?["status"]?.intValue,
                  status == 200 else {
                      self.btnTitleSubmit.backgroundColor = UIColor.getColorIntoHex(Hex: "F0F1F2")
                      DispatchQueue.main.asyncAfter(deadline: .now() + 0.1, execute: {
                          self.btnTitleSubmit.removeShadowButton()
                      })
                      self.HIDE_CUSTOM_LOADER()
                      self.isUserNameAvalible = false
                      Utility.errorMessage(message: response?["msg"]?.stringValue ?? "")
                      return
                  }
            
            self.HIDE_CUSTOM_LOADER()
            self.isUserNameAvalible = true
            
            self.btnTitleSubmit.backgroundColor = UIColor.getColorIntoHex(Hex: "6CD4C4")
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1, execute: {
                self.btnTitleSubmit.dropShadowButton()
            })
            
            // here accessToken user data model
            APP_USER?.accessToken = API_SERVICES.getAuthorization() ?? TOKEN_STATIC
            UserManager.saveUser()
            
        }  internetFailure: {
            self.HIDE_CUSTOM_LOADER()
            Utility.errorMessage(message: LocalValidation.checkInternetConnection)
        } failureInform: {
            self.HIDE_CUSTOM_LOADER()
        }
    }
}

//MARK: - TABLEVIEW METHODS

extension PersonalDetailsVC: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cityData.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = self.tblviewSuggestions.dequeueCell(
            withType: CityListCell.self,
            for: indexPath) as? CityListCell else {
                return UITableViewCell()
            }
        
        cell.lblCity.textAlignment = NSTextAlignment.left
        cell.lblCity.text = cityData[indexPath.row].name
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.txtCity.text = cityData[indexPath.row].name
        
        self.viewSuggestion.isHidden = true
        self.viewSuggestionsHeightContraint.constant = 0
        sortField = "cityName"
        sortOrder = "1"
        pageSize = 50
        currentPage = 1
    }
}

extension String {
    var isValidURL: Bool {
        let detector = try! NSDataDetector(types: NSTextCheckingResult.CheckingType.link.rawValue)
        if let match = detector.firstMatch(in: self, options: [], range: NSRange(location: 0, length: self.utf16.count)) {
            // it is a link, if the match covers the whole string
            return match.range.length == self.utf16.count
        } else {
            return false
        }
    }
}
