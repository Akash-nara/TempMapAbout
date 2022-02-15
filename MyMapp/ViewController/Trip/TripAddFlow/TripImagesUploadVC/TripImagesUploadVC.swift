//
//  TripImagesUploadVC.swift
//  MyMapp
//
//  Created by Chirag Pandya on 12/12/21.
//

import UIKit
import SwiftyJSON

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
    var selectedImageRow = -1
    var paramDict:[String:Any]? = nil
    var isPublicTrip:Bool = true{
        didSet{
            checkTripAddPrivateOrPublicButtonsTap()
        }
    }
    var keyForDafultImageSelected = ""
    
    //MARK: - VIEW DID LOAD
    override func viewDidLoad() {
        super.viewDidLoad()

        loadData()
        configureCollectionView()
        setPhotoCount()
    }
    
    func setPhotoCount(){
        self.labelImageUploadedCount.text = "\(self.arrayJsonFilterImages.count)" + "/\(totalGlobalTripPhotoCount)"
    }

    
    func loadData(){
        
        
        let example = NSAttributedString(string: "By submitting, you are making this trip public and adding it to your feed for other travelers to see!").withLineSpacing(0.5)
        labelSubmitingText.attributedText = example
        
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
                arrayJsonFilterImages.append(img)
            })
        }
        
        // deafult select first
        if arrayJsonFilterImages.count > 0{
            keyForDafultImageSelected = arrayJsonFilterImages.first?.keyToSubmitServer ?? ""
        }
        
        labelImageUploadedCount.text = "\(arrayJsonFilterImages.count)/\(totalGlobalTripPhotoCount)"
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
        cell.layoutIfNeeded()
        
        return cell
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
}
