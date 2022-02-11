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

class TripPhotoExpansionDetailsVC: UIViewController,TagListViewDelegate{
    
    //MARK: - OUTLETS
    @IBOutlet weak var tagListView: TagListView!
    @IBOutlet weak var collectionviewImages:UICollectionView!
    @IBOutlet weak var collectionviewHeight: NSLayoutConstraint!
    @IBOutlet weak var pageControllview: CHIPageControlPuya!
    
    //MARK: - VARIABLES
    var centeredCollectionViewFlowLayout: CenteredCollectionViewFlowLayout!
    let cellPercentWidth: CGFloat = 0.9
    var enumCurrentFlow:TripDetailVC.EnumTripPageFlow = .personal
    
    //MARK: - VIEW DID LOAD
    override func viewDidLoad() {
        super.viewDidLoad()
        
        pageControllview.tintColor = UIColor.getColorIntoHex(Hex: "d7dadd")
        pageControllview.currentPageTintColor = UIColor.black
        
        collectionviewHeight.constant = self.view.frame.width - 40
        centeredCollectionViewFlowLayout = (self.collectionviewImages.collectionViewLayout as! CenteredCollectionViewFlowLayout)
        self.collectionviewImages.decelerationRate = UIScrollView.DecelerationRate.fast
        
        centeredCollectionViewFlowLayout.itemSize = CGSize(
            width: collectionviewImages.bounds.width * cellPercentWidth,
            height: collectionviewImages.bounds.height
        )
        centeredCollectionViewFlowLayout.minimumLineSpacing = 0
        
        self.collectionviewImages.delegate = self
        self.collectionviewImages.dataSource = self
        collectionviewImages.register(UINib(nibName: "TripPageDetailimage", bundle: nil), forCellWithReuseIdentifier: "TripPageDetailimage")
        
        tagListView.delegate = self
        tagListView.textFont = UIFont.Montserrat.Medium(14)
        tagListView.addTag("Architecture")
        tagListView.addTag("Landscape")
        tagListView.addTag("Design")
        tagListView.alignment = .center
        tagListView.alignment = .left
        tagListView.delegate = self
        tagListView.enableRemoveButton = false
        tagListView.paddingX = 10
        tagListView.paddingY = 10
        
        if enumCurrentFlow == .otherUser{
            
        }
    }
    
    //MARK: - BUTTON ACTIONS
    @IBAction func btnHandlerback(sender: UIButton){
        self.navigationController?.popViewController(animated: true)
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
        return 21
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell{
        let cell = collectionviewImages.dequeueReusableCell(withReuseIdentifier: "TripPageDetailimage", for: indexPath ) as! TripPageDetailimage
        
        DispatchQueue.main.asyncAfter(deadline: .now()){
            cell.imgviewBG.layer.cornerRadius = 15.0
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let Push = UIStoryboard.trip.instantiateViewController(withIdentifier: "LatestTripVC") as! LatestTripVC
        self.navigationController?.pushViewController(Push, animated: true)
    }
}
