//
//  ExploreTripDetailViewController.swift
//  MyMapp
//
//  Created by Akash on 09/03/22.
//

import UIKit
import SwiftyJSON

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
    
    var arrayOfToolTips = [Bool]()
    var arrayOfSections:[EnumTripType] = []
    var arrayFeaturedPlaces = [JSON]()
    var arrayExpandable = [(cellType: Int, isOpenCell: Bool)]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        labelTitle.text = cityName
        labelTitle.numberOfLines = 2
        labelToSaved.isHidden = true
        getAdminSuggestion()
        
        // Maps
        arrayOfSections.append(.maps)
        
        // ExpandableViews
        arrayExpandable = [(1, false), (2, false)]
        if !arrayExpandable.count.isZero() {
            arrayOfSections.append(.expandableViews)
        }
        
        
        // FeaturedPlaces
//        arrayFeaturedPlaces = ["abc", "def", "def", "def", "def", "def", "def", "def"]
//        if !arrayFeaturedPlaces.count.isZero() {
//            arrayOfSections.append(.featuredPlaces)
//        }
        
        // ToolTips
        arrayOfToolTips.append(false)
        arrayOfToolTips.append(false)
        arrayOfToolTips.append(false)
        if !arrayOfToolTips.count.isZero() {
            arrayOfSections.append(.topTips)
        }
        
