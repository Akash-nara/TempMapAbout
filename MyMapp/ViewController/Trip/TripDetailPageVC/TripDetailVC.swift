//
//  TripDetailVC.swift
//  MyMapp
//
//  Created by Chirag Pandya on 04/12/21.
//

import UIKit
import SKPhotoBrowser
import MapKit

class TripCommmnets {
    var name = ""
    var id = 0
    var comment = ""
    var userImage = ""
    var bookmark = false
    
    var likeUnLiked = false
    init(){}
    
    init(param:JSON) {
        self.name = param["name"].stringValue
        self.id = param["id"].intValue
        self.comment = param["comment"].stringValue
        self.userImage = param["userImage"].stringValue
        self.likeUnLiked = param["likeUnLiked"].boolValue
        self.likeUnLiked = param["likeUnLiked"].boolValue
        
    }
}

class TripDetailVC: UIViewController {
    enum EnumTripPageFlow {
        case personal, otherUser
    }
    
    //MARK: - OUTLETS
    @IBOutlet weak var consX: NSLayoutConstraint!
    @IBOutlet weak var consY: NSLayoutConstraint!
    @IBOutlet weak var vwBlur: UIView!
    @IBOutlet weak var consWidth: NSLayoutConstraint!
    @IBOutlet weak var consHeight: NSLayoutConstraint!
    @IBOutlet weak var vwImage: UIImageView!
    @IBOutlet weak var txtComment:UITextField!
    @IBOutlet weak var viewSep:UIView!
    
    @IBOutlet weak var buttonCurrentChatBookmark:UIButton!
    @IBOutlet weak var buttonCurrentChatLikeUnLike:UIButton!
    @IBOutlet weak var viewComment:UIView!
    @IBOutlet weak var viewCommentHeightConstraint:NSLayoutConstraint!
    
    var enumCurrentFlow:EnumTripPageFlow = .personal
    
