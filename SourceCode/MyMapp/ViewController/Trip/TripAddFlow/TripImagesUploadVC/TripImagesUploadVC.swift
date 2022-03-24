//
//  TripImagesUploadVC.swift
//  MyMapp
//
//  Created by Chirag Pandya on 12/12/21.
//

import UIKit
import SwiftyJSON
import Photos
import DKImagePickerController

class TripImagesUploadVC: UIViewController {
    
    //MARK: - OUTLETS
    @IBOutlet weak var collectionviewPhotos:UICollectionView!
    @IBOutlet weak var subviewPopUp:UIView!
    @IBOutlet weak var labelDescription:UILabel!
    @IBOutlet weak var buttonBack:UIButton!
    @IBOutlet weak var labelTitle:UILabel!
    
    @IBOutlet weak var labelAddPhotoTitle:UILabel!
    @IBOutlet weak var labelImageUploadedCount:UILabel!
    
    @IBOutlet weak var buttonAddToFeed: UIButton!
    @IBOutlet weak var buttonMakePrivate: UIButton!
    @IBOutlet weak var labelSubmitingText: UILabel!
    @IBOutlet weak var viewContainerOfSubmitFeed: UIControl!
    
    var arrayOfImageUpload = [AddTripFavouriteLocationDetail?]()
    var arrayJsonFilterImages = [TripImagesModel]()
    //    var totalImage = 21
    var selectedImageRow = 0
    var paramDict:[String:Any]? = nil
    var isPublicTrip:Bool = true{
        didSet{
            checkTripAddPrivateOrPublicButtonsTap()
        }
    }
    var isEditFlow = false
    
   var keyForDafultImageSelected = ""
   var tripBucketHash = ""
   weak var objTripSecondVC:AddTripSecondStepVC? = nil
   private var locationLevelUploadCount = 0
    
