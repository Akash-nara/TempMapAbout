//
//  ActivityHomeVC.swift
//  MyMapp
//
//  Created by Chirag Pandya on 09/11/21.
//

import UIKit

class ActivityHomeVC: UIViewController {
    
    //MARK: - OUTLETS
    @IBOutlet weak var tblviewActivity:UITableView!{
        didSet{
            tblviewActivity.setDefaultProperties(vc: self)
            tblviewActivity.registerCell(type: ActivityHeaderCell.self, identifier: ActivityHeaderCell.identifier)
            tblviewActivity.registerCell(type: ActivityInfoCellXIB.self, identifier: ActivityInfoCellXIB.identifier)
            tblviewActivity.registerCell(type: ActivityimageCellXIB.self, identifier: ActivityimageCellXIB.identifier)
        }
    }
    
    //MARK: - VIEW DID LOAD
    override func viewDidLoad() { super.viewDidLoad() }
}

//MARK: - TABLEVIEW METHODS
extension ActivityHomeVC: UITableViewDelegate, UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int { return 6 }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0{
            return 1
        }else if section == 1{
            return 1
        }else if section == 2{
            return 1
        }else if section == 3{
            return 3
        }else if section == 4{
            return 1
        }else{
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 0{
            guard let cell = self.tblviewActivity.dequeueCell(
                withType: ActivityHeaderCell.self,
                for: indexPath) as? ActivityHeaderCell else {
                    return UITableViewCell()
                }
            cell.selectionStyle = .none
            return cell
        }else if indexPath.section == 1{
            guard let cell = self.tblviewActivity.dequeueCell(
                withType: ActivityInfoCellXIB.self,
                for: indexPath) as? ActivityInfoCellXIB else {
                    return UITableViewCell()
                }
            cell.viewLine.isHidden = false
            cell.selectionStyle = .none
            
            let attrs1 = [NSAttributedString.Key.font : UIFont.Montserrat.Bold(14), NSAttributedString.Key.foregroundColor : UIColor.App_BG_SecondaryDark2_Color]
            
            let attrs2 = [NSAttributedString.Key.font : UIFont.Montserrat.Medium(14), NSAttributedString.Key.foregroundColor : UIColor.App_BG_SecondaryDark2_Color]
            
            let attributedString1 = NSMutableAttributedString(string:"simona.soriano ", attributes:attrs1)
            
            let attributedString2 = NSMutableAttributedString(string:"started following you.", attributes:attrs2)
            
            attributedString1.append(attributedString2)
            cell.lblText.attributedText = attributedString1
            
            cell.viewButton.isHidden = false
            
            cell.btnTitleFollow.setTitle("Following", for: .normal)
            cell.btnTitleFollow.backgroundColor = UIColor.App_BG_App_BG_colorsNeutralLightLighter2
            
            return cell
        }else if indexPath.section == 2{
            guard let cell = self.tblviewActivity.dequeueCell(
                withType: ActivityHeaderCell.self,
                for: indexPath) as? ActivityHeaderCell else {
                    return UITableViewCell()
                }
            
            cell.selectionStyle = .none
            return cell
        }else if indexPath.section == 3{
            if indexPath.row == 0{
                guard let cell = self.tblviewActivity.dequeueCell(
                    withType: ActivityInfoCellXIB.self,
                    for: indexPath) as? ActivityInfoCellXIB else {
                        return UITableViewCell()
                    }
                
                cell.selectionStyle = .none
                
                let attrs1 = [NSAttributedString.Key.font : UIFont.Montserrat.Bold(14), NSAttributedString.Key.foregroundColor : UIColor.App_BG_SecondaryDark2_Color]
                
                let attrs2 = [NSAttributedString.Key.font : UIFont.Montserrat.Medium(14), NSAttributedString.Key.foregroundColor : UIColor.App_BG_SecondaryDark2_Color]
                let attributedString1 = NSMutableAttributedString(string:"simona.soriano ", attributes:attrs1)
                
                let attributedString2 = NSMutableAttributedString(string:"started following you.", attributes:attrs2)
                
                attributedString1.append(attributedString2)
                cell.lblText.attributedText = attributedString1
                
                cell.viewLine.isHidden = true
                
                cell.viewButton.isHidden = false
                
                cell.btnTitleFollow.setTitle("Following", for: .normal)
                cell.btnTitleFollow.backgroundColor = UIColor.App_BG_App_BG_colorsNeutralLightLighter2
                
                return cell
            }else if indexPath.row == 1{
                guard let cell = self.tblviewActivity.dequeueCell(
                    withType: ActivityimageCellXIB.self,
                    for: indexPath) as? ActivityimageCellXIB else {
                        return UITableViewCell()
                    }
                
                cell.selectionStyle = .none
                
                let attrs1 = [NSAttributedString.Key.font : UIFont.Montserrat.Bold(14), NSAttributedString.Key.foregroundColor : UIColor.App_BG_SecondaryDark2_Color]
                
                let attrs2 = [NSAttributedString.Key.font : UIFont.Montserrat.Medium(14), NSAttributedString.Key.foregroundColor : UIColor.App_BG_SecondaryDark2_Color]
                
                let attributedString1 = NSMutableAttributedString(string:"simona.soriano ", attributes:attrs1)
                
                let attributedString2 = NSMutableAttributedString(string:"started following you.", attributes:attrs2)
                
                attributedString1.append(attributedString2)
                cell.lblText.attributedText = attributedString1
                
                return cell
            }else{
                guard let cell = self.tblviewActivity.dequeueCell(
                    withType: ActivityInfoCellXIB.self,
                    for: indexPath) as? ActivityInfoCellXIB else {
                        return UITableViewCell()
                    }
                
                cell.selectionStyle = .none
                
                let attrs1 = [NSAttributedString.Key.font : UIFont.Montserrat.Bold(14), NSAttributedString.Key.foregroundColor : UIColor.App_BG_SecondaryDark2_Color]
                
                let attrs2 = [NSAttributedString.Key.font : UIFont.Montserrat.Medium(14), NSAttributedString.Key.foregroundColor : UIColor.App_BG_SecondaryDark2_Color]
                
                let attributedString1 = NSMutableAttributedString(string:"simona.soriano ", attributes:attrs1)
                
                let attributedString2 = NSMutableAttributedString(string:"started following you.", attributes:attrs2)
                
                attributedString1.append(attributedString2)
                cell.lblText.attributedText = attributedString1
                
                cell.viewLine.isHidden = false
                cell.viewButton.isHidden = false
                
                cell.btnTitleFollow.setTitle("Follow", for: .normal)
                cell.btnTitleFollow.backgroundColor = UIColor.App_BG_SeafoamBlue_Color
                
                return cell
            }
        }else if indexPath.section == 4{
            guard let cell = self.tblviewActivity.dequeueCell(
                withType: ActivityHeaderCell.self,
                for: indexPath) as? ActivityHeaderCell else {
                    return UITableViewCell()
                }
            
            cell.selectionStyle = .none
            return cell
        }else{
            guard let cell = self.tblviewActivity.dequeueCell(
                withType: ActivityInfoCellXIB.self,
                for: indexPath) as? ActivityInfoCellXIB else {
                    return UITableViewCell()
                }
            
            cell.selectionStyle = .none
            
            let attrs1 = [NSAttributedString.Key.font : UIFont.Montserrat.Bold(14), NSAttributedString.Key.foregroundColor : UIColor.App_BG_SecondaryDark2_Color]
            
            let attrs2 = [NSAttributedString.Key.font : UIFont.Montserrat.Medium(14), NSAttributedString.Key.foregroundColor : UIColor.App_BG_SecondaryDark2_Color]
            
            let attributedString1 = NSMutableAttributedString(string:"simona.soriano ", attributes:attrs1)
            
            let attributedString2 = NSMutableAttributedString(string:"started following you.", attributes:attrs2)
            
            attributedString1.append(attributedString2)
            cell.lblText.attributedText = attributedString1
            
            cell.viewLine.isHidden = false
            
            cell.viewButton.isHidden = false
            
            cell.btnTitleFollow.setTitle("Follow", for: .normal)
            cell.btnTitleFollow.backgroundColor = UIColor.App_BG_SeafoamBlue_Color
            
            return cell
        }
    }
}
