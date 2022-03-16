//
//  AddTripStepVC.swift
//  MyMapp
//
//  Created by ZB_Mac_Mini on 18/11/21.
//

import UIKit
import WaterfallLayout
import BottomPopup
import IQKeyboardManagerSwift
import DKImagePickerController
import CropViewController
import Photos

//struct TripImagesModel {
//    
//    enum EnumUploadStatus:Equatable {
//        case none, progress, done
//    }
//    var image:UIImage
//    var type:String
//    var url:String
//    var isEdit:String
//    var statusUpload:EnumUploadStatus = .none
//    var nameOfImage = ""
//}

class AddTripStepVC: UIViewController,BottomPopupDelegate{
    
    enum cellTypeForCreateEvent: CaseIterable {
        case StartDate
        case EndDate
        case StartTime
        case EndTime
        case SetNotificationTime
        case Recurrence
        case InviteFriends
    }
    
    // MARK: - VARIABLES
    var isAllTravelers = Bool()
    var TripImages = [TripImagesModel]()
    var rowSelectedForroom = -1
    var newImageAllowed = 21
    var manager_Image = PHImageManager.default()
    var option_Image = PHImageRequestOptions()
    var picker = UIImagePickerController()
    var isForEdit = false
    var allCellTypeFields = cellTypeForCreateEvent.allCases
    
    //MARK: - OUTLETS
    @IBOutlet weak var imgviewMyFollowers: UIImageView!
    @IBOutlet weak var imgviewAllTravelers: UIImageView!
    @IBOutlet weak var viewRadio: UIView!
    @IBOutlet weak var btnTitleAddFeed: UIButton!
    @IBOutlet var viewPopUpSubview: UIView!
    @IBOutlet weak var CollectionviewPhotos: UICollectionView!
    @IBOutlet weak var viewNonRadio: UIView!
    @IBOutlet weak var lblCount : UILabel!
    
    
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
        
        option_Image.isSynchronous = true
        picker.delegate = self
        
