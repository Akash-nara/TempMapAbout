//
//  SubmitSuggestionOfTripViewController.swift
//  MyMapp
//
//  Created by Akash on 14/03/22.
//

import UIKit
import BottomPopup

class SubmitSuggestionOfTripViewController: BottomPopupViewController {
    
    
    //MARK: - VARIABLES
    var height: CGFloat?
    var topCornerRadius: CGFloat?
    var presentDuration: Double?
    var dismissDuration: Double?
    var shouldDismissInteractivelty: Bool?
    var customNavigationController: UINavigationController?
    
    let mainHeight = UIScreen.main.bounds.size.height -  50//150//700
    
    override var popupHeight: CGFloat { return height ?? CGFloat(mainHeight) }
    override var popupTopCornerRadius: CGFloat { return topCornerRadius ?? CGFloat(10) }
    override var popupPresentDuration: Double { return presentDuration ?? 1.0 }
    override var popupDismissDuration: Double { return dismissDuration ?? 1.0 }
    override var popupShouldDismissInteractivelty: Bool { return shouldDismissInteractivelty ?? true }
    
    @IBOutlet weak var labelTitle: UILabel!
    @IBOutlet weak var heightOfTableView: NSLayoutConstraint!
    
    struct TripSuggestion{
        
        var id:Int!
        var value:String!
        var title:String!
    }
    var arraySuggestionList = [TripSuggestion]()
    var tripId = 0
    var cityId = 0
    var cityName = "Spain"
    
    @IBOutlet weak var tblviewData: UITableView!{
        didSet{
            tblviewData.setDefaultProperties(vc: self)
            tblviewData.registerCell(type: TripSuggestionTVCell.self, identifier: TripSuggestionTVCell.identifier)
            tblviewData.contentInset = UIEdgeInsets.init(top: 0, left: 0, bottom: 30, right: 0)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        labelTitle.text = cityName
//         getSuggestionList()
        
        arraySuggestionList.append(TripSuggestion.init(id: 0, value: "adkdlmadlkdamdlkd", title: "Covid"))
        arraySuggestionList.append(TripSuggestion.init(id: 1, value: "SSSSSSSSSadkdlmadlkdamdlkd", title: "laung Curreancy"))
        arraySuggestionList.append(TripSuggestion.init(id: 2, value: "SSSSSSSSSadkdlmadlkdamdlkd", title: "Other information"))
        tblviewData.reloadData()
        heightOfTableView.constant = min(mainHeight - 55 - 40, CGFloat(arraySuggestionList.count*125))
    }
    
    @IBAction func buttonBackTapp(_ sender:UIButton){
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func btnHandlerSubmit(_ sender:UIButton){
        self.dismiss(animated: true, completion: nil)
    }
    
}

extension SubmitSuggestionOfTripViewController{
    func getSuggestionList() {
        let strJson = JSON(["id": "\(cityId)"]).rawString(.utf8, options: .sortedKeys) ?? ""
        let param: [String: Any] = ["requestJson" : strJson]
        API_SERVICES.callAPI(param, path: .getAdminSuggestions, method: .post) { response in
            debugPrint(response)
        } failure: { str in
        } internetFailure: {
        } failureInform: {
        }
    }
    
    func submitSuggestionList(text:String,index:Int) {
        let strJson = JSON(["suggestion": text, "suggestionCategory":["id":arraySuggestionList[index].id]]).rawString(.utf8, options: .sortedKeys) ?? ""
        let param: [String: Any] = ["requestJson" : strJson]
        API_SERVICES.callAPI(param, path: .submitListOfSuggestions, method: .post) { response in
            debugPrint(response)
        } failure: { str in
        } internetFailure: {
        } failureInform: {
        }
    }
}

//MARK: - TABLEVIEW METHODS
extension SubmitSuggestionOfTripViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arraySuggestionList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tblviewData.dequeueReusableCell(withIdentifier: "TripSuggestionTVCell", for: indexPath) as! TripSuggestionTVCell
        cell.labelTitle.text = "  "+arraySuggestionList[indexPath.row].title
        cell.textViewTripSuggestion.text = arraySuggestionList[indexPath.row].value
        cell.textViewTripSuggestion.delegate = self
        cell.textViewTripSuggestion.tag = indexPath.row
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){}
}

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
        if arraySuggestionList[textView.tag].value != textView.text!{
            submitSuggestionList(text: textView.text!, index: textView.tag)
        }
    }
    
    func textViewDidChange(_ textView: UITextView) {
        arraySuggestionList[textView.tag].value = textView.text!
    }
    
}
