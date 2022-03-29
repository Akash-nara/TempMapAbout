//
//  TripDetailVC.swift
//  MyMapp
//
//  Created by Chirag Pandya on 04/12/21.
//

import UIKit
import SKPhotoBrowser
import MapKit
import SDWebImage


enum EnumTripToalSections:Equatable {
    static func == (lhs: EnumTripToalSections, rhs: EnumTripToalSections) -> Bool {
        return lhs == rhs.self
    }
    
    case userDetail, tripImages, locationList([AddTripFavouriteLocationDetail]), topTips(TravelAdviceDataModel), travelStory(TravelAdviceDataModel), logisticsRoute(TravelAdviceDataModel), comments, travelAdvice
}

enum EnumTripPageFlow {
    case personal, otherUser
}

class TripDetailVC: UIViewController {
    
    //MARK: - OUTLETS
    @IBOutlet weak var consX: NSLayoutConstraint!
    @IBOutlet weak var consY: NSLayoutConstraint!
    @IBOutlet weak var vwBlur: UIView!
    @IBOutlet weak var consWidth: NSLayoutConstraint!
    @IBOutlet weak var consHeight: NSLayoutConstraint!
    @IBOutlet weak var vwImage: UIImageView!
    @IBOutlet weak var txtComment:UITextField!
    @IBOutlet weak var viewSep:UIView!
    @IBOutlet weak var viewSetting:UIView!
    @IBOutlet weak var buttonSetting:UIButton!

    @IBOutlet weak var buttonCurrentChatBookmark:UIButton!
    @IBOutlet weak var buttonCurrentChatLikeUnLike:UIButton!
    @IBOutlet weak var viewComment:UIView!
    @IBOutlet weak var viewCommentHeightConstraint:NSLayoutConstraint!
    
    var enumCurrentFlow:EnumTripPageFlow = .personal
    
    @IBOutlet weak var tblviewTrip: SayNoForDataTableView!{
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
            tblviewTrip.sayNoSection = .noSearchResultFound("Trip detail not found.")
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
    
    var arrayOfSections = [EnumTripToalSections]()
    var arrayOfTravelAdvice = [TravelAdviceDataModel]()
    var arrayOfComments = [TripCommmnets]()
    var heightOFCollectionView  = CGFloat()
    var cellCollectionView:TripMainPageTableCell? = nil
    
    //MARK: - VIEW DID LOAD
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
        tblviewTrip.reloadData()
        tblviewTrip.figureOutAndShowNoResults()
        
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
//        SDImageCache.shared.clear(with: .all) {
//            print("Disk & memory data cleared")
//        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
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
                viewCommentHeightConstraint.constant = 0
                viewComment.isHidden = true

//        viewCommentHeightConstraint.constant = isOwnProfile ? 0 : 85
//        viewComment.isHidden = isOwnProfile
                arrayOfSections.append(.userDetail)
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
            
            // travel advice
            arrayOfTravelAdvice = objDetailtrip.advicesOfArrayOfDataModel
            if arrayOfTravelAdvice.count > 0{
                arrayOfSections.append(.travelAdvice)
            }
            
            arrayOfTravelAdvice.forEach { Obj in
                debugPrint(Obj.id)
                switch Obj.enumAdviceType {
                case .topTips:
                    arrayOfSections.append(.topTips(Obj))
                case .stories:
                    arrayOfSections.append(.travelStory(Obj))
                case .logistics:
                    arrayOfSections.append(.logisticsRoute(Obj))
                default:
                    break
                }
            }
            
            // comments
            if enumCurrentFlow == .otherUser{
                arrayOfComments.append(TripCommmnets.init(param: JSON.init(["":""])))
                if arrayOfComments.count != 0{
                    //                    arrayOfSections.append(.comments)
                }
            }
        }
        
