//
//  AddTripFavouriteLocationsVC.swift
//  MyMapp
//
//  Created by Chirag Pandya on 13/11/21.
//

import UIKit
import BottomPopup
import IQKeyboardManagerSwift
import DKImagePickerController
import CropViewController
import Photos
import Alamofire

class TripTags{
    var dict = [Int:[Int]]()
    var id = 0
    var subIdArrray = [SubCategoryListModel]()
    init() {
    }
}

class AddTripFavouriteLocationsVC: BottomPopupViewController, BottomPopupDelegate, UITextViewDelegate{
    
    //MARK: - OUTLETS
    @IBOutlet weak var lblCount: UILabel!
    @IBOutlet weak var btnTitleSubmit: UIButton!
    @IBOutlet weak var collectionViewPhotos: UICollectionView!
    @IBOutlet weak var txtviewNotes: IQTextView!
    @IBOutlet weak var viewNotes: UIView!
    @IBOutlet weak var collectionviewSecond: UICollectionView!
    @IBOutlet weak var collectionviewFirst: UICollectionView!
    
    @IBOutlet weak var buttonYesRecomandation: UIButton!
    @IBOutlet weak var buttonNoRecomandation: UIButton!
    @IBOutlet weak var labelRecomandationTitle: UILabel!
    
    //MARK: - VARIABLES
    var height: CGFloat?
    var topCornerRadius: CGFloat?
    var presentDuration: Double?
    var dismissDuration: Double?
    var shouldDismissInteractivelty: Bool?
    var customNavigationController: UINavigationController?
    var activeIndexOfParenttag = -1
    var activeIndexOfChildTag = -1
    var tripImages = [TripImagesModel]()
    var isRecomandationYesorNot:Bool? = nil{
        didSet{
            checkRecomandationButtonsTap()
        }
    }
    var arrayOfTags = [TripTags]()
    
    let mainHeight = UIScreen.main.bounds.size.height -  150//700
    let mainSubHeight = UIScreen.main.bounds.size.height -  200//700
    
    override var popupHeight: CGFloat { return height ?? CGFloat(mainHeight) }
    override var popupTopCornerRadius: CGFloat { return topCornerRadius ?? CGFloat(10) }
    override var popupPresentDuration: Double { return presentDuration ?? 1.0 }
    override var popupDismissDuration: Double { return dismissDuration ?? 1.0 }
    override var popupShouldDismissInteractivelty: Bool { return shouldDismissInteractivelty ?? true }
    
//    var newImageAllowed = 21
    var selectedAddTripFavouriteLocationDetail: AddTripFavouriteLocationDetail?
    var selectedTripDetailCallBackBlock: ((AddTripFavouriteLocationDetail?) -> Void)?
    var tripBucketHash = ""
    var locationBucketHash = ""
    var tripId = 0
    var arrayTagCopied = [TagListModel]()
    var arrayParentIDs = [Int]()
    var arrayChildIDs = [Int]()

    
    //MARK: - VIEW DID LOAD
    override func viewDidLoad() {
        super.viewDidLoad()
                
        if #available(iOS 15, *) {
            let appearance = UINavigationBarAppearance()
            appearance.configureWithOpaqueBackground()
            appearance.titleTextAttributes = [.foregroundColor: UIColor.white]
            appearance.backgroundColor = .white
            UINavigationBar.appearance().standardAppearance = appearance
            UINavigationBar.appearance().scrollEdgeAppearance = appearance
        }
        
        self.txtviewNotes.delegate = self
        txtviewNotes.tintColor = .App_BG_SeafoamBlue_Color
        self.popupDelegate = self
        
        self.viewNotes.layer.borderColor = UIColor.App_BG_Textfield_Unselected_Border_Color.cgColor
        self.txtviewNotes.placeholder = "A bit pricy but worth it! Try the cheeseburger"
        
        self.arrayTagCopied = appDelegateShared.tagsData
        
