//
//  SubmitSuggestionOfTripViewController.swift
//  MyMapp
//
//  Created by Akash on 14/03/22.
//

import UIKit
import BottomPopup

class TripSuggestion{
    
    class Category {
        
        class SuggestionCategory {
            
            var id:Int = 0
            var placeholder:String = ""
            var value:String = ""
            var key:String = ""
            
            init(){}
            init(param:JSON){
                self.id = param["id"].intValue
                self.placeholder = param["placeholder"].stringValue
                self.value = param["value"].stringValue
                self.key = param["key"].stringValue
            }
        }
        
        var id:Int = 0
        var suggestionCategory:SuggestionCategory = SuggestionCategory()
        
        init(){}
        init(param:JSON) {
            self.id = param["id"].intValue
            self.suggestionCategory = SuggestionCategory.init(param: param["suggestionCategory"])
        }
    }
    var id:Int = 0
    var suggestion:String = ""
    var objCategory = Category()
    
    init(param:JSON){
        
        self.id = param["id"].intValue
        self.suggestion = param["suggestion"].stringValue
        self.objCategory = Category.init(param: param["category"])
    }
}

class SubmitSuggestionOfTripViewController: BottomPopupViewController {
    
    //MARK: - VARIABLES
    var height: CGFloat?
    var topCornerRadius: CGFloat?
    var presentDuration: Double?
    var dismissDuration: Double?
    var shouldDismissInteractivelty: Bool?
    var customNavigationController: UINavigationController?
    
    let mainHeight = UIScreen.main.bounds.size.height -  100//150//700
    
    override var popupHeight: CGFloat { return height ?? CGFloat(mainHeight) }
    override var popupTopCornerRadius: CGFloat { return topCornerRadius ?? CGFloat(10) }
    override var popupPresentDuration: Double { return presentDuration ?? 1.0 }
    override var popupDismissDuration: Double { return dismissDuration ?? 1.0 }
    override var popupShouldDismissInteractivelty: Bool { return shouldDismissInteractivelty ?? true }
    
    @IBOutlet weak var labelTitle: UILabel!
    @IBOutlet weak var heightOfTableView: NSLayoutConstraint!
    @IBOutlet weak var viewButtonContainer: UIView!

    @IBOutlet weak var tblviewData: SayNoForDataTableView!{
        didSet{
            tblviewData.setDefaultProperties(vc: self)
            tblviewData.registerCell(type: SkeletonTripTVCell.self, identifier: "SkeletonTripTVCell")
            tblviewData.registerCell(type: TripSuggestionTVCell.self, identifier: TripSuggestionTVCell.identifier)
            tblviewData.contentInset = UIEdgeInsets.init(top: 0, left: 0, bottom: 30, right: 0)
            tblviewData.sayNoSection = .noDataFound("Data not found")
            self.reloadData()
        }
    }
    
    var arraySuggestionList = [TripSuggestion.Category]()
    var tripId = 0
    var cityId = 0
    var cityName = ""
    var isFetchedDara = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        labelTitle.text = cityName
        labelTitle.numberOfLines = 2
        getSuggestionList()
    }
        
    @IBAction func buttonBackTapp(_ sender:UIButton){
        self.view.endEditing(true)
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func btnHandlerSubmit(_ sender:UIButton){
        self.view.endEditing(true)
        self.dismiss(animated: true, completion: nil)
    }
}

extension SubmitSuggestionOfTripViewController{
    func getSuggestionList() {
        let strJson = JSON(["id": "\(cityId)"]).rawString(.utf8, options: .sortedKeys) ?? ""
        let param: [String: Any] = ["requestJson" : strJson]
        API_SERVICES.callAPI(param, path: .getListOfSuggestions, method: .post) { [weak self] response in
            self?.isFetchedDara = true
            guard let suggestionObjArray =  response?["responseJson"]?.dictionaryValue["suggestion"]?.arrayValue else {
                return
            }
            self?.arraySuggestionList.removeAll()
            suggestionObjArray.forEach { obj in
                self?.arraySuggestionList.append(TripSuggestion.Category.init(param: obj))
            }
            self?.reloadData()
        } failure: { str in
        } internetFailure: {
        } failureInform: {
        }
    }
    
    func reloadData(){
        if isFetchedDara{
            self.heightOfTableView.constant = mainHeight //- (CGFloat(arraySuggestionList.count*125) - 55 - 40 - 40) //min(mainHeight - 55 - 40, CGFloat(arraySuggestionList.count*125))
        }else{
            
            self.heightOfTableView.constant = mainHeight //- (CGFloat(4*125) - 55 - 40 - 40) //min(mainHeight - 55 - 40, CGFloat(arraySuggestionList.count*125))
        }
        
        if arraySuggestionList.count != 0{
            viewButtonContainer.isHidden = false
            tblviewData.isUserInteractionEnabled = true

        }else{
            tblviewData.isUserInteractionEnabled = false
            tblviewData.isScrollEnabled = false
            self.heightOfTableView.constant = mainHeight/2
            // Enable scrolling based on content height
        }
        
        self.tblviewData.reloadData()
        self.tblviewData.figureOutAndShowNoResults()
    }
    
    func submitSuggestionList(text:String,index:Int) {
        let strJson = JSON(["suggestion": text, "suggestionCategory":["id":arraySuggestionList[index].suggestionCategory.id]]).rawString(.utf8, options: .sortedKeys) ?? ""
        let param: [String: Any] = ["requestJson" : strJson]
        API_SERVICES.callAPI(param, path: .submitListOfSuggestions, method: .post) { [weak self] response in
            debugPrint(response)
            self?.arraySuggestionList[index].suggestionCategory.value = text
        } failure: { str in
        } internetFailure: {
        } failureInform: {
        }
    }
}

//MARK: - TABLEVIEW METHODS
extension SubmitSuggestionOfTripViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard self.isFetchedDara else { return 3 }
        return arraySuggestionList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard isFetchedDara else {
            let cell = tblviewData.dequeueReusableCell(withIdentifier: "SkeletonTripTVCell", for: indexPath) as! SkeletonTripTVCell
            cell.startAnimating(index: indexPath.row)
            return cell
        }
        
        let cell = self.tblviewData.dequeueReusableCell(withIdentifier: "TripSuggestionTVCell", for: indexPath) as! TripSuggestionTVCell
        cell.labelTitle.text = "  "+arraySuggestionList[indexPath.row].suggestionCategory.value
        cell.textViewTripSuggestion.text = ""
        cell.textViewTripSuggestion.delegate = self
        cell.textViewTripSuggestion.tag = indexPath.row
        cell.textViewTripSuggestion.placeholder = arraySuggestionList[indexPath.row].suggestionCategory.placeholder
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){}
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return !isFetchedDara ? 150 : UITableView.automaticDimension
    }

}

// UITextViewDelegate
extension SubmitSuggestionOfTripViewController: UITextViewDelegate{
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if(text == "\n") {
            textView.resignFirstResponder()
            return false
        }
        return true
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        debugPrint("end edting row \(textView.tag) \(textView.text!)")
//        if arraySuggestionList[textView.tag].suggestionCategory.value != textView.text!{
            submitSuggestionList(text: textView.text!, index: textView.tag)
//        }
    }
    
    func textViewDidChange(_ textView: UITextView) {
        //        arraySuggestionList[textView.tag].suggestion = textView.text!
    }
}

//BottomPopupDelegate
extension SubmitSuggestionOfTripViewController:BottomPopupDelegate{
    func bottomPopupDidDismiss() {
        self.view.endEditing(true)
    }
}
