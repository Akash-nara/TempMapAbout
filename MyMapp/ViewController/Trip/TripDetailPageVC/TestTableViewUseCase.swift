//
//  TestTableViewUseCase.swift
//  MyMapp
//
//  Created by Akash on 09/02/22.
//

import UIKit

class TestTableViewUseCase: UIViewController {
    
    @IBOutlet weak var tblviewTrip:UITableView!
    
    var arrayOfSections = [EnumTripToalSections]()
    var detailTripDataModel:TripDataModel? = nil
    var enumCurrentFlow:EnumTripPageFlow = .personal
    var arrayOfTravelAdvice = [EnumTripSection]()
    var arrayOfComments = [TripCommmnets]()
    var isTopTipExpand:Bool = false
    var isFavouriteExpand:Bool = false
    var isLogisticsExpand:Bool = false

    override func viewDidLoad() {
        super.viewDidLoad()
        
        configuretableVIew()
    }
    
    func configuretableVIew(){
        tblviewTrip.setDefaultProperties(vc: self)
        tblviewTrip.registerCell(type: TripMainPageHeaderCellXIB.self, identifier: TripMainPageHeaderCellXIB.identifier)
        tblviewTrip.registerCell(type: TripMainPageHeaderNameXIB.self, identifier: TripMainPageHeaderNameXIB.identifier)
        tblviewTrip.registerCell(type: TripMainLocationCellXIB.self, identifier: TripMainLocationCellXIB.identifier)
        tblviewTrip.registerCell(type: TripMainPageTopCellXIB.self, identifier: TripMainPageTopCellXIB.identifier)
        tblviewTrip.registerCell(type: TripMainPageCommentsCellXIB.self, identifier: TripMainPageCommentsCellXIB.identifier)
        tblviewTrip.registerCell(type: TripMainPageTableCell.self, identifier: TripMainPageTableCell.identifier)
        
        if #available(iOS 15.0, *) {
            tblviewTrip.sectionHeaderTopPadding = 0
        } else {
            // Fallback on earlier versions
        }
        
        preparedArrayofSections()
    }
    
    var isOwnProfile:Bool{
        return enumCurrentFlow != .otherUser
    }
    func preparedArrayofSections(){
        //        viewCommentHeightConstraint.constant = isOwnProfile ? 0 : 85
        //        viewComment.isHidden = isOwnProfile
        //        arrayOfSections.append(.tripImages)
        //        tblviewTrip.reloadData()
        
        if let objDetailtrip = detailTripDataModel{
            
            // images arrray of trips
            if objDetailtrip.photoUploadedArray.count > 0{
                arrayOfSections.append(.tripImages)
                arrayOfSections.append(.tripImages)
                arrayOfSections.append(.tripImages)
                arrayOfSections.append(.tripImages)
                arrayOfSections.append(.tripImages)
                arrayOfSections.append(.tripImages)
                arrayOfSections.append(.tripImages)

            }
            
            // location list
            if objDetailtrip.locationList.count > 0{
                arrayOfSections.append(.locationList(objDetailtrip.locationList))
            }
            
            /*
             var tempArrayAdvice = [EnumTripSection]()
             objDetailtrip.advicesOfArray.forEach { objSection in
             tempArrayAdvice
             switch objSection{
             case .topTips(<#T##String#>, <#T##String#>)
             }
             if objSection == .topTips("", ""){
             tempArrayAdvice.append(objSection)
             }
             
             if objSection == .travelStory("", ""){
             tempArrayAdvice.append(objSection)
             }
             
             if objSection == .logisticsRoute("", ""){
             tempArrayAdvice.append(objSection)
             }
             }*/
            
            //        arrayOfSections.append(.travelStory("", ""))
            //        arrayOfSections.append(.logisticsRoute("", ""))
            
            // travel advice
            arrayOfTravelAdvice = objDetailtrip.advicesOfArray
            if arrayOfTravelAdvice.count > 0{
                arrayOfSections.append(.travelAdvice)
            }
            
            arrayOfTravelAdvice.forEach { Obj in
                switch Obj {
                case .topTips(let title, let subTitle):
                    arrayOfSections.append(.topTips(title, subTitle))
                case .travelStory(let title, let subTitle):
                    arrayOfSections.append(.travelStory(title, subTitle))
                case .logisticsRoute(let title, let subTitle):
                    arrayOfSections.append(.logisticsRoute(title, subTitle))
                default:
                    break
                }
            }
            
            //             comments
            if enumCurrentFlow == .otherUser{
                arrayOfComments.append(TripCommmnets.init(param: JSON.init(["":""])))
                if arrayOfComments.count != 0{
                    arrayOfSections.append(.comments)
                }
            }
        }
    }
}


