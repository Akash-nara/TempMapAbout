//
//  TripPhotoExpansionDetailsVC.swift
//  MyMapp
//
//  Created by Chirag Pandya on 09/12/21.
//

import UIKit
import CHIPageControl
import TagListView
import CenteredCollectionView

class TripPhotoExpansionDetailsVC: UIViewController,TagListViewDelegate, UIScrollViewDelegate{
    
    //MARK: - OUTLETS
    @IBOutlet weak var tagListView: TagListView!
    @IBOutlet weak var collectionviewImages:UICollectionView!
    @IBOutlet weak var collectionviewHeight: NSLayoutConstraint!
    @IBOutlet weak var pageControllview: CHIPageControlPuya!
    @IBOutlet weak var labelTripName: UILabel!
    @IBOutlet weak var labelTripDescription: UILabel!
    @IBOutlet weak var buttonSaveUnSavedTrip: UIButton!
    
    //MARK: - VARIABLES
    var centeredCollectionViewFlowLayout: CenteredCollectionViewFlowLayout!
    var enumCurrentFlow:EnumTripPageFlow = .personal
    var tripDataModel:TripDataModel?
    private var arrayOfImageURL = [TripDataModel.TripPhotoDetails.TripImage]()
    private var arrayTagName = [String]()
    var isLcoationImage = false
    var imageName = ""
    
    
    
    //MARK: - VIEW DID LOAD
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        if enumCurrentFlow == .otherUser{}
        tagListView.isHidden = true
        configureTagsList()
        configureCollectionView()
        loadTripDetailData()
    }
    
    func loadTripDetailData(){
        if let obj = tripDataModel{
            
            if obj.userCreatedTrip?.userId == APP_USER?.userId{
                buttonSaveUnSavedTrip.isHidden = true
            }
            
            // image array
            obj.photoUploadedArray.forEach { obj in
                obj.arrayOfImageURL.forEach { obj1 in
                    arrayOfImageURL.append(obj1)
                }
            }
            pageControllview.numberOfPages = arrayOfImageURL.count
            collectionviewImages.reloadData()
            DispatchQueue.getMain {
                if let index = self.arrayOfImageURL.firstIndex(where: {$0.image == self.imageName}){
                    self.pageControllview.set(progress: index, animated: true)
                    //                    self.pageControll.currentPage = index
                    self.scrollToIndex(index: index)
                    //                    self.collectionviewImages.contentOffset = .zero
                }
            }
            loadDataBasedOnImageChange()
        }
    }
    
    func configureTagsList(){
        tagListView.delegate = self
        tagListView.textFont = UIFont.Montserrat.Medium(14)
        tagListView.alignment = .center
        tagListView.alignment = .left
        tagListView.delegate = self
        tagListView.enableRemoveButton = false
        tagListView.paddingX = 10
        tagListView.paddingY = 10
    }
    
    func configureCollectionView(){
        
        
        centeredCollectionViewFlowLayout = (self.collectionviewImages.collectionViewLayout as! CenteredCollectionViewFlowLayout)
        //        centeredCollectionViewFlowLayout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        
        self.collectionviewImages.decelerationRate = UIScrollView.DecelerationRate.fast
        
        centeredCollectionViewFlowLayout.itemSize = CGSize(
            width: (collectionviewImages.bounds.width) - 40,
            height: collectionviewImages.bounds.height
        )
        centeredCollectionViewFlowLayout.minimumLineSpacing = 0
        collectionviewImages.contentInset = UIEdgeInsets.init(top: 0, left: 20, bottom: 0, right: 20)
        
        pageControllview.tintColor = UIColor.getColorIntoHex(Hex: "d7dadd")
        pageControllview.currentPageTintColor = UIColor.black
        
        collectionviewHeight.constant = self.view.frame.width - 40
        
        collectionviewImages.register(UINib(nibName: "TripMainPageCollectionCell", bundle: nil), forCellWithReuseIdentifier: "TripMainPageCollectionCell")
        self.collectionviewImages.delegate = self
        self.collectionviewImages.dataSource = self
        collectionviewImages.reloadData()
    }
    
    func loadDataBasedOnImageChange(){
        guard let obj = tripDataModel else {
            return
        }
        
        tagListView.isHidden = true
        tagListView.removeAllTags()
        arrayTagName.removeAll()
        
        // location data
        if isLcoationImage{
            var hashLocaton = ""
            obj.photoUploadedArray.forEach { detailObj in
                detailObj.arrayOfImageURL.forEach { detailImageObj in
                    if detailImageObj.image == imageName{
                        hashLocaton = detailObj.hash
                    }
                }
            }
            
            // aaray of tag
            obj.locationList.forEach({ arrayTagName += $0.arrayTagsFeed })
            if arrayTagName.count > 0{
                tagListView.isHidden = false
                arrayTagName.forEach { str in
                    tagListView.addTag(str)
                }
            }
            
            if let index = obj.locationList.firstIndex(where: {$0.locationHash == hashLocaton}){
                labelTripName.text = obj.locationList[index].locationFav?.name
                labelTripDescription.text = obj.locationList[index].notes
                buttonSaveUnSavedTrip.isSelected = obj.locationList[index].isSaved
                buttonSaveUnSavedTrip.tag = obj.locationList[index].id
                buttonSaveUnSavedTrip.accessibilityHint = "location"
            }else{
                labelTripName.text = obj.city.cityName
                labelTripDescription.text = obj.tripDescription
                buttonSaveUnSavedTrip.isSelected = obj.isBookmarked
                buttonSaveUnSavedTrip.tag = obj.id
                buttonSaveUnSavedTrip.accessibilityHint = ""
            }
        }else{
            // cover data
            labelTripName.text = obj.city.cityName
            labelTripDescription.text = obj.tripDescription
            buttonSaveUnSavedTrip.isSelected = obj.isBookmarked
            buttonSaveUnSavedTrip.tag = obj.id
            buttonSaveUnSavedTrip.accessibilityHint = ""
        }
        
        labelTripDescription.isHidden = labelTripDescription.text!.isEmpty
    }
    
    func scrollToIndex(index:Int) {
        let rect = self.collectionviewImages.layoutAttributesForItem(at:IndexPath(row: index, section: 0))?.frame
        self.collectionviewImages.scrollRectToVisible(rect!, animated: false)
    }
    
    //MARK: - BUTTON ACTIONS
    @IBAction func btnHandlerback(sender: UIButton){
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func buttonSaveUnSave(_ sender: UIButton){
        let isLocationImage = (sender.accessibilityHint ?? "").isEmpty
    
        func updateStatusOfBookmark(){
            sender.isSelected.toggle()
            if isLocationImage{
                if let arrayOfLocation = self.tripDataModel?.locationList, let indexOfLocation =  arrayOfLocation.firstIndex(where: {$0.id == sender.tag}){
                    self.tripDataModel?.locationList[indexOfLocation].isSaved.toggle()
                }else{
                    self.tripDataModel?.isBookmarked.toggle()
                }
            }else{
                self.tripDataModel?.isBookmarked.toggle()
            }
        }
        
        if sender.isSelected{
            self.unSaveLocationAndTravelApi(id: sender.tag) {
                updateStatusOfBookmark()
            }
        }else{
            self.saveLocationTripApi(id: sender.tag) {
                updateStatusOfBookmark()
            }
        }
    }
    
    //MARK: - OTHER FUNCTIONS
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        print("Current centered index: \(String(describing: centeredCollectionViewFlowLayout.currentCenteredPage ?? nil))")
        self.pageControllview.progress = Double( centeredCollectionViewFlowLayout.currentCenteredPage ?? 0)
    }
    
    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        print("Current centered index: \(String(describing: centeredCollectionViewFlowLayout.currentCenteredPage ?? nil))")
        self.pageControllview.progress = Double( centeredCollectionViewFlowLayout.currentCenteredPage ?? 0)
    }
    
    func tagPressed(_ title: String, tagView: TagView, sender: TagListView) {
        print("Tag pressed: \(title), \(sender)")
        tagView.isSelected = !tagView.isSelected
    }
    
    func tagRemoveButtonPressed(_ title: String, tagView: TagView, sender: TagListView) {
        print("Tag Remove pressed: \(title), \(sender)")
        sender.removeTagView(tagView)
    }
}