        checkRecomandationButtonsTap()
        configureCollectionView()
        loadEditData()
        setPhotoCount()
    }
    
    func bottomPopupWillDismiss() {
        submiteData()
        debugPrint("bottomPopupDidDismiss")
    }
    
    func checkRecomandationButtonsTap(){
        
        if isRecomandationYesorNot == true{
            buttonNoRecomandation.backgroundColor = UIColor.App_BG_App_BG_colorsNeutralLightDark2
            buttonYesRecomandation.backgroundColor = UIColor.App_BG_SeafoamBlue_Color
        }else if isRecomandationYesorNot == false{
            buttonNoRecomandation.backgroundColor = UIColor.App_BG_SeafoamBlue_Color
            buttonYesRecomandation.backgroundColor = UIColor.App_BG_App_BG_colorsNeutralLightDark2
        }else{
            buttonNoRecomandation.backgroundColor = UIColor.App_BG_App_BG_colorsNeutralLightDark2
            buttonYesRecomandation.backgroundColor = UIColor.App_BG_App_BG_colorsNeutralLightDark2
        }
        
        buttonYesRecomandation.setTitleColor(UIColor.App_BG_SecondaryDark2_Color, for: .normal)
        buttonNoRecomandation.setTitleColor(UIColor.App_BG_SecondaryDark2_Color, for: .normal)
    }
    
    func configureCollectionView(){
        collectionviewFirst.register(UINib(nibName: "LocationDescriptionCell", bundle: nil), forCellWithReuseIdentifier: "LocationDescriptionCell")
        collectionviewSecond.register(UINib(nibName: "LocationDescriptionCell", bundle: nil), forCellWithReuseIdentifier: "LocationDescriptionCell")
        collectionViewPhotos.register(UINib(nibName: "AddTripFavouriteAddImage", bundle: nil), forCellWithReuseIdentifier: "AddTripFavouriteAddImage")
        collectionViewPhotos.showsHorizontalScrollIndicator = false
        collectionviewSecond.isHidden = true
        
        self.collectionViewPhotos.register(UINib(nibName: "AddTripFavouriteImageHeader", bundle: nil), forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "AddTripFavouriteImageHeader")
        
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.headerReferenceSize = CGSize(width: tripImages.count == 0 ? 50 : 60, height: 85)
        self.collectionViewPhotos.collectionViewLayout = layout
    }
    
    func setPhotoCount(){
        self.lblCount.text = "\(self.tripImages.count)" + "/\(totalGlobalTripPhotoCount)"
    }
    
    func loadEditData(){
        if let objDetail = selectedAddTripFavouriteLocationDetail{
            btnTitleSubmit.backgroundColor = .App_BG_SeafoamBlue_Color
            
            for (_, obj) in  objDetail.arrayOfImages.enumerated(){
                tripImages.append(obj)
            }
            self.collectionViewPhotos.reloadData()
            self.setPhotoCount()
            
            txtviewNotes.text = objDetail.notes
            let tagWithoutParen = (objDetail.firstTag ?? "").replacingOccurrences(of: "(", with: "").replacingOccurrences(of: ")", with: "")
            
            tagWithoutParen.components(separatedBy: ",").forEach { str in
                if let id = Int(str.trimSpace()){
                    arrayParentIDs.append(id)
                }
            }

            let tagWithoutChild = (objDetail.secondTag ?? "").replacingOccurrences(of: "(", with: "").replacingOccurrences(of: ")", with: "")

            tagWithoutChild.components(separatedBy: ",").forEach { str in
                if let id = Int(str.trimSpace()){
                    arrayChildIDs.append(id)
                }
            }

//            arrayParentIDs = objDetail.firstTag.components(separatedBy: ",").map({Int($0) ?? 0})
//            arrayChildIDs = objDetail.secondTag.components(separatedBy: ",").map({Int($0) ?? 0})
//            if let firstTagIndex = arrayTagCopied.firstIndex(where: {$0.name.lowercased() == objDetail.firstTag.lowercased()}){
//                self.activeIndexOfParenttag = firstTagIndex
//                if let indexOfSecondtag = arrayTagCopied[firstTagIndex].subTagsList.firstIndex(where: {$0.name.lowercased() == objDetail.secondTag.lowercased()}){
//                    self.activeIndexOfChildTag = indexOfSecondtag
//                }
//            }
            if let index = arrayTagCopied.firstIndex(where: {$0.id == arrayParentIDs.first}){
                self.activeIndexOfParenttag = index
                if arrayChildIDs.indices.contains(self.activeIndexOfParenttag){
                    //            if arrayTagCopied.indices.contains(self.activeIndexOfParenttag){
                    if arrayTagCopied[self.activeIndexOfParenttag].subTagsList.count > 0{
                        self.collectionviewSecond.isHidden = false
                    }
                }
            }
            
            self.collectionviewFirst.reloadData()
            self.collectionviewSecond.reloadData()
        }
    }
}

//MARK: - TextView
extension  AddTripFavouriteLocationsVC{
    func textViewDidChange(_ textView: UITextView) {
        if textView.text.count == 0{
            self.viewNotes.layer.borderColor = UIColor.App_BG_Textfield_Unselected_Border_Color.cgColor
        }else{
            self.viewNotes.layer.borderColor = UIColor.App_BG_SeafoamBlue_Color.cgColor
        }
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        let newText = (textView.text as NSString).replacingCharacters(in: range, with: text)
        let numberOfChars = newText.count
        print(numberOfChars)
        return numberOfChars < 300
    }
}

//MARK: - BUTTON ACTIONS
extension  AddTripFavouriteLocationsVC{
    @IBAction func btnHandlerSubmit(_ sender: Any){
        submiteData()
        self.dismiss(animated: true)
    }
    
    func submiteData(){
        /*
        if self.isSelectedFirstIndex == -1{
            Utility.errorMessage(message: "Please select a tag")
            return
        }
        
        if self.isSelctedSecondIndex == -1{
            Utility.errorMessage(message: "Please select second a tag")
            return
        }
        
        if self.txtviewNotes.text.isEmpty{
            Utility.errorMessage(message: "Please enter notes")
            return
        }*/
        
        let objAddTripFavouriteLocationDetail = AddTripFavouriteLocationDetail.init()
        objAddTripFavouriteLocationDetail.notes = txtviewNotes.text
        
//        if activeIndexOfParenttag > 0{
        if arrayParentIDs.count > 0{
            objAddTripFavouriteLocationDetail.firstTag = "(\(arrayParentIDs.map({String($0)}).joined(separator: ",")))"//arrayTagCopied[self.activeIndexOfParenttag].name
        }
        
        if arrayChildIDs.count > 0{
//        if activeIndexOfChildTag > 0 && activeIndexOfParenttag > 0{
            objAddTripFavouriteLocationDetail.secondTag = "(\(arrayChildIDs.map({String($0)}).joined(separator: ",")))" //arrayTagCopied[self.activeIndexOfParenttag].subTagsList[activeIndexOfChildTag].name!
        }
        
        let filterArrray = tripImages.filter({$0.statusUpload == .done})
        if filterArrray.count > 0{
            objAddTripFavouriteLocationDetail.arrayOfImages = filterArrray
        }else{
            totalGlobalTripPhotoCount += tripImages.filter({$0.statusUpload != .done}).count
        }
        
        if filterArrray.count == 0, activeIndexOfChildTag == -1 && activeIndexOfParenttag == -1, txtviewNotes.text.isEmpty, filterArrray.count == 0{
//            selectedAddTripFavouriteLocationDetail?.notes = txtviewNotes.text
            selectedAddTripFavouriteLocationDetail?.notes = ""
            selectedAddTripFavouriteLocationDetail?.isEdited = false
            selectedTripDetailCallBackBlock?(selectedAddTripFavouriteLocationDetail)
            
        }else{
            objAddTripFavouriteLocationDetail.locationFav = selectedAddTripFavouriteLocationDetail?.locationFav
            objAddTripFavouriteLocationDetail.locationHash = selectedAddTripFavouriteLocationDetail?.locationHash ?? ""
            objAddTripFavouriteLocationDetail.isEdited = true
            selectedTripDetailCallBackBlock?(objAddTripFavouriteLocationDetail)
        }

    }
    @IBAction func btnYesRecoamndation(_ sender: UIButton){
        isRecomandationYesorNot = true
    }
    