        TripImages.removeAll()
        let Object = TripImagesModel.init(image: UIImage(), type: "last", url: "")
        TripImages.append(Object)
        self.CollectionviewPhotos.reloadData()
        self.lblCount.text = "\(self.TripImages.count - 1)" + "/21"
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1, execute: {
            self.btnTitleAddFeed.dropShadowButton()
        })
        
        isAllTravelers = false
        if self.isAllTravelers == true{
            self.imgviewAllTravelers.image = UIImage(named: "ic_selected_checkbox")
            self.imgviewMyFollowers.image = UIImage(named: "ic_unselected_checkbox")
        }else{
            self.imgviewAllTravelers.image = UIImage(named: "ic_unselected_checkbox")
            self.imgviewMyFollowers.image = UIImage(named: "ic_selected_checkbox")
        }
        
        CollectionviewPhotos.register(UINib(nibName: "ProfileImagesCellXIB", bundle: nil), forCellWithReuseIdentifier: "ProfileImagesCellXIB")
        CollectionviewPhotos.dataSource = self
        CollectionviewPhotos.dataSource = self
        let layout = CHTCollectionViewWaterfallLayout()
        layout.minimumColumnSpacing = 4.0
        layout.minimumInteritemSpacing = 4.0
        self.CollectionviewPhotos.collectionViewLayout = layout
        
        self.CollectionviewPhotos.reloadData()
    }
    
    //MARK: - OTHER FUNCTIONS
    func openGalleryForMultipleImages() {
        DispatchQueue.main.async {
            
            if self.newImageAllowed == 0 {
                // GeneralUtility().showErrorMessage(message: "Maximum 5 images allowed.")
                Utility.errorMessage(message: "Maximum 21 imagess allowed.")
                return;
            }
            
            let pickerController = DKImagePickerController()
            
            pickerController.assetType = .allPhotos
            pickerController.sourceType = .photo
            pickerController.singleSelect = false
            pickerController.maxSelectableCount = self.newImageAllowed
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
                            asset.fetchOriginalImage(options: options, completeBlock:  { (imageSelected, info) in DispatchQueue.main.async{
                                    
                                    let Object = TripImagesModel.init(image: UIImage(data: imageSelected!.jpeg(.highest)!)!, type: "image", url: "")
                                    self.TripImages.append(Object)
                                    self.newImageAllowed =  self.newImageAllowed - 1
                                }
                            })
                        }
                        
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                            if self.TripImages.count > 1 {
                                
                                self.CollectionviewPhotos.reloadData()
                                self.lblCount.text = "\(self.TripImages.count - 1)" + "/21"
                            }
                            
                        }
                        
                    }
                }
            }
            self.present(pickerController, animated: true) {}
        }
    }
    
    @objc func selectImage(sender:UIButton){
        if self.TripImages.count >= 22{
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
        
        /*
         if self.TripImages.count >= 22
         {
         Utility.errorMessage(message: LocalValidation.maximumPhotos)
         return
         }
         
         ImagePickerManager().pickImage(self){ image in
         
         let Object = TripImagesModel.init(image: image, type: "image", url: "", isEdit: "0")
         self.TripImages.append(Object)
         self.collectionViewPhotos.reloadData()
         self.lblCount.text = "\(self.TripImages.count - 1)" + "/21"
         }
         */
    }
    
    @objc func removeImage(sender:UIButton){
        self.newImageAllowed = self.newImageAllowed + 1
        self.TripImages.remove(at: sender.tag)
        self.CollectionviewPhotos.reloadData()
        self.lblCount.text = "\(self.TripImages.count - 1)" + "/21"
    }
    
    //MARK: - BUTTON ACTIONS
    @IBAction func btnHandlerOnlyMyFollowers(_ sender: Any){
        isAllTravelers = false
        self.imgviewAllTravelers.image = UIImage(named: "ic_unselected_checkbox")
        self.imgviewMyFollowers.image = UIImage(named: "ic_selected_checkbox")
    }
    
    @IBAction func btnHandlerAllTravelers(_ sender: Any){
        self.isAllTravelers = true
        self.imgviewAllTravelers.image = UIImage(named: "ic_selected_checkbox")
        self.imgviewMyFollowers.image = UIImage(named: "ic_unselected_checkbox")
    }
    
    @IBAction func btnHandlerBlackBGPopup(_ sender: Any){
        self.viewPopUpSubview.removeFromSuperview()
    }
    
    @IBAction func btnHandlerAddToFeed(_ sender: Any){
        if self.viewRadio.isHidden == true{
            self.viewNonRadio.isHidden = true
            self.viewRadio.isHidden = false
        }else{
            guard let TripAddedSuccessFullVC =  UIStoryboard.trip.tripAddedSuccessFullVC else {
                return
            }
            self.navigationController?.pushViewController(TripAddedSuccessFullVC, animated: true)
        }
    }
    
    @IBAction func btnHandlerMakePrivate(_ sender: Any){
        if self.viewRadio.isHidden == true{
            self.viewNonRadio.isHidden = true
            self.viewRadio.isHidden = false
        }else{
            guard let TripAddedSuccessFullVC =  UIStoryboard.trip.tripAddedSuccessFullVC else {
                return
            }
            self.navigationController?.pushViewController(TripAddedSuccessFullVC, animated: true)
        }
    }
    
    @IBAction func btnHandlerSubmit(_ sender: Any){
        self.viewPopUpSubview.frame = self.view.frame
        self.viewNonRadio.isHidden = false
        self.viewRadio.isHidden = true
        self.view.addSubview(self.viewPopUpSubview)
    }
    
    @IBAction func btnHandlerback(_ sender: Any){
        self.navigationController?.popViewController(animated: true)
    }
}

//MARK: - COLLECTIONVIEW METHODS
extension AddTripStepVC: UICollectionViewDataSource,UICollectionViewDelegate{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.TripImages.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = CollectionviewPhotos.dequeueReusableCell(withReuseIdentifier: "ProfileImagesCellXIB", for: indexPath) as! ProfileImagesCellXIB
        