//                getGoogleTripsDetial()
//        testGppgle()
        
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
            return arrayOfToolTips.count > 4 ? 3 : arrayOfToolTips.count
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
            return cell
        case .expandableViews:
            let cell = tblviewData.dequeueCell(withType: ExpandableTVCell.self, for: indexPath) as! ExpandableTVCell
            cell.cellConfigExpandable(isOpen: arrayExpandable[indexPath.row].isOpenCell)
            cell.cellConfig(data: arrayExpandable[indexPath.row].cellType)
            cell.buttonExpandToggle.tag = indexPath.row
            cell.buttonExpandToggle.addTarget(self, action: #selector(self.cellButtonExpandToggleClicked(_:)), for: .touchUpInside)
            cell.buttonHere.tag = indexPath.row
            cell.buttonHere.addTarget(self, action: #selector(self.cellButtonHereClicked(_:)), for: .touchUpInside)
            return cell
        case .featuredPlaces:
            let cell = tblviewData.dequeueCell(withType: CollectionViewTVCell.self, for: indexPath) as! CollectionViewTVCell
            cell.cellConfigFeaturedPlacesCell(data: arrayFeaturedPlaces)
            return cell
        case .topTips:
            return configureAdvanceTravelCell(indexPath: indexPath, title: "Xi Yang", subTitle: "I would suggest to book all public transport tickets beforehand because I would suggest to book all public transport tickets beforehand because I would suggest to book all public transport tickets beforehand because", icon: "ic_Default_city_image_one", isExpadCell: arrayOfToolTips[indexPath.row])
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
        cell.userIcon.image = UIImage.init(named: icon)
        cell.trealingViewExpand.constant = 50
        
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
            cell.labelSubTitle.isShowWholeContent = self.arrayOfToolTips[cell.labelSubTitle.tag]
            cell.labelSubTitle.readLessText = " " + "see less"
            cell.labelSubTitle.readMoreText = " " + "see more"
            cell.labelSubTitle.isOneLinedContent = true
            cell.labelSubTitle.setContent(str, noOfCharacters: 35, readMoreTapped: {
                self.arrayOfToolTips[cell.labelSubTitle.tag] = true
//                self.isShowWholeContent = true
                self.tblviewData.reloadData()
            }) {
                self.arrayOfToolTips[cell.labelSubTitle.tag] = false
//                self.isShowWholeContent = false
                self.tblviewData.reloadData()
            }
        }
        return cell
    }
    
    @objc func buttonBookmarkClicked(sender:UIButton){
        sender.isSelected.toggle()
        //        arrayOfToolTips[sender.tag].toggle()
        //        tblviewData.reloadData()
    }
    
    //MARK: - OTHER FUNCTIONS
    @objc func isExpandTravelAdvice(_ sender:UITapGestureRecognizer){
        let section = (Int(sender.accessibilityHint ?? "") ?? 0)
        let row = (Int(sender.accessibilityLabel ?? "") ?? 0)
        arrayOfToolTips[IndexPath.init(row: row, section: section).row].toggle()
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
//            doneButton.setTitleColor(.darkGray, for: .normal)
            doneButton.setAttributedTitle(attributeString, for: .normal)
            doneButton.layer.cornerRadius = 10.0
//            doneButton.shadow = true
            doneButton.addTarget(self, action: #selector(buttonReadMoreClikced), for: .touchUpInside)
            footerView.addSubview(doneButton)

            return footerView

        default:
            return  nil
        }
    }
    
    @objc func buttonReadMoreClikced(){
        
        guard let vc = UIStoryboard.tabbar.travelAdviceListVC else {
            return
        }
        vc.cityName = self.cityName
        vc.cityId = cityId
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        guard arrayOfToolTips.count != 0 else {
            return 0.01
        }
        switch arrayOfSections[section] {
        case .topTips:
            return 50
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
        API_SERVICES.callAPI(param, path: .getAdminSuggestions, method: .post) { response in
            debugPrint(response)
            self.getGoogleTripsDetial()
        } failure: { str in
        } internetFailure: {
        } failureInform: {
        }
    }
    
    func getGoogleTripsDetial() {
        
        let key = appDelegateShared.googleKey
        let queryItems = [URLQueryItem(name: "key", value: key), URLQueryItem(name: "query", value: cityName),URLQueryItem(name: "type", value: "tourist_attraction")]
        var urlComps = URLComponents(string: "https://maps.googleapis.com/maps/api/place/textsearch/json")
        urlComps?.queryItems = queryItems
        guard let serviceUrl = urlComps?.url else { return }
        
        var request = URLRequest(url: serviceUrl)
        request.httpMethod = "GET"
        request.setValue("Application/json", forHTTPHeaderField: "Content-Type")
        let session = URLSession.shared
        session.dataTask(with: request) { (data, response, error) in
            self.HIDE_CUSTOM_LOADER()
            if let response = response {
                print(response)
            }
            
            if let data = data {
                do {
                    let json = try JSONSerialization.jsonObject(with: data, options: [])
                    let jsonObj = JSON.init(json)
//                    let placeIdsArray = jsonObj["results"].arrayValue.map({$0.dictionaryValue["place_id"]?.stringValue})
                    //                    self.getGoogleTrips(placeId: ((placeIdsArray.first ?? "") ?? ""))

                    let placeIdsArray = jsonObj["results"].arrayValue
                    print(json)
                    
                    self.arrayFeaturedPlaces.removeAll()
                    self.arrayFeaturedPlaces = placeIdsArray ?? []
                    if !self.arrayFeaturedPlaces.count.isZero() {
                        self.arrayOfSections.insert(.featuredPlaces, at: 1)
                    }
                    
                    DispatchQueue.main.async {
                        self.tblviewData.reloadData()
                    }
                } catch {
                    print(error)
                }
            }
        }.resume()
    }
    
    func getGoogleTrips(placeId:String) {
        
        let key = appDelegateShared.googleKey
        let queryItems = [URLQueryItem(name: "place_id", value: placeId), URLQueryItem(name: "key", value: key)]
        var urlComps = URLComponents(string: "https://maps.googleapis.com/maps/api/place/details/json")
        urlComps?.queryItems = queryItems
        guard let serviceUrl = urlComps?.url else { return }
        
        var request = URLRequest(url: serviceUrl)
        request.httpMethod = "GET"
        request.setValue("Application/json", forHTTPHeaderField: "Content-Type")
        let session = URLSession.shared
        session.dataTask(with: request) { (data, response, error) in
            self.HIDE_CUSTOM_LOADER()
            if let response = response {
                print(response)
            }
            if let data = data {
                do {
                    let json = try JSONSerialization.jsonObject(with: data, options: [])
                    let jsonObj = JSON.init(json)
                    print(json)
                    if let placeIdsArray = jsonObj["result"].dictionaryValue["photos"]?.arrayValue{
                        self.arrayFeaturedPlaces.removeAll()
                        self.arrayFeaturedPlaces = placeIdsArray
                        if !self.arrayFeaturedPlaces.count.isZero() {
                            self.arrayOfSections.append(.featuredPlaces)
                        }
                        self.tblviewData.reloadData()
                    }
                } catch {
                    print(error)
                }
            }
        }.resume()
    }
    
    
    func testGppgle() {
        //    "message" : "Parameter 'format' must be one of: xml, json, jsonv2, geojson, geocodejson"

//    https://nominatim.openstreetmap.org/search.php?q=Warsaw+Poland&polygon_geojson=1&format=json
        let key = appDelegateShared.googleKey
        let queryItems = [URLQueryItem(name: "polygon_geojson", value: "1"), URLQueryItem(name: "q", value: cityName),URLQueryItem(name: "format", value: "geojson")]
        var urlComps = URLComponents(string: "https://nominatim.openstreetmap.org/search.php")
        urlComps?.queryItems = queryItems
        guard let serviceUrl = urlComps?.url else { return }
        
        var request = URLRequest(url: serviceUrl)
        request.httpMethod = "GET"
        request.setValue("Application/json", forHTTPHeaderField: "Content-Type")
        let session = URLSession.shared
        session.dataTask(with: request) { (data, response, error) in
            if let response = response {
                print(response)
            }
            
            
            if let data = data {
                do {
                    let json = try JSONSerialization.jsonObject(with: data, options: [])
                    let jsonObj = JSON.init(json)
                    let placeIdsArray = jsonObj["features"].arrayValue
                    placeIdsArray.forEach { objJosn in
                        let geometry = objJosn.dictionaryValue["geometry"]
                        if let type = geometry?.dictionaryValue["type"]?.stringValue,  type == "Polygon", let arrayOfCoordinates = geometry?["coordinates"].arrayValue{
                            debugPrint("cordinate array :=\(arrayOfCoordinates.first ?? JSON())")
                        }
                    }
                    print(json)
                } catch {
                    print(error)
                }
            }
        }.resume()
    }
    
}