    //MARK: - VIEW DID LOAD
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadData()
        configureCollectionView()
        setPhotoCount()
    }
    
    func setPhotoCount(){
//        self.labelImageUploadedCount.text = "\(self.arrayJsonFilterImages.count+locationLevelUploadCount)" + "/\(totalGlobalTripPhotoCount)"
//        self.labelImageUploadedCount.text = "\(totalGlobalTripPhotoCount)" + "/\(21)"
        let count = 21 - totalGlobalTripPhotoCount
        self.labelImageUploadedCount.text = "\(count < 0 ? 0 : totalGlobalTripPhotoCount)" + "/\(21)"
//        self.labelImageUploadedCount.text = "\(21 - totalGlobalTripPhotoCount)" + "/\(21)"
    }
    
    func loadData(){
        
        let tap = UITapGestureRecognizer.init(target: self, action: #selector(handleGetureOfAddPhotoLabel))
        tap.numberOfTapsRequired = 1
        labelAddPhotoTitle.addGestureRecognizer(tap)
        let example = NSAttributedString(string: "By submitting, you are making this trip public and adding it to your feed for other travelers to see!").withLineSpacing(0.5)
        labelSubmitingText.attributedText = example
        //
        labelSubmitingText.font = .Montserrat.Medium(16)
        labelSubmitingText.numberOfLines = 0
        labelSubmitingText.textAlignment = .center
        checkTripAddPrivateOrPublicButtonsTap()
        
        let gesture:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(controlPopUpBackgroundTap))
        gesture.numberOfTapsRequired = 1
        viewContainerOfSubmitFeed.isUserInteractionEnabled = true
        viewContainerOfSubmitFeed.addGestureRecognizer(gesture)
        hideAndShowSubmitPopUp(isHidden: true)
        
        arrayJsonFilterImages.removeAll()
        
        arrayOfImageUpload.forEach { objDetail in
            objDetail?.arrayOfImages.forEach({ img in
                img.statusUpload = .done
                locationLevelUploadCount += 1
                arrayJsonFilterImages.append(img)
            })
        }
        
        // deafult select first
        if arrayJsonFilterImages.count > 0{
            keyForDafultImageSelected = arrayJsonFilterImages.first?.keyToSubmitServer ?? ""
        }
        
        objTripSecondVC?.arrayCityLevelImageUpload.forEach({ imgModel in
            imgModel.statusUpload = .done
            arrayJsonFilterImages.append(imgModel)
        })
        setPhotoCount()
        
        if isEditFlow{
            buttonAddToFeed.setTitle("Update to feed")
        }
        labelImageUploadedCount.text = "\(arrayJsonFilterImages.count)/\(totalGlobalTripPhotoCount)"
    }
    
    @objc  func handleGetureOfAddPhotoLabel(){
        notifyDoneForImages()
    }
    
    func searchIndexOfdeleteLocationImage(image:String){
        guard let vc = objTripSecondVC else {
            return
        }
        
        for (index, obj) in vc.arrayOfTripLocationListData.enumerated(){
            if let imageIndex = obj?.arrayOfImages.firstIndex(where: {$0.keyToSubmitServer == image}){
                vc.arrayOfTripLocationListData[index]?.arrayOfImages.remove(at: imageIndex)
                self.paramDict = vc.preparedParams()
                debugPrint("location deleted image index:-\(imageIndex)")
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
//            alert.addAction(cameraAction)
            alert.addAction(galleryAction)
            alert.addAction(cancelAction)
            self.present(alert, animated: true, completion: nil)
        }
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
                    pickerController.view.backgroundColor = UIColor(red: 0.969, green: 0.969, blue: 0.969, alpha: 1.0)
                    pickerController.navigationBar.backgroundColor = UIColor(red: 0.969, green: 0.969, blue: 0.969, alpha: 1.0)

                    pickerController.didSelectAssets = { (assets: [DKAsset]) in
                        DispatchQueue.main.async {
                            if !assets.isEmpty {
                                self.addImageToOurArray(assets: assets)
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
    
    func addImageToOurArray(assets:[DKAsset]){
        let options = PHImageRequestOptions()
        options.deliveryMode = .highQualityFormat
        options.resizeMode = .none
        options.isSynchronous = true
        options.isNetworkAccessAllowed = true
        debugPrint(assets.count)
    
        for asset in assets {
            asset.fetchOriginalImage(options: options, completeBlock:  { (imageSelected, info) in DispatchQueue.main.async{
                let img  = UIImage(data: imageSelected!.jpeg(.highest)!)!
                img.accessibilityHint = "\(self.arrayJsonFilterImages.count)"
                let objectModel = TripImagesModel.init(image: img, type: "", url: "")
                let name = "Test-\(self.arrayJsonFilterImages.count).jpeg"
                let str:String = Routing.uploadTripImage.getPath+self.tripBucketHash+"/\(name)"
                objectModel.url = str
                objectModel.keyToSubmitServer = self.tripBucketHash+"/\(name)"
                objectModel.isCityUploadeImage = true
                objectModel.statusUpload = .notStarted
                objectModel.nameOfImage = name
                self.arrayJsonFilterImages.append(objectModel)
                self.objTripSecondVC?.arrayCityLevelImageUpload.append(objectModel)
                totalGlobalTripPhotoCount -= 1
                self.setPhotoCount()
            }
            })
        }
        
        DispatchQueue.getMain {
            if self.arrayJsonFilterImages.count > 0 {
                self.collectionviewPhotos.reloadData()
                self.setPhotoCount()
            }
        }
    }
    
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
            pickerController.view.backgroundColor = UIColor(red: 0.969, green: 0.969, blue: 0.969, alpha: 1.0)
            pickerController.navigationBar.backgroundColor = UIColor(red: 0.969, green: 0.969, blue: 0.969, alpha: 1.0)
            pickerController.didSelectAssets = { (assets: [DKAsset]) in
                DispatchQueue.main.async {
                    if !assets.isEmpty {
                        self.addImageToOurArray(assets: assets)
                    }
                }
            }
            self.present(pickerController, animated: true, completion: nil)
        }
    }
    
    func checkTripAddPrivateOrPublicButtonsTap(){
        
        if isPublicTrip == true{
            buttonMakePrivate.backgroundColor = UIColor.white
            buttonAddToFeed.backgroundColor = UIColor.App_BG_SeafoamBlue_Color
        }else if isPublicTrip == false{
            buttonMakePrivate.backgroundColor = UIColor.App_BG_SeafoamBlue_Color
            buttonAddToFeed.backgroundColor = UIColor.white
        }
        buttonMakePrivate.setTitleColor(UIColor.App_BG_SecondaryDark2_Color, for: .normal)
        buttonAddToFeed.setTitleColor(UIColor.App_BG_SecondaryDark2_Color, for: .normal)
    }
    
    func hideViewWithAnimation<T: UIView>(shouldHidden: Bool, objView: T) {
        if shouldHidden == true {
            UIView.animate(withDuration: 0.3, animations: {
                objView.alpha = 0
            }) { (finished) in
                objView.isHidden = shouldHidden
            }
        } else {
            objView.alpha = 0
            objView.isHidden = shouldHidden
            UIView.animate(withDuration: 0.3) {
                objView.alpha = 1
            }
        }
    }
    
    @IBAction func buttonCancelPopUp(sender:UIButton){
        hideAndShowSubmitPopUp(isHidden: true)
    }
    
    @objc func controlPopUpBackgroundTap(){
        hideAndShowSubmitPopUp(isHidden: true)
    }
    
    func hideAndShowSubmitPopUp(isHidden:Bool){
        hideViewWithAnimation(shouldHidden: isHidden, objView: viewContainerOfSubmitFeed)
    }
    
    func configureCollectionView(){
        collectionviewPhotos.register(UINib(nibName: "TripImagesUploadedCell", bundle: nil), forCellWithReuseIdentifier: "TripImagesUploadedCell")
        
        let layout = CHTCollectionViewWaterfallLayout()
        layout.minimumColumnSpacing = 15.0
        layout.minimumInteritemSpacing = 15.0
        layout.headerHeight = 0//CGSize(width: collectionviewProfile.frame.size.width, height: 420)
        self.collectionviewPhotos.collectionViewLayout = layout
        self.collectionviewPhotos.reloadData()
    }
    
    //MARK: - BUTTON ACTIONS
    @IBAction func btnHandlerback(sender:UIButton){
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnHandlerNext(sender:UIButton){
        hideAndShowSubmitPopUp(isHidden: false)
    }
    
    @IBAction func btnHandlerblackBG(sender:UIButton){
        hideAndShowSubmitPopUp(isHidden: true)
    }
    
    @IBAction func buttonSkipClicked(sender:UIButton){
        hideAndShowSubmitPopUp(isHidden: false)
    }
    
    @IBAction func buttonMakePrivateTapp(sender:UIButton){
        isPublicTrip = false
    }
    
    @IBAction func buttonAddToFeedTap(sender:UIButton){
        isPublicTrip = true
        if totalGlobalTripPhotoCount == 21{
            Utility.errorMessage(message: "Please select photo for trip")
            return
        }
        callUpdateTripApi()
    }
}

//MARK: - COLLECTIONVIEW METHODS
extension TripImagesUploadVC: UICollectionViewDataSource,UICollectionViewDelegate{
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrayJsonFilterImages.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionviewPhotos.dequeueReusableCell(withReuseIdentifier: "TripImagesUploadedCell", for: indexPath) as! TripImagesUploadedCell
        
        cell.loadCellData(objTripModel: self.arrayJsonFilterImages[indexPath.row])
        cell.imgTrip.tag = indexPath.row
        cell.buttonRadioSelection.tag = indexPath.row
        cell.buttonRadioSelection.addTarget(self, action: #selector(buttonRadioClicked), for: .touchUpInside)

        cell.buttonRadioSelection.setImage(UIImage.init(named: "ic_nonselected_purple"), for: .normal)
        cell.buttonRadioSelection.setImage(UIImage.init(named: "ic_selected_purple"), for: .selected)
        cell.buttonRadioSelection.isSelected = selectedImageRow == indexPath.row
        cell.buttonRadioSelection.tintColor = selectedImageRow == indexPath.row ? UIColor.RadioButtonPurpleColor : UIColor.App_BG_SecondaryDark2_Color
        cell.buttonRetry.isHidden = true
        cell.buttonRetry.addTarget(self, action: #selector(reloadUploadApi), for: .touchUpInside)
        cell.buttonRetry.tag = indexPath.row
        
        cell.layoutIfNeeded()
        
        
        func setLongGeture(){
            let longPress = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress(sender:)))
            longPress.accessibilityHint = "\(indexPath.row)"
            cell.addGestureRecognizer(longPress)
        }
        switch self.arrayJsonFilterImages[indexPath.row].statusUpload {
        case .notStarted:
            cell.buttonRadioSelection.isHidden = true
            self.arrayJsonFilterImages[indexPath.row].statusUpload = .progress
            cell.uploadImageApi1(bucketTripHash: self.tripBucketHash, imageToUpload: self.arrayJsonFilterImages[indexPath.row].image ?? UIImage(), name:self.arrayJsonFilterImages[indexPath.row].nameOfImage){
                
                DispatchQueue.getMain {
                    cell.stopAnimating()
                    if let ids = self.arrayJsonFilterImages[indexPath.row].image?.accessibilityHint, Int(ids) == indexPath.row{
                        setLongGeture()
                        cell.buttonRetry.isHidden = true
                        cell.buttonRadioSelection.isHidden = false
                        self.arrayJsonFilterImages[indexPath.row].statusUpload = .done
                        cell.imgTrip.image = (self.arrayJsonFilterImages[indexPath.row].image )
                    }
                }
            } failureCompletion: {
//                cell.stopAnimating()
                DispatchQueue.getMain {
                    if let ids = self.arrayJsonFilterImages[indexPath.row].image?.accessibilityHint, Int(ids) == indexPath.row{
                        self.arrayJsonFilterImages[indexPath.row].statusUpload = .fail
                        collectionView.reloadItems(at: [indexPath])
                    }
                }
            }
        case .done:
            setLongGeture()
            cell.buttonRetry.isHidden = true
            cell.buttonRadioSelection.isHidden = false
            
            if !self.arrayJsonFilterImages[indexPath.row].url.isEmpty && self.arrayJsonFilterImages[indexPath.row].isEdit{
                cell.startAnimating()
                cell.imgTrip.sd_setImage(with: URL.init(string: self.arrayJsonFilterImages[indexPath.row].url), placeholderImage: nil, options: .highPriority) { img, erro, cache, url in
                    if let image = img{
                        cell.stopAnimating()
                        cell.imgTrip.image = image
                    }
                }
            }else{
                cell.imgTrip.image = (self.arrayJsonFilterImages[indexPath.row].image)
            }
//            cell.imgTrip.image = (self.arrayJsonFilterImages[indexPath.row].image)
        case .fail:
            cell.startAnimating()
            cell.buttonRetry.isHidden = false
            cell.buttonRadioSelection.isHidden = true
        default:
            setLongGeture()
            cell.buttonRetry.isHidden = true
            cell.buttonRadioSelection.isHidden = false
            cell.imgTrip.image = (self.arrayJsonFilterImages[indexPath.row].image)
        }
        cell.imgTrip.contentMode = .scaleAspectFill
        return cell
    }
    
    @objc private func handleLongPress(sender: UILongPressGestureRecognizer) {
        let refreshAlert = UIAlertController(title: "Alert", message: "Are you sure want to delete this image?", preferredStyle: UIAlertController.Style.alert)

        refreshAlert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { (action: UIAlertAction!) in
            if let index = sender.accessibilityHint, let row = Int(index){
                if self.arrayJsonFilterImages[row].isCityUploadeImage{
                    self.deleteImageApi(index: row)
                }else{
                    self.deleteLocationFavouriteImageApi(index: row)
                }
            }
        }))

        refreshAlert.addAction(UIAlertAction(title: "No", style: .cancel, handler: { (action: UIAlertAction!) in
              print("Handle Cancel Logic here")
        }))
        present(refreshAlert, animated: true, completion: nil)

    }
    
    @objc func reloadUploadApi(_ sender:UIButton){
        if self.arrayJsonFilterImages[sender.tag].statusUpload == .fail{
            self.arrayJsonFilterImages[sender.tag].statusUpload = .notStarted
            collectionviewPhotos.reloadItems(at: [IndexPath.init(row: sender.tag, section: 0)])
        }
    }
    
    @objc func removeImage(sender:UIButton){
        deleteImageApi(index: sender.tag)
    }

    
    @objc func buttonRadioClicked(sender:UIButton){
        selectedImageRow = sender.tag
        debugPrint(arrayJsonFilterImages[sender.tag].keyToSubmitServer)
        keyForDafultImageSelected = arrayJsonFilterImages[sender.tag].keyToSubmitServer
        collectionviewPhotos.reloadData()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if arrayJsonFilterImages.indices.contains(indexPath.item){
            if arrayJsonFilterImages[indexPath.row].isVerticalImage{
                return CGSize(width: 155, height: 231)
            }else{
                return CGSize(width: 155, height: 140)
            }
        }else if self.arrayJsonFilterImages.count == 0{
            return CGSize(width: collectionView.frame.size.width, height: 80)
        }else{
            if indexPath.item % 2 == 0{
                return CGSize(width: 155, height: 231)
            }else{
                return CGSize(width: 155, height: 140)
            }
        }
    }
}