    @IBAction func btnNoRecoamndation(_ sender: UIButton){
        isRecomandationYesorNot = false
    }
    
    @objc func removeImage(sender:UIButton){
        deleteImageApi(index: sender.tag)
    }
}

//MARK: - Open Gallery flow
extension AddTripFavouriteLocationsVC{
    
    
    @objc func buttonAddImageAction(sender:UIButton){
        if self.tripImages.count >= 22{
            Utility.errorMessage(message: LocalValidation.maximumPhotos)
            return
        }
        
        let alert = UIAlertController(title: "Choose Image", message: nil, preferredStyle: .actionSheet)
        let cameraAction = UIAlertAction(title: "Camera", style: .default){
            UIAlertAction in
            DispatchQueue.main.async {
                self.cameraAuthorization()
            }
        }
        let galleryAction = UIAlertAction(title: "Gallery", style: .default){
            UIAlertAction in
            self.openGallery()
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel){
            UIAlertAction in
        }
        
        // Add the actions
        alert.view.tintColor = UIColor.black
        alert.addAction(cameraAction)
        alert.addAction(galleryAction)
        alert.addAction(cancelAction)
        self.present(alert, animated: true, completion: nil)
    }
    
    func cameraAuthorization() {
        
        let authStatus = AVCaptureDevice.authorizationStatus(for: AVMediaType.video)
        switch (authStatus){
            
        case .restricted, .denied:
            self.showPermisionAlert(type: "Camera")
        case .authorized:
            self.cameraOpen()
        case .notDetermined:
            print("notDetermined")
            AVCaptureDevice.requestAccess(for: .video, completionHandler: { (granted: Bool) in
                if granted {
                    //access allowed
                    self.cameraOpen()
                } else {
                    //access denied
                    self.cameraAuthorization()
                }
            })
        @unknown default:
            print("notDetermined")
        }
    }
    
    func openGalleryForMultipleImages(isCameraOpen:Bool=false) {
        DispatchQueue.main.async {
            
            if totalGlobalTripPhotoCount == 0 {
                Utility.errorMessage(message: "Maximum 21 imagess allowed.")
                return;
            }
            
            let pickerController = DKImagePickerController()
            pickerController.assetType = .allPhotos
            pickerController.sourceType = .photo
            pickerController.singleSelect = false
            pickerController.maxSelectableCount = totalGlobalTripPhotoCount
            pickerController.UIDelegate = CustomUIDelegate()
            pickerController.autoCloseOnSingleSelect = true
            pickerController.showsEmptyAlbums = false
            pickerController.showsCancelButton = true
            pickerController.modalPresentationStyle = .fullScreen
            
            pickerController.didSelectAssets = { (assets: [DKAsset]) in
                DispatchQueue.main.async {
                    if !assets.isEmpty {
                        
                        let options = PHImageRequestOptions()
                        options.deliveryMode = .highQualityFormat
                        options.resizeMode = .none
                        options.isSynchronous = true
                        options.isNetworkAccessAllowed = true
                        print(assets.count)
                        for asset in assets {
                            asset.fetchOriginalImage(options: options, completeBlock:  { (imageSelected, info) in
                                
                                let img  = UIImage(data: imageSelected!.jpeg(.highest)!)!
                                img.accessibilityHint = "\(self.tripImages.count)"
                                
                                let name = "Test-\(self.tripImages.count).jpeg"
                                let objTripImagesModel = TripImagesModel.init(image: img, type: "", url: "")
                                objTripImagesModel.statusUpload = .notStarted
                                let str:String = Routing.uploadTripImage.getPath+self.tripBucketHash+"/"+self.locationBucketHash+"/\(name)"
                                objTripImagesModel.url = str
                                objTripImagesModel.keyToSubmitServer = self.tripBucketHash+"/"+self.locationBucketHash+"/\(name)"
                                objTripImagesModel.nameOfImage = name
                                self.tripImages.append(objTripImagesModel)
                                totalGlobalTripPhotoCount -= 1
                                self.setPhotoCount()
                            })
                        }
                        
                        
                        if self.tripImages.count > 0 {
                            self.collectionViewPhotos.reloadData()
                            self.setPhotoCount()
                        }
                    }
                }
            }
            self.present(pickerController, animated: true) {}
        }
    }
    
    func cameraOpen() {
        DispatchQueue.main.async {
            if(UIImagePickerController .isSourceTypeAvailable(.camera)) {
                DispatchQueue.main.async {
                    if totalGlobalTripPhotoCount == 0 {
                        Utility.errorMessage(message: "Maximum 21 imagess allowed.")
                        return;
                    }
                    
                    let pickerController = DKImagePickerController()
                    pickerController.assetType = .allPhotos
                    pickerController.sourceType = .camera
                    pickerController.singleSelect = true
                    pickerController.maxSelectableCount = totalGlobalTripPhotoCount
                    pickerController.UIDelegate = CustomUIDelegate()
                    pickerController.modalPresentationStyle = .fullScreen
                    
                    pickerController.didSelectAssets = { (assets: [DKAsset]) in
                        DispatchQueue.main.async {
                            if !assets.isEmpty {
                                
                                let options = PHImageRequestOptions()
                                options.deliveryMode = .highQualityFormat
                                options.resizeMode = .none
                                options.isSynchronous = true
                                options.isNetworkAccessAllowed = true
                                print(assets.count)
                                for asset in assets {
                                    asset.fetchOriginalImage(options: options, completeBlock:  { (imageSelected, info) in DispatchQueue.main.async{
                                        
                                        var objectModel = TripImagesModel.init(image: UIImage(data: imageSelected!.jpeg(.highest)!)!, type: "", url: "")
                                        let name = "Test-\(self.tripImages.count).jpeg"
                                        let str:String = Routing.uploadTripImage.getPath+self.tripBucketHash+"/"+self.locationBucketHash+"/\(name)"
                                        objectModel.url = str
                                        objectModel.keyToSubmitServer = self.tripBucketHash+"/"+self.locationBucketHash+"/\(name)"
                                        objectModel.statusUpload = .notStarted
                                        self.tripImages.append(objectModel)
                                        totalGlobalTripPhotoCount -= 1
                                        self.setPhotoCount()
                                    }
                                    })
                                }

                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                                    if self.tripImages.count > 1 {
                                        self.collectionViewPhotos.reloadData()
                                        self.setPhotoCount()
                                    }
                                }
                                
                            }
                        }
                    }
                    self.present(pickerController, animated: true) {}
                }
            } else {
                //  showAlertWithTitleFromVC(vc: self, andMessage: "You don't have camera")
            }
        }
    }
    
    func openGallery(){
        PHPhotoLibrary.requestAuthorization { [weak self] result in
            guard let self = self else { return }
            if result == .authorized {
                DispatchQueue.main.async {
                    self.openGalleryForMultipleImages()
                }
            } else {
                DispatchQueue.main.async {
                    self.showPermisionAlert(type:"photo gallery")
                }
            }
        }
    }
    
    func notifyDoneForImages() {
        DispatchQueue.main.async {
            let alert = UIAlertController(title: "Choose Image", message: nil, preferredStyle: .actionSheet)
            let cameraAction = UIAlertAction(title: "Camera", style: .default){
                UIAlertAction in
                DispatchQueue.main.async {
                    self.cameraAuthorization()
                }
            }
            let galleryAction = UIAlertAction(title: "Gallery", style: .default){
                UIAlertAction in
                self.openGallery()
                
            }
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel){
                UIAlertAction in
            }
            
            // Add the actions
            alert.view.tintColor = UIColor.black
            alert.addAction(cameraAction)
            alert.addAction(galleryAction)
            alert.addAction(cancelAction)
            self.present(alert, animated: true, completion: nil)
        }
    }
}