    @IBOutlet weak var tblviewTrip: UITableView!{
        didSet{
            tblviewTrip.setDefaultProperties(vc: self)
            tblviewTrip.registerCell(type: TripMainPageHeaderCellXIB.self, identifier: TripMainPageHeaderCellXIB.identifier)
            tblviewTrip.registerCell(type: TripMainPageHeaderNameXIB.self, identifier: TripMainPageHeaderNameXIB.identifier)
            tblviewTrip.registerCell(type: TripMainLocationCellXIB.self, identifier: TripMainLocationCellXIB.identifier)
            tblviewTrip.registerCell(type: TripMainPageTopCellXIB.self, identifier: TripMainPageTopCellXIB.identifier)
            tblviewTrip.registerCell(type: TripMainPageCommentsCellXIB.self, identifier: TripMainPageCommentsCellXIB.identifier)
            tblviewTrip.registerCell(type: TripMainPageTableCell.self, identifier: TripMainPageTableCell.identifier)
            
            // Enable automatic row auto layout calculations
            tblviewTrip.rowHeight = UITableView.automaticDimension;
            tblviewTrip.sectionHeaderHeight = UITableView.automaticDimension
            tblviewTrip.contentInset = UIEdgeInsets.init(top: 0, left: 0, bottom: 20, right: 0)
            
            self.tblviewTrip.estimatedRowHeight = 100
            self.tblviewTrip.separatorColor = UIColor.clear
            if #available(iOS 15.0, *) {
                tblviewTrip.sectionHeaderTopPadding = 0
            } else {
                // Fallback on earlier versions
            }
        }
    }
    
    //MARK: - VARIABLES
    var collectionPhotos:UICollectionView?
    var isTopTipExpand:Bool = false
    var isFavouriteExpand:Bool = false
    var isLogisticsExpand:Bool = false
    var detailTripDataModel:TripDataModel? = nil
    var currentChatIsBookmark = false{
        didSet{
            
        }
    }
    var currentChatIsLiked = false{
        didSet{
            
        }
    }
    
    enum EnumTripToalSections:Equatable {
        static func == (lhs: TripDetailVC.EnumTripToalSections, rhs: TripDetailVC.EnumTripToalSections) -> Bool {
            return lhs == rhs.self
        }
        
        case tripImages, locationList([AddTripFavouriteLocationDetail]), topTips(String,String), travelStory(String,String), logisticsRoute(String,String), comments, travelAdvice
    }
    var arrayOfSections = [EnumTripToalSections]()
    var arrayOfTravelAdvice = [EnumTripSection]()
    var arrayOfComments = [TripCommmnets]()
    var heightOFCollectionView  = CGFloat()
    var cellCollectionView:TripMainPageTableCell? = nil
    //MARK: - VIEW DID LOAD
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if enumCurrentFlow == .otherUser{
            let headerCell = tblviewTrip.dequeueReusableCell(withIdentifier: "TripMainPageHeaderCellXIB") as! TripMainPageHeaderCellXIB
            tblviewTrip.tableHeaderView = headerCell
//            tblviewTrip.sectionHeaderHeight = UITableView.automaticDimension
//            tblviewTrip.estimatedSectionHeaderHeight = 40
//            tblviewTrip.estimatedRowHeight = 80
        }
        
        self.vwBlur.isHidden = true
        self.vwImage.alpha = 0
        self.vwImage.isHidden = true
        self.txtComment.layer.borderColor = UIColor.App_BG_Textfield_Unselected_Border_Color.cgColor
        self.txtComment.delegate = self
        self.isTopTipExpand = false
        self.isFavouriteExpand = false
        self.isLogisticsExpand = false
        
        
        buttonCurrentChatBookmark.setImage(UIImage(named: "ic_selected_saved"), for: .selected)
        buttonCurrentChatBookmark.setImage(UIImage(named: "ic_saved_Selected_With_just_border"), for: .normal)
        
        buttonCurrentChatLikeUnLike.setImage(UIImage(named: "iconsHeartSelected"), for: .selected)
        buttonCurrentChatLikeUnLike.setImage(UIImage(named: "ic_Heart_unselected"), for: .normal)
        
        preparedArrayofSections()
        
        self.viewSep.isHidden = true
        if enumCurrentFlow == .otherUser{
            self.viewSep.isHidden = false
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1, execute: {
                self.viewSep.layer.masksToBounds = false
                self.viewSep.layer.shadowColor = UIColor.lightGray.cgColor
                self.viewSep.layer.shadowOpacity = 0.9
                self.viewSep.layer.shadowOffset = .zero
                self.viewSep.layer.shadowRadius = 3
                self.viewSep.layer.shouldRasterize = true
            })
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        if let headerView = tblviewTrip.tableHeaderView, enumCurrentFlow == .otherUser{
            
            let height = headerView.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize).height
            var headerFrame = headerView.frame
            
            //Comparison necessary to avoid infinite loop
            if height != headerFrame.size.height {
                headerFrame.size.height = height
                headerView.frame = headerFrame
                tblviewTrip.tableHeaderView = headerView
            }
        }else{
            tblviewTrip.tableHeaderView = nil
            tblviewTrip.tableHeaderView?.frame = .zero
            tblviewTrip.reloadData()
        }
        
        /*
         if let cell = cellCollectionView{
         if cell.heightOfCollectionViewTrip.constant != cell.collectionViewTrip.contentSize.height{
         cell.heightOfCollectionViewTrip.constant = cell.collectionViewTrip.contentSize.height
         
         //to make sure height is recalculated
         //   tblviewTrip.reloadData()
         //or reload just the row depending on use case and if you know the index of the row to reload :)
         }
         }*/
    }
    var isOwnProfile:Bool{
        return enumCurrentFlow != .otherUser
    }
    func preparedArrayofSections(){
        viewCommentHeightConstraint.constant = isOwnProfile ? 0 : 85
        viewComment.isHidden = isOwnProfile
//        arrayOfSections.append(.tripImages)
//        tblviewTrip.reloadData()
        
        if let objDetailtrip = detailTripDataModel{
            
            // images arrray of trips
            if objDetailtrip.photoUploadedArray.count > 0{
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
    
    //MARK: - BUTTON ACTIONS
    @IBAction func btnHandlerSelectOptions(_ sender: Any){
        let actionSheetController: UIAlertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let firstAction: UIAlertAction = UIAlertAction(title: "Share", style: .default) { action -> Void in
            CustomAlertView.init(title: "Comming soon.", forPurpose: .success).showForWhile(animated: true)
        }
        
        let secondAction: UIAlertAction = UIAlertAction(title: "Edit", style: .default) { action -> Void in
            CustomAlertView.init(title: "Comming soon.", forPurpose: .success).showForWhile(animated: true)
        }
        
        let cancelAction: UIAlertAction = UIAlertAction(title: "Cancel", style: .cancel) { action -> Void in }
        
        actionSheetController.addAction(firstAction)
        actionSheetController.addAction(secondAction)
        actionSheetController.addAction(cancelAction)
        actionSheetController.popoverPresentationController?.sourceView = sender as? UIView
        present(actionSheetController, animated: true) {
            print("option menu presented")
        }
    }
    
    @IBAction func btnHandlerback(sender: UIButton){
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func buttonLikeUnLikeCurrentChatTapped(sender: UIButton){
        sender.isSelected.toggle()
    }
    
    @IBAction func buttonBookmarkCurrentChatTapped(sender: UIButton){
        sender.isSelected.toggle()
    }
    
    //MARK: - OTHER FUNCTIONS
    @objc func isTopTipExpandView(sender:UIButton){
        self.isTopTipExpand.toggle()
        self.isLogisticsExpand = false
        self.isFavouriteExpand = false
        self.tblviewTrip.reloadData()
    }
    
    @objc func isFavouriteExpandView(sender:UIButton){
        self.isFavouriteExpand.toggle()
        self.isTopTipExpand = false
        self.isLogisticsExpand = false
        self.tblviewTrip.reloadData()
    }
    
    @objc func isLogisticsExpandView(sender:UIButton){
        self.isLogisticsExpand = !isLogisticsExpand
        self.isFavouriteExpand = false
        self.isTopTipExpand = false
        self.tblviewTrip.reloadData()
    }
}

//MARK: - TABLEVIEW METHODS
extension TripDetailVC:UITableViewDelegate,UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return arrayOfSections.count//7
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        switch arrayOfSections[section] {
        case .tripImages:
            return 1
        case .locationList(let arrayLocation):
            return arrayLocation.count
        case .topTips:
            return 1
        case .travelStory:
            return 1
        case .logisticsRoute:
            return 1
        case .comments:
            return arrayOfComments.count
        case .travelAdvice:
            return 0
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch arrayOfSections[indexPath.section] {
            
        case .tripImages:
            let cell = self.tblviewTrip.dequeueReusableCell(withIdentifier: "TripMainPageTableCell", for: indexPath) as! TripMainPageTableCell
            
            cell.photoUploadedArray = self.detailTripDataModel?.photoUploadedArray ?? []
            cell.configureArray()
            cell.collectionViewTrip.reloadData {
                let pages = ceil(cell.collectionViewTrip.contentSize.width /
                                 cell.collectionViewTrip.frame.size.width);
                cell.pageCtrl.numberOfPages = Int(pages)
            }

//            cell.configureCollectionView()
            
//            let height = cell.collectionViewTrip.collectionViewLayout.collectionViewContentSize.height
//            cell.heightOfCollectionViewTrip.constant = height
//            self.view.setNeedsLayout()

//            cell.frame = tableView.bounds
//            cell.collectionViewTrip.reloadData()
//            cell.layoutIfNeeded()
            
            cell.didTap = { [weak self] indexPath in
                guard let detailVC = UIStoryboard.trip.tripPhotoExpansionDetailsVC else {
                    return
                }
//                self.navigationController?.pushViewController(detailVC, animated: true)
            }
            
            cell.callbackAfterReload = { [weak self] height in
            }
            
            cell.callbackImageZoom = { [weak self] (cell, state) in
                self?.longPressGestureHandler(state: state,cell: cell)
            }
            
            cellCollectionView = cell
            return cell
        case .locationList(let arrayLocation):
            // location
            
            guard let cell = self.tblviewTrip.dequeueCell(
                withType: TripMainLocationCellXIB.self,
                for: indexPath) as? TripMainLocationCellXIB else {
                    return UITableViewCell()
                }
            cell.labelTitle.text = arrayLocation[indexPath.row].locationFav.name
            cell.subTitle.text = arrayLocation[indexPath.row].locationFav.name
            cell.buttonBookmark.setImage(UIImage(named: "ic_selected_saved"), for: .selected)
            cell.buttonBookmark.setImage(UIImage(named: "ic_saved_Selected_With_just_border"), for: .normal)
            cell.buttonBookmark.addTarget(self, action: #selector(buttonBookmarkClicked(sender:)), for: .touchUpInside)
            cell.buttonBookmark.tag = indexPath.section
            cell.buttonBookmark.accessibilityHint = "\(indexPath.row)"
            
            cell.buttonBookmark.isHidden = isOwnProfile
            
            return cell
            
        case .topTips(_, let subTitle):
            guard let cell = self.tblviewTrip.dequeueCell(
                withType: TripMainPageTopCellXIB.self,
                for: indexPath) as? TripMainPageTopCellXIB else {
                    return UITableViewCell()
                }
            
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
            
            if self.isTopTipExpand == true{
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
            guard let cell = self.tblviewTrip.dequeueCell(
                withType: TripMainPageTopCellXIB.self,
                for: indexPath) as? TripMainPageTopCellXIB else {
                    return UITableViewCell()
                }
            
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
            
            if self.isFavouriteExpand == true{
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
            guard let cell = self.tblviewTrip.dequeueCell(
                withType: TripMainPageTopCellXIB.self,
                for: indexPath) as? TripMainPageTopCellXIB else {
                    return UITableViewCell()
                }
            
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
            if self.isLogisticsExpand == true{
                cell.imgviewExpand.image = UIImage(named: "ic_black_expand_icon")
                cell.lblHeader.text = subTitle
                cell.lblHeader.numberOfLines = 0
                
            }else{
                cell.imgviewExpand.image = UIImage(named: "ic_black_collpase_icon")
                cell.lblHeader.text = "Logistics & Routes"
                cell.lblHeader.numberOfLines = 1
            }
            
            return cell
        case .comments:
            
            guard let cell = self.tblviewTrip.dequeueCell(
                withType: TripMainPageCommentsCellXIB.self,
                for: indexPath) as? TripMainPageCommentsCellXIB else {
                    return UITableViewCell()
                }
            
            cell.loadCellData(model: arrayOfComments[indexPath.row])
            cell.buttonLiked.addTarget(self, action: #selector(buttonLikeUnLikedClicked(sender:)), for: .touchUpInside)
            cell.buttonLiked.tag = indexPath.section
            cell.buttonLiked.accessibilityHint = "\(indexPath.row)"
            
            return cell
        default:
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        nil
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        CGFloat.leastNormalMagnitude
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        switch arrayOfSections[section]{
            
        case .locationList(let array):
            // title section only
            guard let cell = self.tblviewTrip.dequeueCell(
                withType: TripMainPageHeaderNameXIB.self,
                for: IndexPath.init(row: 0, section: section)) as? TripMainPageHeaderNameXIB else {
                    return UITableViewCell()
                }
            cell.lblHeader.text = "Locations"
            return cell
            
        case .comments:
            
            // title section only
            guard let cell = self.tblviewTrip.dequeueCell(
                withType: TripMainPageHeaderNameXIB.self,
                for: IndexPath.init(row: 0, section: section)) as? TripMainPageHeaderNameXIB else {
                    return UITableViewCell()
                }
            cell.lblHeader.text = "Comments"
            return cell
            
        case .travelAdvice:
            // title section only
            guard let cell = self.tblviewTrip.dequeueCell(
                withType: TripMainPageHeaderNameXIB.self,
                for: IndexPath.init(row: 0, section: section)) as? TripMainPageHeaderNameXIB else {
                    return UITableViewCell()
                }
            cell.lblHeader.text = "Travel Advice"
            return cell
        default:
            return nil
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch arrayOfSections[indexPath.section]{
        case.tripImages:
//            if let cell = cellCollectionView{
//                return cell.heioght ?? 0//cell.collectionViewTrip.contentSize.height
//            }
            return UITableView.automaticDimension//323+30+30//UITableView.automaticDimension//self.collectionPhotos?.contentSize.height ?? 0.0
        case .topTips:
            return isTopTipExpand ? UITableView.automaticDimension : 60.0
        case .travelStory:
            return isFavouriteExpand ? UITableView.automaticDimension : 60.0
        case .logisticsRoute:
            return isLogisticsExpand ? UITableView.automaticDimension : 60.0
        default:
            return UITableView.automaticDimension
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        switch arrayOfSections[section]{
        case .locationList(_):
            return UITableView.automaticDimension
        case .comments:
            return UITableView.automaticDimension
        case .travelAdvice:
            return UITableView.automaticDimension
        default:
            return 0.001
        }
    }
    
    @objc func longPressGestureHandler(state:UIGestureRecognizer.State, cell:TripMainPageCollectionCell) {
        switch state {
        case .began:
            //            let attributes = self.cellCollectionView?.collectionViewTrip?.layoutAttributesForItem(at: IndexPath(item: 0, section: 0))
            //            let cellRect = attributes?.frame
            //            let cellFrameInSuperview = self.cellCollectionView?.collectionViewTrip?.convert(cellRect ?? CGRect.zero, to: self.tblviewTrip?.superview)
            //            myImageView.center = self.view.center
            //            print("cell frame", cellFrameInSuperview)
            //            self.consX.constant = vwBlur.bounds.width/2//self.tblviewTrip.center.x//(cellFrameInSuperview?.origin.x)!
            //            self.consY.constant = vwBlur.bounds.height/2//tblviewTrip.center.y//(cellFrameInSuperview?.origin.y)!
            //            self.view.layoutIfNeeded()
            
            UIView.animate(withDuration: 0.01, animations: { () -> Void in
                self.vwImage.alpha = 1
                self.consWidth.constant = cell.frame.size.width * 1.5
                self.consHeight.constant = cell.frame.size.height * 1.5
                self.vwImage.isHidden = false
                self.vwImage.image = cell.imgviewZoom.image
                self.vwBlur.isHidden = false
                self.view.layoutIfNeeded()
            })
            
        case .ended:
            UIView.animate(withDuration: 0.01, animations: { () -> Void in
                self.vwImage.alpha = 0
                self.vwImage.isHidden = true
                self.vwImage.image = cell.imgviewZoom.image
                self.consWidth.constant = 0
                self.consHeight.constant = 0
                self.tblviewTrip.alpha = 1
                self.vwBlur.isHidden = true
                //                self.view.layoutIfNeeded()
            })
            
        default: break
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
}

extension TripDetailVC:UITextFieldDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField, reason: UITextField.DidEndEditingReason) {
        textField.resignFirstResponder()  //if desired
        performAction()
    }
    
    func performAction() {
        if !txtComment.text!.isEmpty{
            var json = TripCommmnets()
            json.comment = txtComment.text!
            json.likeUnLiked = buttonCurrentChatLikeUnLike.isSelected
            json.bookmark = buttonCurrentChatBookmark.isSelected
            arrayOfComments.insert(json, at: 0)
            txtComment.text = ""
            let indexPath = IndexPath(
                row: tblviewTrip.numberOfRows(inSection:  tblviewTrip.numberOfSections-1) - 1,
                section: tblviewTrip.numberOfSections-1)
            self.tblviewTrip.reloadSections(IndexSet.init(integer: indexPath.section), with: .automatic) {
                self.buttonCurrentChatLikeUnLike.isSelected = false
                self.buttonCurrentChatBookmark.isSelected = false
            }
            self.tblviewTrip.scrollToBottom()
        }
    }
}

class DynamicHeightCollectionView: UICollectionView {
    override func layoutSubviews() {
        super.layoutSubviews()
        if bounds.size.height != intrinsicContentSize.height {
            self.invalidateIntrinsicContentSize()
        }
    }
    override var intrinsicContentSize: CGSize {
        return collectionViewLayout.collectionViewContentSize
    }
}