// CHTCollectionViewDelegateWaterfallLayout
extension TripImagesUploadVC: CHTCollectionViewDelegateWaterfallLayout {
    // here return total colum need to show
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, columnCountFor section: Int) -> Int {
        return 2
    }
}

extension  TripImagesUploadVC{
    func callUpdateTripApi(){
        guard var jsonDict = paramDict else {
            return
        }
        
        if !keyForDafultImageSelected.isEmpty{
            jsonDict["defaultImageKey"] = keyForDafultImageSelected
        }
        jsonDict["addToFeed"] = isPublicTrip
        let param: [String: Any] = ["requestJson" : jsonDict.json]
        API_SERVICES.callAPI(param, path: .updateCityTrip, method: .put) { [weak self] response in
            guard let status = response?["status"]?.intValue, status == 200, let msg = response?["msg"]?.stringValue else {
                Utility.errorMessage(message: response?["msg"]?.stringValue ?? "")
                return
            }
            totalGlobalTripPhotoCount = 21
            Utility.successMessage(message: msg)
            NotificationCenter.default.post(name: Notification.Name("reloadUserTripList"), object: nil)
            self?.navigationController?.popToRootViewController(animated: true)
        }
    }
    
    func deleteImageApi(index:Int){

        let name = self.arrayJsonFilterImages[index].nameOfImage
        let s3Key = tripBucketHash+"/"+name
        let s3Url = "https://mapabouts-trip-images.s3.amazonaws.com/"+s3Key
        var paramDict:[String:Any] = ["s3Key":s3Key,"s3Url":s3Url]
        
        if objTripSecondVC?.tripId != 0{
            paramDict["id"] = objTripSecondVC?.tripId ?? 0
        }
        
        let strJson = JSON(paramDict).rawString(.utf8, options: .sortedKeys) ?? ""
        let param: [String: Any] = ["requestJson" : strJson]
        
        API_SERVICES.callAPI(param, path: .deleteUploadedPhoto, method: .post) { [weak self] dict in

            let keyServerName = self?.arrayJsonFilterImages[index].keyToSubmitServer ?? ""
            if let indexofImage = self?.objTripSecondVC?.arrayCityLevelImageUpload.firstIndex(where: {$0.keyToSubmitServer == keyServerName}){
                self?.objTripSecondVC?.arrayCityLevelImageUpload.remove(at: indexofImage)
            }
            
            self?.arrayJsonFilterImages.remove(at: index)
            self?.changeDefaultImageKey(index: index)
            self?.collectionviewPhotos.reloadData()
            totalGlobalTripPhotoCount += 1
            self?.setPhotoCount()
        } failure: { str in
            debugPrint(str)
            self.collectionviewPhotos.reloadData()
        }
    }
    