//MARK: - COLLECTIONVIEW METHODS
extension AddTripFavouriteLocationsVC:UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int{
        switch collectionView{
        case self.collectionviewFirst:
            if arrayTagCopied.count > 0{
                return arrayTagCopied.count
            }else{
                return 0
            }
            
        case self.collectionviewSecond:
            if self.activeIndexOfParenttag == -1{
                return 0
            }else{
                if arrayTagCopied[self.activeIndexOfParenttag].subTagsList.count > 0{
                    return arrayTagCopied[self.activeIndexOfParenttag].subTagsList.count
                }else{
                    return 0
                }
            }
        default:
            return self.tripImages.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell{
        
        switch collectionView{
        case self.collectionviewFirst:
            let cell = collectionviewFirst.dequeueReusableCell(withReuseIdentifier: "LocationDescriptionCell", for: indexPath ) as! LocationDescriptionCell
            
//            if arrayOfTags.contains(where: {$0.id == arrayTagCopied[indexPath.row].id}){
//                cell.viewBG.backgroundColor = UIColor.App_BG_SeafoamBlue_Color
//            }else{
//                cell.viewBG.backgroundColor = UIColor.App_BG_App_BG_colorsNeutralLightDark2
//            }
            
            if arrayParentIDs.contains(arrayTagCopied[indexPath.row].id){
                cell.viewBG.backgroundColor = UIColor.App_BG_SeafoamBlue_Color
            }else{
                cell.viewBG.backgroundColor = UIColor.App_BG_App_BG_colorsNeutralLightDark2
            }
//
//            if arrayTagCopied[indexPath.row].isSelected{
//                cell.viewBG.backgroundColor = UIColor.App_BG_SeafoamBlue_Color
//            }else{
//                cell.viewBG.backgroundColor = UIColor.App_BG_App_BG_colorsNeutralLightDark2
//            }
            
            /*
            if self.isSelectedFirstIndex == indexPath.row{
                cell.viewBG.backgroundColor = UIColor.App_BG_SeafoamBlue_Color
            }else{
                cell.viewBG.backgroundColor = UIColor.App_BG_App_BG_colorsNeutralLightDark2
            }*/
            
            if arrayTagCopied.count > 0{
                cell.lblTItle.text = arrayTagCopied[indexPath.row].name!
            }
            return cell
            
        case self.collectionviewSecond:
            // sub tag list collection view
            let cell = collectionviewSecond.dequeueReusableCell(withReuseIdentifier: "LocationDescriptionCell", for: indexPath ) as! LocationDescriptionCell
            
            /*
            if self.isSelctedSecondIndex == indexPath.row{
                cell.viewBG.backgroundColor = UIColor.App_BG_SeafoamBlue_Color
            }else{
                cell.viewBG.backgroundColor = UIColor.App_BG_App_BG_colorsNeutralLightDark2
            }*/
            
            let currentId = arrayTagCopied[self.activeIndexOfParenttag].subTagsList[indexPath.row].id
            
//            if let indexParentId = arrayOfTags.firstIndex(where: {$0.id == arrayTagCopied[self.isSelectedFirstIndex].id}){
//                if arrayOfTags[indexParentId].subIdArrray.contains(where: {$0.id == currentId}){
//                    cell.viewBG.backgroundColor = UIColor.App_BG_SeafoamBlue_Color
//                }else{
//                    cell.viewBG.backgroundColor = UIColor.App_BG_App_BG_colorsNeutralLightDark2
//                }
//            }
            
            if self.activeIndexOfParenttag != -1{
                if arrayTagCopied[self.activeIndexOfParenttag].subTagsList.count > 0{
                    cell.lblTItle.text = arrayTagCopied[self.activeIndexOfParenttag].subTagsList[indexPath.row].name!
                }
            }
            
//            let firstObj = arrayOfTags.filter({$0.subIdArrray.contains(where: {$0 == })})
//            arrayOfTags.firstIndex(where: {$0.id == })
//            if let index = array{
//                cell.viewBG.backgroundColor = UIColor.App_BG_SeafoamBlue_Color
//            }else{
//                cell.viewBG.backgroundColor = UIColor.App_BG_App_BG_colorsNeutralLightDark2
//            }
        
            if arrayChildIDs.contains(arrayTagCopied[self.activeIndexOfParenttag].subTagsList[indexPath.row].id){
                cell.viewBG.backgroundColor = UIColor.App_BG_SeafoamBlue_Color
            }else{
                cell.viewBG.backgroundColor = UIColor.App_BG_App_BG_colorsNeutralLightDark2
            }
            
//            if arrayTagCopied[self.activeIndexOfParenttag].subTagsList[indexPath.row].isSelected{
//                cell.viewBG.backgroundColor = UIColor.App_BG_SeafoamBlue_Color
//            }else{
//                cell.viewBG.backgroundColor = UIColor.App_BG_App_BG_colorsNeutralLightDark2
//            }
            
            return cell
        default:
            
            // photo selected collection
            let cell = collectionViewPhotos.dequeueReusableCell(withReuseIdentifier: "AddTripFavouriteAddImage", for: indexPath ) as! AddTripFavouriteAddImage
            
            cell.btnTitleRemove.isHidden = true
            cell.tag = indexPath.row
            
            cell.btnTitleRemove.tag = indexPath.row
            cell.btnTitleRemove.addTarget(self, action: #selector(self.removeImage(sender:)), for: .touchUpInside)
            
            cell.reloadImageButton.isHidden = true
            cell.reloadImageButton.tag = indexPath.row
            cell.reloadImageButton.addTarget(self, action: #selector(reloadUploadApi(_:)), for: .touchUpInside)
            cell.btnTitleRemove.imageView?.setImageTintColor(.App_BG_SeafoamBlue_Color)

            switch self.tripImages[indexPath.row].statusUpload {
            case .notStarted:
                self.tripImages[indexPath.row].statusUpload = .progress
                cell.imgviewCity.backgroundColor = .black.withAlphaComponent(0.5)
                cell.btnTitleRemove.isHidden = true
                cell.reloadImageButton.isHidden = true
                cell.uploadImageApi1(bucketTripHash: self.tripBucketHash, locationBucketHash: self.locationBucketHash, imageToUpload: self.tripImages[indexPath.row].image ?? UIImage(), name:self.tripImages[indexPath.row].nameOfImage){
                    
                    DispatchQueue.getMain {
                        cell.activityIndicator.stopAnimating()
                        if let ids = self.tripImages[indexPath.row].image?.accessibilityHint, Int(ids) == indexPath.row{
                            self.tripImages[indexPath.row].statusUpload = .done
                            cell.imgviewCity.backgroundColor = .white
                            cell.imgviewCity.image = (self.tripImages[indexPath.row].image )
                            cell.btnTitleRemove.isHidden = false
                        }
                    }
                } failureCompletion: {
                    cell.activityIndicator.stopAnimating()
                    if let ids = self.tripImages[indexPath.row].image?.accessibilityHint, Int(ids) == indexPath.row{
                        self.tripImages[indexPath.row].statusUpload = .fail
                        collectionView.reloadItems(at: [indexPath])
                    }
                    cell.imgviewCity.backgroundColor = .black.withAlphaComponent(0.5)
                    cell.btnTitleRemove.isHidden = true
                    cell.reloadImageButton.isHidden = false
                }
                
            case .progress:
                cell.activityIndicator.startAnimating()
                cell.imgviewCity.backgroundColor = .black.withAlphaComponent(0.5)
                cell.btnTitleRemove.isHidden = true
                
            case .fail:
                cell.reloadImageButton.isHidden = false
                cell.imgviewCity.backgroundColor = .black.withAlphaComponent(0.5)
                cell.btnTitleRemove.isHidden = true
                
            case .done:
                cell.imgviewCity.backgroundColor = .white
                cell.btnTitleRemove.isHidden = false
                cell.reloadImageButton.isHidden = true
                cell.imgviewCity.image = (self.tripImages[indexPath.row].image)
            default:break
            }
            
            cell.imgviewCity.contentMode = .scaleToFill

//            if let sizeOfImage = (self.tripImages[indexPath.row].image )?.size, sizeOfImage.width > sizeOfImage.height{
//                cell.imgviewCity.contentMode = .scaleAspectFit
//                //since the width > height we may fit it and we'll have bands on top/bottom
//            } else {
//                cell.imgviewCity.contentMode = .scaleAspectFill
//                //width < height we fill it until width is taken up and clipped on top/bottom
//            }
            
            return cell
        }
    }
    
    @objc func reloadUploadApi(_ sender:UIButton){
        if self.tripImages[sender.tag].statusUpload == .fail{
            self.tripImages[sender.tag].statusUpload = .notStarted
            collectionViewPhotos.reloadItems(at: [IndexPath.init(row: sender.tag, section: 0)])
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        
        if collectionView == self.collectionViewPhotos{
            return UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
        }else{
            return UIEdgeInsets(top: 2, left: 2, bottom: 2, right: 2)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if collectionView == self.collectionviewFirst{
            let label = UILabel(frame: CGRect.zero)
            label.text = arrayTagCopied[indexPath.row].name!
            label.sizeToFit()
            return CGSize(width: label.frame.width + 30, height: 40)
        }else if collectionView == self.collectionviewSecond{
            let label = UILabel(frame: CGRect.zero)
            label.text = arrayTagCopied[self.activeIndexOfParenttag].subTagsList[indexPath.row].name!
            label.sizeToFit()
            return CGSize(width: label.frame.width + 30, height: 40)
        }else{
            return CGSize(width: 95, height: 85 )
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if collectionView == self.collectionviewFirst{
                    
//            arrayChildIDs.forEach { id in
//                if var indexId = arrayTagCopied[activeIndexOfParenttag].subTagsList.first(where: {$0.id == id}), !arrayTagCopied[activeIndexOfParenttag].subTagsList.contains(indexId){
//                    indexId.isSelected = true
//                    arrayTagCopied[activeIndexOfParenttag].subTagsList.insert(indexId, at: 0)
//                }
//            }

//            if !arrayOfTags.contains(where: {$0.id == arrayTagCopied[indexPath.row].id}){
//                let obj = TripTags()
//                obj.id = arrayTagCopied[indexPath.row].id
//                arrayOfTags.append(obj)
//                arrayTagCopied[indexPath.row].isSelected = true
//            }else if let index = arrayOfTags.firstIndex(where: {$0.id == arrayTagCopied[indexPath.row].id}){
//                debugPrint("parent remove with id :\(index)")
//                arrayOfTags.remove(at: index)
//                self.collectionviewSecond.isHidden = true
//                arrayTagCopied[indexPath.row].isSelected = false
//            }else{
//                self.collectionviewSecond.isHidden = true
//            }
            guard let currentParentId = arrayTagCopied[indexPath.row].id else {
                return
            }
            
            // check contain parent
            if arrayParentIDs.contains(currentParentId){
                
                if let index = arrayParentIDs.firstIndex(where: {$0 == currentParentId}){
                    arrayParentIDs.remove(at: index)
                    
                    let getIds = arrayTagCopied[indexPath.row].subTagsList.map({$0.id})
                    
                    for (_, id) in getIds.enumerated(){
                        if let idOfChild = id, arrayChildIDs.contains(idOfChild){
                            arrayChildIDs.removeAll(where:{$0 == idOfChild})
                        }
                    }
                }
                
                // hide second tag child
                activeIndexOfParenttag = -1
                collectionviewSecond.isHidden = true
                collectionviewSecond.reloadData()
                collectionviewFirst.reloadData()
                self.updatePopupHeight(to: mainSubHeight)
            }else{
                // append id of parent tag
                arrayParentIDs.append(currentParentId)
            }
            
//            arrayTagCopied[indexPath.row].isSelected.toggle()
//            if !arrayTagCopied[indexPath.row].isSelected{
//                arrayTagCopied[indexPath.row].subTagsList.forEach { subTag in
//                    subTag.isSelected = false
//                }
//            }
            
            
//            arrayTagCopied.sort{ $0.isSelected && !$1.isSelected }

            if let index = arrayTagCopied.firstIndex(where: {$0.id == currentParentId}){
                self.activeIndexOfParenttag = index
            }

//            arrayTagCopied[indexPath.row].isSelected.toggle()
            self.collectionviewSecond.isHidden = true
            self.collectionviewFirst.reloadData()
            self.collectionviewSecond.reloadData()

            if arrayTagCopied.indices.contains(self.activeIndexOfParenttag){
                if arrayTagCopied[self.activeIndexOfParenttag].subTagsList.count > 0{
                    self.collectionviewSecond.isHidden = false
                    self.updatePopupHeight(to: mainSubHeight)
                }
            }

            /*
            if self.isSelectedFirstIndex == -1{
                
                self.isSelectedFirstIndex = indexPath.row
                self.collectionviewSecond.isHidden = false
                self.collectionviewFirst.reloadData()
                self.collectionviewSecond.reloadData()
                
                if arrayTagCopied.indices.contains(self.isSelectedFirstIndex){
                    if arrayTagCopied[self.isSelectedFirstIndex].subTagsList.count > 0{
                        self.collectionviewSecond.isHidden = false
                        self.updatePopupHeight(to: mainSubHeight)
                    }
                }
            }else{
                if self.isSelectedFirstIndex == indexPath.row{
                    self.isSelectedFirstIndex = -1
                    self.isSelctedSecondIndex = -1
                    self.collectionviewFirst.reloadData()
                    self.collectionviewSecond.isHidden = true
                    self.collectionviewSecond.reloadData()
                    
                    self.updatePopupHeight(to: mainHeight)
                    if arrayTagCopied.indices.contains(self.isSelectedFirstIndex){
                        if arrayTagCopied[self.isSelectedFirstIndex].subTagsList.count > 0{
                            self.collectionviewSecond.isHidden = false
                            self.updatePopupHeight(to: mainSubHeight)
                            
                        }
                    }
                }else{
                    self.isSelctedSecondIndex = -1
                    self.isSelectedFirstIndex = indexPath.row
                    self.collectionviewFirst.reloadData()
                    self.collectionviewSecond.isHidden = false
                    self.collectionviewSecond.reloadData()
                    
                    if arrayTagCopied.indices.contains(self.isSelectedFirstIndex){
                        if arrayTagCopied[self.isSelectedFirstIndex].subTagsList.count > 0{
                            self.collectionviewSecond.isHidden = false
                            self.updatePopupHeight(to: mainSubHeight)
                        }
                    }
                }
            }
             */
        }else if collectionView == self.collectionviewSecond{
            
            self.activeIndexOfChildTag = indexPath.row
            let parentTagId = arrayTagCopied[self.activeIndexOfParenttag].id
            let childTagId = arrayTagCopied[self.activeIndexOfParenttag].subTagsList[indexPath.row].id
            
            
            if arrayChildIDs.contains(childTagId ?? 0){
                if let index = arrayChildIDs.firstIndex(where: {$0 == childTagId}){
                    arrayChildIDs.remove(at: index)
                }
            }else if let childId = childTagId{
                arrayChildIDs.append(childId)
            }
            
            if let index = arrayChildIDs.firstIndex(where: {$0 == childTagId}){
                self.activeIndexOfChildTag = index
            }

//            if let index = arrayOfTags.firstIndex(where: {$0.id == parentTagId}), !arrayOfTags[index].subIdArrray.contains(where: {$0.id == childTagId}){
//
//                debugPrint("child add with id :\(childTagId)")
//                arrayOfTags[index].subIdArrray.append(arrayTagCopied[self.isSelectedFirstIndex].subTagsList[indexPath.row])
//
//                arrayTagCopied[self.isSelectedFirstIndex].subTagsList[indexPath.row].isSelected = true
//            }else if let parentIndex = arrayOfTags.firstIndex(where: {$0.id == parentTagId}),
//                     let childIndex = arrayOfTags[parentIndex].subIdArrray.firstIndex(where: {$0.id == childTagId}){
//                debugPrint("child remove with id :\(arrayOfTags[parentIndex].subIdArrray[childIndex])")
//                arrayOfTags[parentIndex].subIdArrray.remove(at: childIndex)
//                arrayTagCopied[self.isSelectedFirstIndex].subTagsList[indexPath.row].isSelected = false
//            }
//            arrayTagCopied[self.activeIndexOfParenttag].subTagsList[indexPath.row].isSelected.toggle()
            
//            arrayTagCopied.sort{ $0.subTagsList.sorted(by: {$0.isSelected  && !$1.isSelected})}
//    arrayTagCopied.sort{ $0.subTagsList.sorted(by: {$0.isSelected  && !$1.isSelected}) && !$1.subTagsList.sorted(by: {$0.isSelected  && !$1.isSelected}) }

//            arrayTagCopied.sorted(by: \.isSelected, <) /* using `<` for ascending sorting */
//            arrayTagCopied.sorted(by: \.subTagsList.sorted(by: \.isSelected.sor, <), <)
//            arrayTagCopied.forEach { obj in
//                obj.subTagsList.sort{ $0.isSelected && !$1.isSelected }
//            }

            /*
            if self.isSelctedSecondIndex == indexPath.row{
                self.isSelctedSecondIndex = -1
            }else{
                self.isSelctedSecondIndex = indexPath.row
            }*/
            
//            arrayChildIDs.forEach { id in
//                if var indexId = arrayTagCopied[activeIndexOfParenttag].subTagsList.first(where: {$0.id == id}), !arrayTagCopied[activeIndexOfParenttag].subTagsList.contains(indexId){
//                    indexId.isSelected = true
//                    arrayTagCopied[activeIndexOfParenttag].subTagsList.insert(indexId, at: 0)
//                }
//            }
            self.collectionviewSecond.reloadData()
        }
    }
    
    // declaring the header collection view
    func collectionView(_ collectionView: UICollectionView,
                        viewForSupplementaryElementOfKind kind: String, at indexPath:
                        IndexPath) -> UICollectionReusableView {
        let header =
        collectionView.dequeueReusableSupplementaryView(ofKind: kind,
                                                        withReuseIdentifier: "AddTripFavouriteImageHeader", for: indexPath) as! AddTripFavouriteImageHeader
        
        header.btnTitleAddImage.addTarget(self, action: #selector(self.buttonAddImageAction(sender:)), for: .touchUpInside)
        return header
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        if collectionView == collectionViewPhotos{
            return CGSize(width: tripImages.count == 0 ? 60 : 60, height: 85)
        }
        return .zero
    }
}

// MARK: - IMAGE PICKER METHODS
open class CustomUIDelegate: DKImagePickerControllerBaseUIDelegate {
    lazy var footer: UIToolbar = {
        let toolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 50))
        toolbar.isTranslucent = false
        toolbar.items = [
            UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil),
            UIBarButtonItem(customView: self.createDoneButtonIfNeeded()),
        ]
        self.updateDoneButtonTitle(self.createDoneButtonIfNeeded())
        
        return toolbar
    }()
    
    lazy var header: UIToolbar = {
        let header = UIToolbar(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 220))
        header.barTintColor = UIColor.red
        self.updateDoneButtonTitle(self.createDoneButtonIfNeeded())
        return header
    }()
    
    override open func createDoneButtonIfNeeded() -> UIButton {
        if self.doneButton == nil {
            let button = UIButton(type: .custom)
            //button.titleLabel?.font = UIFont(name: FontName.SemiBold.rawValue, size: 16)
            button.titleLabel?.font = UIFont.Montserrat.Medium(14)
            // button.setTitleColor(UIColor(red: 183 / 255.0, green: 65 / 255.0, blue: 14 / 255.0, alpha: 1.0), for: .normal)
            button.setTitleColor(UIColor.App_BG_SecondaryDark2_Color, for: .normal)
            button.setTitleColor(UIColor.App_BG_Textfield_Unselected_Border_Color, for: .disabled)
            button.addTarget(self.imagePickerController, action: #selector(DKImagePickerController.done), for: .touchUpInside)
            self.doneButton = button
        }
        return self.doneButton!
    }
    
    override open func prepareLayout(_ imagePickerController: DKImagePickerController, vc: UIViewController) {
        self.imagePickerController = imagePickerController
    }
    
    override open func imagePickerController(_ imagePickerController: DKImagePickerController,
                                             showsCancelButtonForVC vc: UIViewController) {
        vc.navigationItem.rightBarButtonItem?.tintColor = .white
        vc.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel,
                                                               target: imagePickerController,
                                                               action: #selector(imagePickerController.dismiss as () -> Void))
    }
    
    override open func imagePickerController(_ imagePickerController: DKImagePickerController,
                                             hidesCancelButtonForVC vc: UIViewController) {
        vc.navigationItem.rightBarButtonItem = nil
    }
    
    override open func imagePickerControllerHeaderView(_ imagePickerController: DKImagePickerController) -> UIView? {
        return nil
    }
    
    override open func imagePickerControllerFooterView(_ imagePickerController: DKImagePickerController) -> UIView? {
        return self.footer
    }
    
    override open func updateDoneButtonTitle(_ button: UIButton) {
        if self.imagePickerController.selectedAssets.count > 0 {
            button.setTitle(String(format: "Done (%d)", self.imagePickerController.selectedAssets.count), for: .normal)
            button.isEnabled = true
        } else {
            button.setTitle("Done", for: .normal)
            button.isEnabled = false
        }
        
        button.sizeToFit()
    }
    
    open override func imagePickerControllerCollectionImageCell() -> DKAssetGroupDetailBaseCell.Type {
        return CustomGroupDetailImageCell.self
    }
    
    open override func imagePickerControllerDidReachMaxLimit(_ imagePickerController: DKImagePickerController) {}
}

class CustomGroupDetailImageCell: DKAssetGroupDetailBaseCell {
    
    class override func cellReuseIdentifier() -> String {
        return "CustomGroupDetailImageCell"
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.thumbnailImageView.frame = self.bounds
        self.thumbnailImageView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.contentView.addSubview(self.thumbnailImageView)
        self.checkView.frame = self.bounds
        self.checkView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.contentView.addSubview(self.checkView)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override var thumbnailImage: UIImage? {
        didSet {
            self.thumbnailImageView.image = self.thumbnailImage
        }
    }
    
    internal lazy var _thumbnailImageView: UIImageView = {
        let thumbnailImageView = UIImageView()
        thumbnailImageView.contentMode = .scaleAspectFill
        thumbnailImageView.clipsToBounds = true
        
        return thumbnailImageView
    }()
    
    override var thumbnailImageView: UIImageView {
        get {
            return _thumbnailImageView
        }
    }
    
    fileprivate lazy var checkView: UIImageView = {
        let checkView = UIImageView(image: UIImage(named: "ic_selectGallery"))
        checkView.contentMode = .center
        //        checkView.tintColor = UIColor(red: 183 / 255.0, green: 65 / 255.0, blue: 14 / 255.0, alpha: 1.0)
        checkView.tintColor = UIColor.App_BG_SecondaryDark2_Color
        return checkView
    }()
    
    override var isSelected: Bool {
        didSet {
            if super.isSelected {
                self.thumbnailImageView.alpha = 0.3
                self.checkView.isHidden = false
            } else {
                self.thumbnailImageView.alpha = 1
                self.checkView.isHidden = true
            }
        }
    }
}

extension AddTripFavouriteLocationsVC {
    func showPermisionAlert(type: String) {
        
        let alert = UIAlertController(title: "", message: "Please allow your " + type, preferredStyle: .alert)
        let settingsAction = UIAlertAction(title: "Settings", style: .default) { (_) -> Void in
            
            guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else {
                return
            }
            
            if UIApplication.shared.canOpenURL(settingsUrl) {
                UIApplication.shared.open(settingsUrl, completionHandler: { (success) in
                    print("Settings opened: \(success)") // Prints true
                })
            }
        }
        
        alert.addAction(settingsAction)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    /*
    func uploadImageApi1(bucketTripHash:String, locationBucketHash:String, imageToUpload:UIImage, name:String, completion: ((String) -> Void)? = nil, failureCompletion: (() -> Void)? = nil){
        
        guard SSReachabilityManager.shared.isNetworkAvailable else {
            DispatchQueue.main.async {
                Utility.errorMessage(message: "No internet connection.")
                failureCompletion?()
            }
            return
        }
        
        guard let imageData = imageToUpload.jpegData(compressionQuality: 0.50), let url = URL.init(string: Routing.uploadTripImage.getPath+bucketTripHash+"/"+locationBucketHash+"/\(name)") else {
            return
        }
        
        //        "https://pv80m0iz3f.execute-api.us-east-1.amazonaws.com/dev/v1/d0f30768-3bd2-42ac-8179-da36d0032bdc/1"
        let headerAuth = (API_SERVICES.headerForNetworking["Authorization"] ?? "").replacingOccurrences(of: "Bearer ", with: "")
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "PUT"
        urlRequest.setValue("image/jpeg", forHTTPHeaderField: "Content-Type")
        urlRequest.setValue(headerAuth, forHTTPHeaderField: "Authorization")
        urlRequest.allowsCellularAccess = true
        urlRequest.allowsConstrainedNetworkAccess = true
        
        URLSession.shared.uploadTask(with: urlRequest, from: imageData, completionHandler: { responseData, response, error in
            
            DispatchQueue.global(qos: .userInitiated).async {
                guard let responseCode = (response as? HTTPURLResponse)?.statusCode, responseCode == 200  else {
                    if let error = error {
                        print(error)
                    }
                    debugPrint("failure image:- \(name)")
                    failureCompletion?()
                    return
                }
                debugPrint("status image Code:- \(name) \(responseCode)")
                // do your work
                completion?((response as? HTTPURLResponse)?.url?.lastPathComponent ?? "")
            }
        }).resume()
    }*/
    
    
    func deleteImageApi(index:Int){
        /*{
         "id":3,
         "s3Key":"d0f30768-3bd2-42ac-8179-da36d0032bdc/1/sachin.jpeg",
         "s3Url":"https://mapabouts-trip-images.s3.amazonaws.com/01419ed7-17c2-42d4-91e6-cc04b95255d5/1/sachin.jpeg"
         }*/
        //https://mapabouts-trip-images.s3.amazonaws.com//c77b99a8-8333-4195-861f-1dcffc4447f8//OHCA9R//Test-1.jpe
        //https://mapabouts-trip-images.s3.amazonaws.com
        let name = self.tripImages[index].nameOfImage
        let s3Key = tripBucketHash+"/"+locationBucketHash+"/"+name
        let s3Url = "https://mapabouts-trip-images.s3.amazonaws.com/"+s3Key
        var paramDict:[String:Any] = ["s3Key":s3Key,"s3Url":s3Url]
        
        if tripId != 0{
            paramDict["id"] = tripId
        }
        
        let strJson = JSON(paramDict).rawString(.utf8, options: .sortedKeys) ?? ""
        let param: [String: Any] = ["requestJson" : strJson]
        
        API_SERVICES.callAPI(param, path: .deleteUploadedPhoto, method: .post) { [weak self] dict in
            debugPrint(dict)
            self?.tripImages.remove(at: index)
            self?.collectionViewPhotos.reloadData()
            totalGlobalTripPhotoCount += 1
            self?.setPhotoCount()
        } failure: { str in
            debugPrint(str)
            self.collectionViewPhotos.reloadData()
        }
    }
}

extension AddTripFavouriteLocationsVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let chosenImage:UIImage = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
        picker.dismiss(animated: true, completion: nil)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
            let cropController:CropViewController = CropViewController(image: chosenImage)
            cropController.delegate = self
            cropController.aspectRatioPreset = .presetSquare
            cropController.aspectRatioLockEnabled = true
            cropController.aspectRatioPickerButtonHidden = true
            
            if #available(iOS 13.0, *) {
                cropController.modalPresentationStyle = .fullScreen
            }
            
            self.present(cropController, animated: true, completion: nil)
        }
    }
    
    @objc func imagePickerController(_ picker: UIImagePickerController, pickedImage: UIImage?) {}
}

// CropViewControllerDelegate
extension AddTripFavouriteLocationsVC : CropViewControllerDelegate {
    func cropViewController(_ cropViewController: CropViewController, didCropToImage image: UIImage, withRect cropRect: CGRect, angle: Int) {
        cropViewController.dismiss(animated: true, completion: {
        })
    }
}

extension Collection{
    func sorted<Value: Comparable>(
        by keyPath: KeyPath<Element, Value>,
        _ comparator: (_ lhs: Value, _ rhs: Value) -> Bool) -> [Element] {
        sorted { comparator($0[keyPath: keyPath], $1[keyPath: keyPath]) }
    }
}
