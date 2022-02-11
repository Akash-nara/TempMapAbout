//
//  OnboardingVC.swift
//  MyMapp
//
//  Created by Chirag Pandya on 28/10/21.
//

import UIKit

class OnboardingVC: UIViewController {
    
    //MARK: - OUTLETS
    @IBOutlet weak var viewLetsGo: UIView!
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var collectionviewOnboarding: UICollectionView!
    
    //MARK: - VIEW DID LOAD
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.pageControl.numberOfPages = 3
        self.viewLetsGo.isHidden = true
        self.collectionviewOnboarding.register(UINib(nibName:"OnboardingCellXIB", bundle: nil), forCellWithReuseIdentifier: "OnboardingCellXIB")
        self.collectionviewOnboarding.delegate = self
        self.collectionviewOnboarding.dataSource = self
        self.collectionviewOnboarding.reloadData()
    }
    
    //MARK: - BUTTON ACTIONS
    @IBAction func btnHandlerLetsGo(_ sender: Any){
        guard let firstObjVC = UIStoryboard.authentication.firstViewVC else {
            return
        }
        self.navigationController?.pushViewController(firstObjVC, animated: true)
    }
    
    //MARK: - OTHER FUNCTIONS
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        var visibleRect = CGRect()
        
        visibleRect.origin = collectionviewOnboarding.contentOffset
        visibleRect.size = collectionviewOnboarding.bounds.size
        let visiblePoint = CGPoint(x: visibleRect.midX, y: visibleRect.midY)
        guard let indexPath = collectionviewOnboarding.indexPathForItem(at: visiblePoint) else { return }
        self.pageControl.currentPage = indexPath.row
        
        if indexPath.row == 2{
            self.viewLetsGo.isHidden = false
        }else{
            self.viewLetsGo.isHidden = true
        }
    }
    
    @objc func skipButton(sender:UIButton){
        guard let firstViewVC =  UIStoryboard.authentication.firstViewVC else {
            return
        }
        self.navigationController?.pushViewController(firstViewVC, animated: true)
    }
}

//MARK: - COLLECTIONVIEW METHODS
extension OnboardingVC : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = self.collectionviewOnboarding.dequeueReusableCell(withReuseIdentifier: "OnboardingCellXIB", for: indexPath) as! OnboardingCellXIB
        
        
        switch indexPath.row {
        case 0:
            
            cell.lblHeader.text = "Plan"
            cell.lblDescription.text = "A one-stop-shop for you! \n \nFind and save all the important details you need when planning for a trip."
            cell.btnTitleSkip.isHidden = false
            cell.imgviewBG.image = UIImage(named: "ic_onboarding_bg")
        case 1:
            
            cell.lblHeader.text = "Discover"
            cell.lblDescription.text = "Find latest travel destinations! \n\nFollow frequent travelers and search for best trip recommendations based on your preferences. "
            cell.btnTitleSkip.isHidden = false
            cell.imgviewBG.image = UIImage(named: "ic_onboarding_2")
        default:
            
            cell.lblHeader.text = "Share"
            cell.lblDescription.text = "Be part of a larger community! \n\nKeep up with your friends’ travels. Share and receive trusted travel advice."
            cell.btnTitleSkip.isHidden = true
            cell.imgviewBG.image = UIImage(named: "ic_onboarding3")
        }
        
        cell.btnTitleSkip.addTarget(self, action: #selector(self.skipButton(sender:)), for: .touchUpInside)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionviewOnboarding.frame.width, height: collectionviewOnboarding.frame.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        
        let totalCellWidth = Int(collectionView.layer.frame.size.width) / 3 * collectionView.numberOfItems(inSection: 0)
        let totalSpacingWidth = (collectionView.numberOfItems(inSection: 0) - 1)
        
        let leftInset = (collectionView.layer.frame.size.width - CGFloat(totalCellWidth + totalSpacingWidth)) / 2
        let rightInset = leftInset
        
        return UIEdgeInsets(top: 0, left: leftInset, bottom: 0, right: rightInset)
    }
}