//MARK: - TABLEVIEW METHODS
extension TestTableViewUseCase:UITableViewDelegate,UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return arrayOfSections.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch arrayOfSections[indexPath.section]{
        case .topTips(_, let subTitle):
            let cell = self.tblviewTrip.dequeueReusableCell(withIdentifier: "TripMainPageTopCellXIB", for: indexPath) as! TripMainPageTopCellXIB

            cell.trealingViewExpand.constant = isOwnProfile ? 20 : 50
            cell.buttonBookmark.isHidden = isOwnProfile
            cell.btnTitleExpand.tag = indexPath.section
            cell.btnTitleExpand.accessibilityHint = "\(indexPath.row)"
            cell.btnTitleExpand.addTarget(self, action: #selector(self.isTopTipExpandView(sender:)), for: .touchUpInside)
            cell.lblHeader.numberOfLines = 1
            cell.buttonBookmark.tag = indexPath.section
            cell.buttonBookmark.accessibilityHint = "\(indexPath.row)"
            
            cell.buttonBookmark.setImage(UIImage(named: "ic_selected_saved"), for: .selected)
            cell.buttonBookmark.setImage(UIImage(named: "ic_saved_Selected_With_just_border"), for: .normal)
            cell.buttonBookmark.addTarget(self, action: #selector(buttonBookmarkClicked(sender:)), for: .touchUpInside)
            
            if isTopTipExpand{
                cell.imgviewExpand.image = UIImage(named: "ic_black_expand_icon")
                cell.lblHeader.text = subTitle//subTitle
                cell.lblHeader.numberOfLines = 0
            }else{
                cell.imgviewExpand.image = UIImage(named: "ic_black_collpase_icon")
                cell.lblHeader.text = "Top Tip"
                cell.lblHeader.numberOfLines = 1
            }
            return cell
            
        case .travelStory(let _ , let subTitle):
            let cell = self.tblviewTrip.dequeueReusableCell(withIdentifier: "TripMainPageTopCellXIB", for: indexPath) as! TripMainPageTopCellXIB
            
            cell.btnTitleExpand.tag = indexPath.section
            cell.btnTitleExpand.accessibilityHint = "\(indexPath.row)"
            cell.btnTitleExpand.addTarget(self, action: #selector(self.isFavouriteExpandView(sender:)), for: .touchUpInside)
            
            cell.trealingViewExpand.constant = isOwnProfile ? 20 : 50
            cell.buttonBookmark.isHidden = isOwnProfile
            cell.buttonBookmark.setImage(UIImage(named: "ic_selected_saved"), for: .selected)
            cell.buttonBookmark.setImage(UIImage(named: "ic_saved_Selected_With_just_border"), for: .normal)
            cell.buttonBookmark.addTarget(self, action: #selector(buttonBookmarkClicked(sender:)), for: .touchUpInside)
            cell.buttonBookmark.tag = indexPath.section
            cell.buttonBookmark.accessibilityHint = "\(indexPath.row)"
            
            if isFavouriteExpand{
                cell.imgviewExpand.image = UIImage(named: "ic_black_expand_icon")
                cell.lblHeader.text = subTitle//subTitle
                cell.lblHeader.numberOfLines = 0
            }else{
                cell.lblHeader.text = "Favorite Travel Story"
                cell.imgviewExpand.image = UIImage(named: "ic_black_collpase_icon")
                cell.lblHeader.numberOfLines = 1
            }
            
            return cell
            
        case .logisticsRoute(_, let subTitle):
            let cell = self.tblviewTrip.dequeueReusableCell(withIdentifier: "TripMainPageTopCellXIB", for: indexPath) as! TripMainPageTopCellXIB

            cell.btnTitleExpand.accessibilityHint = "\(indexPath.row)"
            cell.btnTitleExpand.tag = indexPath.section
            cell.btnTitleExpand.addTarget(self, action: #selector(self.isLogisticsExpandView(sender:)), for: .touchUpInside)
            cell.trealingViewExpand.constant = isOwnProfile ? 20 : 50
            
            
            cell.buttonBookmark.setImage(UIImage(named: "ic_selected_saved"), for: .selected)
            cell.buttonBookmark.setImage(UIImage(named: "ic_saved_Selected_With_just_border"), for: .normal)
            cell.buttonBookmark.addTarget(self, action: #selector(buttonBookmarkClicked(sender:)), for: .touchUpInside)
            cell.buttonBookmark.tag = indexPath.section
            cell.buttonBookmark.accessibilityHint = "\(indexPath.row)"
            cell.buttonBookmark.isHidden = isOwnProfile
            
            if isLogisticsExpand{
                cell.imgviewExpand.image = UIImage(named: "ic_black_expand_icon")
                cell.lblHeader.text = subTitle
                cell.lblHeader.numberOfLines = 0
                
            }else{
                cell.imgviewExpand.image = UIImage(named: "ic_black_collpase_icon")
                cell.lblHeader.text = "Logistics & Routes"
                cell.lblHeader.numberOfLines = 1
            }
            
            return cell
        default:
            return UITableViewCell()
        }
    }
    
    @objc func buttonLikeUnLikedClicked(sender:UIButton){
        sender.isSelected.toggle()
    }
    
    @objc func buttonBookmarkClicked(sender:UIButton){
        let indexRow = Int(sender.accessibilityHint ?? "") ?? 0
        
        sender.isSelected.toggle()
        switch arrayOfSections[sender.tag]{
        case .travelAdvice:
            
            switch arrayOfTravelAdvice[indexRow]{
            case .topTips:
                debugPrint("topTips")
            case .travelStory:
                debugPrint("travelStory")
            case .logisticsRoute:
                debugPrint("logisticsRoute")
            default:
                break
            }
        case .locationList(let array):
            if array.indices.contains(indexRow){
                debugPrint("locationList:\(array[indexRow])")
            }
        default:break
        }
    }
    
    //MARK: - OTHER FUNCTIONS
    @objc func isTopTipExpandView(sender:UIButton){
//        sender.isSelected = !sender.isSelected
        self.isTopTipExpand = !isTopTipExpand
        //        self.isLogisticsExpand = false
        //        self.isFavouriteExpand = false
        self.tblviewTrip.reloadSections(IndexSet(integer: sender.tag), with: .automatic)
    }
    
    @objc func isFavouriteExpandView(sender:UIButton){
//        sender.isSelected = !sender.isSelected
        self.isFavouriteExpand = !isFavouriteExpand
        //        self.isTopTipExpand = false
        //        self.isLogisticsExpand = false
        self.tblviewTrip.reloadSections(IndexSet(integer: sender.tag), with: .automatic)
    }
    
    @objc func isLogisticsExpandView(sender:UIButton){
//        sender.isSelected = !sender.isSelected
        self.isLogisticsExpand = !isLogisticsExpand
        //        self.isFavouriteExpand = false
        //        self.isTopTipExpand = false
        self.tblviewTrip.reloadSections(IndexSet(integer: sender.tag), with: .automatic)
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch arrayOfSections[indexPath.section] {
        case .tripImages,.locationList, .comments, .travelAdvice :
            return 0.001
        default:
            return UITableView.automaticDimension
        }
        
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 1.11
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let abcview = UIView()
        return abcview
    }
}