//MARK: - COLLECTIONVIEW METHODS
extension TripPhotoExpansionDetailsVC:UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int{
        return arrayOfImageURL.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell{
        let cell = collectionviewImages.dequeueReusableCell(withReuseIdentifier: "TripMainPageCollectionCell", for: indexPath ) as! TripMainPageCollectionCell
        
        cell.viewBG.backgroundColor = .white
        cell.backgroundColor = .white
        cell.imgviewZoom.contentMode = .scaleToFill
        cell.imgviewZoom.sd_setImage(with: URL.init(string: arrayOfImageURL[indexPath.row].image), placeholderImage: nil, options: .highPriority) { img, error, cache, url in
            DispatchQueue.getMain {
                cell.imgviewZoom.layer.cornerRadius = 15.0
                cell.imgviewZoom.image = img?.withRoundedCorners(radius: 15)
                cell.imgviewZoom.image = cell.imgviewZoom.image?.drawOutlie()
            }
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        //        let Push = UIStoryboard.trip.instantiateViewController(withIdentifier: "LatestTripVC") as! LatestTripVC
        //        self.navigationController?.pushViewController(Push, animated: true)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let xPoint = (scrollView.contentOffset.x + scrollView.frame.width / 2)
        let yPoint = scrollView.frame.height / 2
        let center = CGPoint(x: xPoint, y: yPoint)
        if let indexpath = collectionviewImages.indexPathForItem(at: center) {
            self.isLcoationImage = arrayOfImageURL[indexpath.row].isLocationImage
            self.imageName = arrayOfImageURL[indexpath.row].image
            loadDataBasedOnImageChange()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize.init(width: collectionviewImages.frame.width - 40, height: collectionviewImages.bounds.height)
    }
}

extension TripPhotoExpansionDetailsVC{
    func saveLocationTripApi(id:Int, success: (() -> ())? = nil){
        
        guard let userId = tripDataModel?.userCreatedTrip?.userId else {
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
    
    func unSaveLocationAndTravelApi(id:Int, success: (() -> ())? = nil){
        let strJson = JSON(["id":id]).rawString(.utf8, options: .sortedKeys) ?? ""
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
