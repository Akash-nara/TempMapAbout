//
//  LatestTripVC.swift
//  MyMapp
//
//  Created by Chirag Pandya on 12/12/21.
//

import UIKit
import WaterfallLayout
import MapKit
import CoreLocation

class LatestTripVC: UIViewController {
    
    //MARK: - OUTLETS
    @IBOutlet weak var submitSubview:UIView!
    @IBOutlet weak var collectionviewTrip:UICollectionView!
    @IBOutlet weak var txtSearch:PaddingTextField!
    
    //MARK: - VIEW DID LOAD
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.txtSearch.layer.borderColor = UIColor.App_BG_Textfield_Unselected_Border_Color.cgColor
        
        collectionviewTrip.register(UINib(nibName: "ProfileImagesCellXIB", bundle: nil), forCellWithReuseIdentifier: "ProfileImagesCellXIB")
        
        collectionviewTrip.dataSource = self
        collectionviewTrip.dataSource = self
        let layout = CHTCollectionViewWaterfallLayout()
        layout.minimumColumnSpacing = 4.0
        layout.minimumInteritemSpacing = 4.0
        self.collectionviewTrip.collectionViewLayout = layout
        
        self.collectionviewTrip.reloadData()
    }
    
    //MARK: - BUTTON ACTIONS
    @IBAction func btnHandlerCloseSubview(sender:UIButton){
        self.submitSubview.removeFromSuperview()
    }
    
    @IBAction func btnHandlerSubmit(sender:UIButton){
        self.submitSubview.removeFromSuperview()
        let Push = UIStoryboard.trip.instantiateViewController(withIdentifier: "TripImagesUploadVC") as! TripImagesUploadVC
        self.navigationController?.pushViewController(Push, animated: true)
    }
    
    @IBAction func btnHandlerCreateNewTrip(sender:UIButton){
        self.submitSubview.removeFromSuperview()
        let Push = UIStoryboard.trip.instantiateViewController(withIdentifier: "TripImagesUploadVC") as! TripImagesUploadVC
        self.navigationController?.pushViewController(Push, animated: true)
    }
    
    @IBAction func btnHandlerBack(sender:UIButton){
        self.navigationController?.popViewController(animated: true)
    }
}

//MARK: - COLLECTIONVIEW METHODS
extension LatestTripVC: UICollectionViewDataSource, UICollectionViewDelegate{
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 30
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionviewTrip.dequeueReusableCell(withReuseIdentifier: "ProfileImagesCellXIB", for: indexPath) as! ProfileImagesCellXIB
        
        cell.btnTitleRemove.isHidden = true
        cell.btnAddimage.isHidden = true
        cell.layoutIfNeeded()
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.submitSubview.frame = self.view.frame
        self.view.addSubview(self.submitSubview)
    }
}

// CHTCollectionViewDelegateWaterfallLayout
extension LatestTripVC: CHTCollectionViewDelegateWaterfallLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let randomInt = Int.random(in: 1...100)
        if randomInt % 2 == 0{
            return CGSize(width: 155, height: 140)
        }else{
            return CGSize(width: 155, height: 231)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, columnCountFor section: Int) -> Int {
        return 2
    }
}
