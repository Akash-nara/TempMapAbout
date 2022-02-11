//
//  ExploreHomeVC.swift
//  MyMapp
//
//  Created by Chirag Pandya on 07/11/21.
//

import UIKit
import Alamofire
import SwiftyJSON

class exploreTableDataCell:UITableViewCell{
    @IBOutlet weak var collectionviewPlace: UICollectionView!
}

class exploreCollectionDataCell:UICollectionViewCell { }

class ExploreHomeVC: UIViewController,UITextFieldDelegate{
    
    //MARK: - OUTLETS
    @IBOutlet weak var tblviewData: UITableView!{
        didSet{
            tblviewData.setDefaultProperties(vc: self)
            tblviewData.registerCell(type: SearchHeaderXIB.self, identifier: SearchHeaderXIB.identifier)
        }
    }
    
    @IBOutlet weak var txtCity:UITextField!
    @IBOutlet weak var viewSuggestions:UIView!
    @IBOutlet weak var viewSuggestionsHeight:NSLayoutConstraint!
    @IBOutlet weak var tblviewSuggestion:UITableView!{
        didSet{
            tblviewSuggestion.setDefaultProperties(vc: self)
            tblviewSuggestion.registerCell(type: CityListCell.self, identifier: CityListCell.identifier)
        }
    }
    
    //MARK: - VARIABLES
    var isSelectedTab = 0
    var collectionviewSearch:UICollectionView?
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
        
        self.txtCity.delegate = self
        self.txtCity.tag = 1
        
        cityData.removeAll()
        
        self.txtCity.placeholder = "Search for places"
        self.isSelectedTab = 0
        
        self.placeSearch()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.uiSetup()
    }
    
    //MARK: - OTHER FUNCTIONS
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
    
    @objc func textFieldDidChange(textField: UITextField) {
        if textField.tag == 1{
            if textField.text?.count == 0{
                self.txtCity.layer.borderColor = UIColor.App_BG_Textfield_Unselected_Border_Color.cgColor
            }else{
                self.txtCity.layer.borderColor = UIColor.App_BG_SeafoamBlue_Color.cgColor
            }
            
            if textField.text!.count > 1 {
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
                self.viewSuggestionsHeight.constant = 0
                sortField = "cityName"
                sortOrder = "1"
                pageSize = 50
                currentPage = 1
                self.cityData.removeAll()
            }
        }
    }
    
    func getCityName(text:String){
        let param1: [String: Any] = ["pager" : [kpageSize: "\(pageSize)",
                                             kcurrentPage:"\(currentPage)","sortField":sortField,"sortOrder":sortOrder,"searchValue":text] ]
        
        let strJson = JSON(param1).rawString(.utf8, options: .sortedKeys) ?? ""
        let param: [String: Any] = ["requestJson" : strJson]
        
        print(param)
        
        self.personalViewModel.getCityListAPI(param: param) { response in
            print(response)
            
            guard let cityList = response?["responseJson"]?["cityList"].arrayObject, let totalRecord = response?["responseJson"]?["totalRecord"].intValue else {
                
                self.viewSuggestions.isHidden = true
                self.viewSuggestionsHeight.constant = 0
                self.cityData.removeAll()
                self.tblviewSuggestion.reloadData()
                self.HIDE_CUSTOM_LOADER()
                self.sortField = "cityName"
                self.sortOrder = "1"
                self.pageSize = 50
                self.currentPage = 1
                self.cityData.removeAll()
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
                self.viewSuggestions.isHidden = false
                
                if self.cityData.count > 4{
                    self.viewSuggestionsHeight.constant = 200
                }else{
                    self.viewSuggestionsHeight.constant = CGFloat(self.cityData.count * 50)
                }
            } else {
                self.viewSuggestions.isHidden = true
                self.viewSuggestionsHeight.constant = 0
                self.sortField = "cityName"
                self.sortOrder = "1"
                self.pageSize = 50
                self.currentPage = 1
                self.cityData.removeAll()
            }
            self.tblviewSuggestion.reloadData()
            self.HIDE_CUSTOM_LOADER()
        } failure: { jsonObject in
            
        }
    }
    
    func uiSetup() {
        
        self.viewSuggestions.layer.cornerRadius = 25
        self.viewSuggestions.layer.borderColor = UIColor.App_BG_Textfield_Unselected_Border_Color.cgColor
        self.viewSuggestions.layer.borderWidth = 2.0
        self.viewSuggestionsHeight.constant = 0
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
}