        if arrayOfSections.count == 0 || enumCurrentFlow == .otherUser{
            viewSetting.isHidden = true
            buttonSetting.isHidden = true
        }
    }
    
    //MARK: - BUTTON ACTIONS
    @IBAction func btnHandlerSelectOptions(_ sender: Any){
        let actionSheetController: UIAlertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let firstAction: UIAlertAction = UIAlertAction(title: "Share", style: .default) { action -> Void in
            CustomAlertView.init(title: "Comming soon.", forPurpose: .success).showForWhile(animated: true)
        }
        
        let secondAction: UIAlertAction = UIAlertAction(title: "Edit", style: .default) { action -> Void in
//            CustomAlertView.init(title: "Comming soon.", forPurpose: .success).showForWhile(animated: true)
            guard let addTripSecondStepVC = UIStoryboard.trip.addTripSecondStepVC else {
                return
            }
            
//            if editFlow{
//                self.arrayCityLevelImageUpload.removeAll()
//                self.objTirpDatModel?.photoUploadedArray.forEach({ objPhotDetail in
//                    objPhotDetail.arrayOfImageURL.forEach { photoObject in
//                        let name = URL.init(string: photoObject.image)?.lastPathComponent ?? ""
//                        let objectModel = TripImagesModel.init(image: UIImage(), type: "", url: photoObject.image)
//                        let str:String = Routing.uploadTripImage.getPath+self.tripBucketHash+"/\(name)"
//                        objectModel.url = photoObject.image
//                        objectModel.keyToSubmitServer = self.tripBucketHash+"/\(name)"
//                        objectModel.isCityUploadeImage = true
//                        objectModel.statusUpload = .done
//                        objectModel.nameOfImage = name
//    //                    locationLevelUploadCount += 1
//                        self.arrayCityLevelImageUpload.append(objectModel)
//                    }
//                })
//            }
            
            totalGlobalTripPhotoCount = 21 // reset count
            addTripSecondStepVC.objTirpDatModel = self.detailTripDataModel
            addTripSecondStepVC.editFlow = true
            self.navigationController?.pushViewController(addTripSecondStepVC, animated: true)
        }
        
        let cancelAction: UIAlertAction = UIAlertAction(title: "Cancel", style: .cancel) { action -> Void in }
        
//        actionSheetController.addAction(firstAction)
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
    
    @IBAction func buttonThreeDotsClicked(sender: UIButton){
        btnHandlerSelectOptions(sender)
    }
    
    //MARK: - OTHER FUNCTIONS
    @objc func isExpandTravelAdvice(_ sender:UITapGestureRecognizer){
        let section = (Int(sender.accessibilityHint ?? "") ?? 0)
        switch arrayOfSections[section] {
        case .topTips:
            self.isTopTipExpand = !isTopTipExpand
        case .travelStory:
            self.isFavouriteExpand = !isFavouriteExpand
        case .logisticsRoute:
            self.isLogisticsExpand = !isLogisticsExpand
        default:
            break
        }
//        self.tblviewTrip.reloadSections(IndexSet(integer: section), with: .automatic)
//        self.tblviewTrip.reloadRows(at: [IndexPath.init(row: 0, section: section)], with: .automatic)
//        self.tblviewTrip.layoutIfNeeded()
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
        case .userDetail:
            return 1
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
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch arrayOfSections[indexPath.section] {
        case .userDetail:
            let cell = self.tblviewTrip.dequeueReusableCell(withIdentifier: "TripMainPageHeaderCellXIB", for: indexPath) as! TripMainPageHeaderCellXIB
            
            //            let headerCell = tblviewTrip.dequeueReusableCell(withIdentifier: "TripMainPageHeaderCellXIB") as! TripMainPageHeaderCellXIB
            cell.configureCell(dataModel: detailTripDataModel)
            //        headerCell.layoutIfNeeded()
            if enumCurrentFlow != .otherUser{
                cell.stackViewUserNameAndAddress.isHidden = true
            }
            return cell
        case .tripImages:
            let cell = self.tblviewTrip.dequeueReusableCell(withIdentifier: "TripMainPageTableCell", for: indexPath) as! TripMainPageTableCell
            
            cell.photoUploadedArray = self.detailTripDataModel?.photoUploadedArray ?? []
            cell.configureArray()
            cell.collectionViewTrip.reloadData()
            DispatchQueue.getMain(delay: 0.6) {
                cell.setTotalPageNo()
            }
            //            cell.collectionViewTrip.reloadData {
            //                let pages = ceil(cell.collectionViewTrip.contentSize.width /
            //                                 cell.collectionViewTrip.frame.size.width);
            //                cell.pageCtrl.numberOfPages = Int(pages)
            //                cell.setTotalPageNo()
            //            }
            
            //            cell.configureCollectionView()
            
            //            let height = cell.collectionViewTrip.collectionViewLayout.collectionViewContentSize.height
            //            cell.heightOfCollectionViewTrip.constant = height
            //            self.view.setNeedsLayout()
            
            //            cell.frame = tableView.bounds
            //            cell.collectionViewTrip.reloadData()
            //            cell.layoutIfNeeded()
            
            cell.didTap = { [weak self] (indexPath, url, isLocationImage) in
                guard let detailVC = UIStoryboard.trip.tripPhotoExpansionDetailsVC else {
                    return
                }
                detailVC.imageName = url
                detailVC.isLcoationImage = isLocationImage
                detailVC.tripDataModel = self?.detailTripDataModel
                self?.navigationController?.pushViewController(detailVC, animated: true)
            }
                    
            cell.callbackImageZoom = { [weak self] (data, state) in
                self?.longPressGestureHandler(state: state, data: data)
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
            cell.labelTitle.text = arrayLocation[indexPath.row].locationFav?.name
            cell.subTitle.text = arrayLocation[indexPath.row].locationFav?.name
            
            cell.locationImage.showSkeleton()
            cell.locationImage.sd_setImage(with: URL.init(string: arrayLocation[indexPath.row].firstLocationImage), placeholderImage: nil, options: .highPriority) { img, error, cache, url in
                cell.locationImage.hideSkeleton()
                if let image = img{
                    cell.locationImage.image = image
                }else{
                    cell.locationImage.image = UIImage.init(named: "not_icon")
                    cell.locationImage.contentMode = .scaleToFill
                    cell.locationImage.backgroundColor = .white
                    cell.locationImage.borderWidth = 0.5
                    cell.locationImage.borderColor = UIColor.App_BG_silver_Color
                }
            }
//            cell.locationImage.setImage(url: arrayLocation[indexPath.row].firstLocationImage, placeholder: UIImage.init(named: "ic_nature_image"))
            
            cell.buttonBookmark.setImage(UIImage(named: "ic_selected_saved"), for: .selected)
            cell.buttonBookmark.setImage(UIImage(named: "ic_saved_Selected_With_just_border"), for: .normal)
            cell.buttonBookmark.addTarget(self, action: #selector(buttonBookmarLocationkClicked(sender:)), for: .touchUpInside)
            cell.buttonBookmark.isSelected = arrayLocation[indexPath.row].isSaved
            
            cell.buttonBookmark.tag = indexPath.section
            cell.buttonBookmark.accessibilityHint = "\(indexPath.row)"
            
            cell.buttonBookmark.isHidden = isOwnProfile
            
            return cell
        case .topTips(let obj):
            return configureAdvanceTravelCell(indexPath: indexPath, dataModel: obj, isExpadCell: isTopTipExpand)
        case .travelStory(let obj):
            return configureAdvanceTravelCell(indexPath: indexPath, dataModel: obj, isExpadCell: isFavouriteExpand)
        case .logisticsRoute(let obj):
            return configureAdvanceTravelCell(indexPath: indexPath, dataModel: obj, isExpadCell: isLogisticsExpand)
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
    
    func configureAdvanceTravelCell(indexPath:IndexPath, dataModel:TravelAdviceDataModel, isExpadCell:Bool) -> TripMainPageTopCellXIB{
        let cell = self.tblviewTrip.dequeueReusableCell(withIdentifier: "TripMainPageTopCellXIB", for: indexPath) as! TripMainPageTopCellXIB
        
        cell.trealingViewExpand.constant = isOwnProfile ? 20 : 50
        
        cell.viewExpand.accessibilityHint = "\(indexPath.row)"
        cell.viewExpand.tag = indexPath.section
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.isExpandTravelAdvice(_:)))
        tap.accessibilityHint = "\(indexPath.section)"
        cell.viewExpand.addGestureRecognizer(tap)
        
        cell.buttonBookmark.setImage(UIImage(named: "ic_selected_saved"), for: .selected)
        cell.buttonBookmark.setImage(UIImage(named: "ic_saved_Selected_With_just_border"), for: .normal)
        cell.buttonBookmark.addTarget(self, action: #selector(buttonBookmarkTravelAdvoiceClicked(sender:)), for: .touchUpInside)
        cell.buttonBookmark.tag = dataModel.id
        cell.buttonBookmark.accessibilityHint = "\(indexPath.section)"
        cell.buttonBookmark.isHidden = isOwnProfile
        cell.buttonBookmark.isSelected = dataModel.isSaved

        cell.lblHeader.text = dataModel.title
        cell.labelSubTitle.text = dataModel.subTitle
        
        cell.bottomConstrainOfMainStackView.constant = isExpadCell ? 20 : 8
        if isExpadCell{
            cell.buttonArrow.setImage(UIImage(named: "ic_black_expand_icon"), for: .normal)
            cell.lblHeader.numberOfLines = 0
            cell.labelSubTitle.isHidden = false
        }else{
            cell.buttonArrow.setImage(UIImage(named: "ic_black_collpase_icon"), for: .normal)
            cell.lblHeader.numberOfLines = 1
            cell.labelSubTitle.isHidden = true
        }
        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        nil
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.001
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        switch arrayOfSections[section]{
            
        case .locationList:
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
            let cell = self.tblviewTrip.dequeueReusableCell(withIdentifier: "TripMainPageHeaderNameXIB", for: IndexPath.init(row: 0, section: section)) as! TripMainPageHeaderNameXIB
            cell.lblHeader.text = "Travel Advice"
            
            return cell
        default:
            return nil
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
    
    func longPressGestureHandler(state:UIGestureRecognizer.State, data: TripDataModel.TripPhotoDetails.TripImage) {
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
                self.consWidth.constant = data.width * 3
                self.consHeight.constant = data.itemHeight * 2.1
                self.vwImage.isHidden = false
                self.vwImage.sd_setImage(with: URL.init(string: data.image), placeholderImage: nil, options: .highPriority) { img, error, cache, url in
                }
//                self.vwImage.image = cell.imgviewZoom.image
                self.vwImage.contentMode = .scaleToFill
                self.vwImage.cornerRadius = 15
                self.vwImage.selectedCorners(radius: 15, [.topLeft,.topRight,.bottomLeft,.bottomRight])
                self.vwBlur.isHidden = false
                self.view.layoutIfNeeded()
            })
            
        case .ended:
            UIView.animate(withDuration: 0.01, animations: { () -> Void in
                self.vwImage.alpha = 0
                self.vwImage.isHidden = true
//                self.vwImage.image = cell.imgviewZoom.image
                self.vwImage.sd_setImage(with: URL.init(string: data.image), placeholderImage: nil, options: .highPriority) { img, error, cache, url in
                }
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
    
    @objc func buttonBookmarkTravelAdvoiceClicked(sender:UIButton){
        if let section =  Int(sender.accessibilityHint ?? ""), let indexRow = arrayOfTravelAdvice.firstIndex(where: {$0.id == sender.tag}){ // get section
            if arrayOfTravelAdvice.indices.contains(indexRow){
                debugPrint("selected :\(arrayOfTravelAdvice[indexRow].title)")
                if self.arrayOfTravelAdvice[indexRow].isSaved{
                    self.unSaveLocationAndTravelApi(id: arrayOfTravelAdvice[indexRow].id, key:"advice") {
                        sender.isSelected.toggle()
                        self.arrayOfTravelAdvice[indexRow].isSaved.toggle()
//                        self.detailTripDataModel?.advicesOfArrayOfDataModel[indexRow].isSaved.toggle()
//                        self.tblviewTrip.reloadSections(IndexSet(integer: section), with: .automatic)
//                        self.tblviewTrip.reloadData()
                    }
                }else{
                    self.saveTravelAdviceApi(id: arrayOfTravelAdvice[indexRow].id) {
                        sender.isSelected.toggle()
                        self.arrayOfTravelAdvice[indexRow].isSaved.toggle()
//                        self.detailTripDataModel?.advicesOfArrayOfDataModel[indexRow].isSaved.toggle()
//                        self.tblviewTrip.reloadSections(IndexSet(integer: section), with: .automatic)
//                        self.tblviewTrip.reloadData()
                    }
                }
            }
        }
    }
    
    @objc func buttonBookmarLocationkClicked(sender:UIButton){
        let indexRow = Int(sender.accessibilityHint ?? "") ?? 0
        switch arrayOfSections[sender.tag]{
        case .locationList(let array):
            if array.indices.contains(indexRow){
                debugPrint("locationList:\(array[indexRow])")
                if array[indexRow].isSaved{
                    self.unSaveLocationAndTravelApi(id: array[indexRow].id, key:"location") {
                        sender.isSelected.toggle()
                        array[indexRow].isSaved.toggle()
//                        self.detailTripDataModel?.locationList[indexRow].isSaved.toggle()
                    }
                }else{
                    self.saveLocationTripApi(id: array[indexRow].id) {
                        sender.isSelected.toggle()
                        array[indexRow].isSaved.toggle()
//                        self.detailTripDataModel?.locationList[indexRow].isSaved.toggle()
                    }
                }
            }
        default:break
        }
    }
}

// UITextFieldDelegate
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
extension TripDetailVC{
    func saveLocationTripApi(id:Int, success: (() -> ())? = nil){
        guard let userId = detailTripDataModel?.userCreatedTrip?.userId else {
            return
        }
        let strJson = JSON(["location": ["id":id],
                            "userId":userId,
                            "INTEREST_CATEGORY": "location"]).rawString(.utf8, options: .sortedKeys) ?? ""
        let param: [String: Any] = ["requestJson" : strJson]
        
        API_SERVICES.callAPI(param, path: .saveTrip, method: .post) { [weak self] dataResponce in
            self?.HIDE_CUSTOM_LOADER()
            guard let status = dataResponce?["status"]?.intValue, status == 200 else {
                return
            }
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
        guard let userId = detailTripDataModel?.userCreatedTrip?.userId else {
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
            NotificationCenter.default.post(name: NSNotification.Name.init(rawValue: "reloadSavedTripList"), object: nil)
            success?()
        }  internetFailure: {
            API_LOADER.HIDE_CUSTOM_LOADER()
            debugPrint("internetFailure")
        } failureInform: {
            self.HIDE_CUSTOM_LOADER()
        }
    }
    
    
    func unSaveLocationAndTravelApi(id:Int, key:String, success: (() -> ())? = nil){
        let strJson = JSON(["id":id,"INTEREST_CATEGORY": key]).rawString(.utf8, options: .sortedKeys) ?? ""
        let param: [String: Any] = ["requestJson" : strJson]
        API_SERVICES.callAPI(param, path: .unSaveTrip, method: .post) { [weak self] dataResponce in
            self?.HIDE_CUSTOM_LOADER()
            guard let status = dataResponce?["status"]?.intValue, status == 200 else {
                return
            }
            
            NotificationCenter.default.post(name: NSNotification.Name.init(rawValue: "reloadSavedTripList"), object: nil)
            success?()
        }  internetFailure: {
            API_LOADER.HIDE_CUSTOM_LOADER()
            debugPrint("internetFailure")
        } failureInform: {
            self.HIDE_CUSTOM_LOADER()
        }
    }

}