        if self.TripImages[indexPath.row].type == "last"{
            cell.btnAddimage.isHidden = false
            cell.imgviewBG.isHidden = true
            cell.btnTitleRemove.isHidden = true
            
            cell.TopStackView.isHidden = true
            cell.BottomStackView.isHidden = true
//            cell.viewBG.isHidden = false
            //                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1, execute: {
            //
            //                    cell.viewBG.dropShadowButton()
            //                })
            
            cell.btnAddimage.tag = indexPath.row
            cell.btnAddimage.addTarget(self, action: #selector(self.selectImage(sender:)), for: .touchUpInside)
        }else{
            
            cell.TopStackView.isHidden = true
            cell.BottomStackView.isHidden = true
//            cell.viewBG.isHidden = true
            cell.btnAddimage.isHidden = true
            cell.imgviewBG.isHidden = false
            cell.btnTitleRemove.isHidden = false
            
            cell.btnAddimage.tag = indexPath.row
            cell.btnAddimage.addTarget(self, action: #selector(self.selectImage(sender:)), for: .touchUpInside)
            
            cell.btnTitleRemove.tag = indexPath.row
            cell.btnTitleRemove.addTarget(self, action: #selector(self.removeImage(sender:)), for: .touchUpInside)
            
            cell.imgviewBG.image = (self.TripImages[indexPath.row].image )
        }
        
        cell.layoutIfNeeded()
        return cell
    }
}

// CHTCollectionViewDelegateWaterfallLayout
extension AddTripStepVC: CHTCollectionViewDelegateWaterfallLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if self.TripImages.count == 1{
            return CGSize(width: self.CollectionviewPhotos.frame.width, height: self.CollectionviewPhotos.frame.height)
        }else{
            let randomInt = Int.random(in: 1...100)
            if randomInt % 2 == 0{
                return CGSize(width: 155, height: 140)
            }else{
                return CGSize(width: 155, height: 231)
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, columnCountFor section: Int) -> Int {
        if self.TripImages.count == 11{
            return 1
        }else{
            return 2
        }
    }
}

// NotifyForSelectImages
extension AddTripStepVC {
    func removeImage(row: Int) {}
    
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
                
                /*
                 DispatchQueue.main.async {
                 self.picker.sourceType = .camera
                 self.picker.allowsEditing = false
                 self.picker.modalPresentationStyle = .overFullScreen
                 self.present(self.picker, animated: true, completion: nil)
                 }
                 */
                
                DispatchQueue.main.async {
                    if self.newImageAllowed == 0 {
                        // GeneralUtility().showErrorMessage(message: "Maximum 5 images allowed.")
                        Utility.errorMessage(message: "Maximum 21 imagess allowed.")
                        return;
                    }
                    
                    let pickerController = DKImagePickerController()
                    pickerController.assetType = .allPhotos
                    pickerController.sourceType = .camera
                    pickerController.singleSelect = true
                    pickerController.maxSelectableCount = self.newImageAllowed
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
                                        
                                        let Object = TripImagesModel.init(image: UIImage(data: imageSelected!.jpeg(.highest)!)!, type: "image", url: "")
                                        self.TripImages.append(Object)
                                        self.newImageAllowed =  self.newImageAllowed - 1
                                        //self.CollectionviewPhotos.reloadData()
                                        
                                        //                                    let imageSelected : UIImage = UIImage(data: imageSelected!.jpeg(.highest)!)!
                                        //                                    let imageModel = EventImagesModel()
                                        //                                    imageModel.isOldImage = false
                                        //                                    imageModel.image = imageSelected
                                        //                                    self.dataForCreateEvent.product_gallery.append(imageModel)
                                        //                                    self.newImageAllowed =  self.newImageAllowed - 1
                                        //                                    print("resultObj:--- ",imageSelected.size)
                                    }
                                    })
                                }
                                
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                                    if self.TripImages.count > 1 {
                                        self.CollectionviewPhotos.reloadData()
                                        self.lblCount.text = "\(self.TripImages.count - 1)" + "/21"
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

extension AddTripStepVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
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
    
    @objc func imagePickerController(_ picker: UIImagePickerController, pickedImage: UIImage?) { }
}

// CropViewControllerDelegate
extension AddTripStepVC : CropViewControllerDelegate {
    func cropViewController(_ cropViewController: CropViewController, didCropToImage image: UIImage, withRect cropRect: CGRect, angle: Int) {
        cropViewController.dismiss(animated: true, completion: {
        })
    }
}