//MARK: - TABLEVIEW METHODS
extension ExploreHomeVC: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if tableView == self.tblviewSuggestion{
            return cityData.count
        }else{
            return 1
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int{
        if tableView == self.tblviewSuggestion{
            return 1
        }else{
            return 6
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == self.tblviewSuggestion{
            guard let cell = self.tblviewSuggestion.dequeueCell(
                withType: CityListCell.self,
                for: indexPath) as? CityListCell else {
                    return UITableViewCell()
                }
            
            cell.lblCity.textAlignment = NSTextAlignment.left
            cell.lblCity.text = cityData[indexPath.row].name
            return cell
        }else{
            
            if indexPath.section == 0{
                guard let cell = self.tblviewData.dequeueCell(
                    withType: SearchHeaderXIB.self,
                    for: indexPath) as? SearchHeaderXIB else {
                        return UITableViewCell()
                    }
                return cell
            }else if indexPath.section == 1{
                guard let cell = self.tblviewData.dequeueCell(
                    withType: exploreTableDataCell.self,
                    for: indexPath) as? exploreTableDataCell else {
                        return UITableViewCell()
                    }
                
                cell.collectionviewPlace.delegate = self
                cell.collectionviewPlace.dataSource = self
                self.collectionviewSearch = cell.collectionviewPlace
                
                return cell
                
            }else if indexPath.section == 2{
                guard let cell = self.tblviewData.dequeueCell(
                    withType: SearchHeaderXIB.self,
                    for: indexPath) as? SearchHeaderXIB else {
                        return UITableViewCell()
                    }
                return cell
                
            }else if indexPath.section == 3{
                guard let cell = self.tblviewData.dequeueCell(
                    withType: exploreTableDataCell.self,
                    for: indexPath) as? exploreTableDataCell else {
                        return UITableViewCell()
                    }
                
                cell.collectionviewPlace.delegate = self
                cell.collectionviewPlace.dataSource = self
                self.collectionviewSearch = cell.collectionviewPlace
                
                return cell
            }else if indexPath.section == 4{
                guard let cell = self.tblviewData.dequeueCell(
                    withType: SearchHeaderXIB.self,
                    for: indexPath) as? SearchHeaderXIB else {
                        return UITableViewCell()
                    }
                return cell
            }else{
                guard let cell = self.tblviewData.dequeueCell(
                    withType: exploreTableDataCell.self,
                    for: indexPath) as? exploreTableDataCell else {
                        return UITableViewCell()
                    }
                
                cell.collectionviewPlace.delegate = self
                cell.collectionviewPlace.dataSource = self
                self.collectionviewSearch = cell.collectionviewPlace
                return cell
            }
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        
        if tableView == self.tblviewSuggestion{
            self.txtCity.text = cityData[indexPath.row].name
            
            self.viewSuggestions.isHidden = true
            self.viewSuggestionsHeight.constant = 0
            sortField = "cityName"
            sortOrder = "1"
            pageSize = 50
            currentPage = 1
        }
        else{
        }
    }
}

//MARK: - COLLECTIONVIEW METHODS
extension ExploreHomeVC:UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = self.collectionviewSearch?.dequeueReusableCell(withReuseIdentifier: "exploreCollectionDataCell", for: indexPath) as! exploreCollectionDataCell
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 15)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 225, height: 270 )
    }
}