    func changeDefaultImageKey(index:Int){
        if index == selectedImageRow, let key = arrayJsonFilterImages.first?.keyToSubmitServer{
            keyForDafultImageSelected = key
        }
    }
    
    func deleteLocationFavouriteImageApi(index:Int){
        /*{
         "id":3,
         "s3Key":"d0f30768-3bd2-42ac-8179-da36d0032bdc/1/sachin.jpeg",
         "s3Url":"https://mapabouts-trip-images.s3.amazonaws.com/01419ed7-17c2-42d4-91e6-cc04b95255d5/1/sachin.jpeg"
         }*/
        //https://mapabouts-trip-images.s3.amazonaws.com//c77b99a8-8333-4195-861f-1dcffc4447f8//OHCA9R//Test-1.jpe
        //https://mapabouts-trip-images.s3.amazonaws.com
        let name = self.arrayJsonFilterImages[index].nameOfImage
        let s3Key = self.arrayJsonFilterImages[index].keyToSubmitServer//tripBucketHash+"/"+locationBucketHash+"/"+name
        let s3Url = "https://mapabouts-trip-images.s3.amazonaws.com/"+s3Key
        var paramDict:[String:Any] = ["s3Key":s3Key,"s3Url":s3Url]
        
        if objTripSecondVC?.tripId != 0{
            paramDict["id"] = objTripSecondVC?.tripId ?? 0
        }
        
        let strJson = JSON(paramDict).rawString(.utf8, options: .sortedKeys) ?? ""
        let param: [String: Any] = ["requestJson" : strJson]
        
        API_SERVICES.callAPI(param, path: .deleteUploadedPhoto, method: .post) { [weak self] dict in
            debugPrint(dict)
            self?.searchIndexOfdeleteLocationImage(image: s3Key)
            self?.arrayJsonFilterImages.remove(at: index)
            self?.collectionviewPhotos.reloadData()
            totalGlobalTripPhotoCount += 1
            self?.setPhotoCount()
        } failure: { str in
            debugPrint(str)
            self.collectionviewPhotos.reloadData()
        }
    }
}
