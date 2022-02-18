//
//  ActivityHomeVC.swift
//  MyMapp
//
//  Created by Akash on 17/02/22.
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
            tblviewActivity.registerCell(type: ActivityFooterCell.self, identifier: ActivityFooterCell.identifier)
            tblviewActivity.sectionHeaderHeight = 50
            tblviewActivity.estimatedSectionHeaderHeight = UITableView.automaticDimension
            
            if #available(iOS 15.0, *) {
                tblviewActivity.sectionHeaderTopPadding = 0
            } else {
                // Fallback on earlier versions
            }

        }
    }
    
    var viewModel = ActivityHomeViewModel()
    
    //MARK: - VIEW DID LOAD
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
}

//MARK: - TABLEVIEW METHODS
extension ActivityHomeVC: UITableViewDelegate, UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.arraySections.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch viewModel.arraySections[section] {
        case .today:
            return 1//viewModel.arrayTodayList.count
        case .currentWeek:
            return 3//viewModel.arrayCurrentWeekList.count
        case .lastWeek:
            return 2//viewModel.arrayLastWeekList.count
        }
        //        if section == 0{
        //            return 1
        //        }else if section == 1{
        //            return 1
        //        }else if section == 2{
        //            return 1
        //        }else if section == 3{
        //            return 3
        //        }else if section == 4{
        //            return 1
        //        }else{
        //            return 1
        //        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch viewModel.arraySections[indexPath.section] {
        case .today:
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
            
            cell.viewButton.isHidden = false
            
            cell.btnTitleFollow.setTitle("Following", for: .normal)
            cell.btnTitleFollow.backgroundColor = UIColor.App_BG_App_BG_colorsNeutralLightLighter2
            
            return cell
            
        case .currentWeek:
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
                
                cell.viewButton.isHidden = false
                
                cell.btnTitleFollow.setTitle("Follow", for: .normal)
                cell.btnTitleFollow.backgroundColor = UIColor.App_BG_SeafoamBlue_Color
                
                return cell
            }
            
        case .lastWeek:
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
            
            
            cell.viewButton.isHidden = false
            
            cell.btnTitleFollow.setTitle("Follow", for: .normal)
            cell.btnTitleFollow.backgroundColor = UIColor.App_BG_SeafoamBlue_Color
            
            return cell
        }
        
        /*
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
         }*/
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let cell = self.tblviewActivity.dequeueCell(
            withType: ActivityHeaderCell.self,
            for: IndexPath.init(row: 0, section: section)) as? ActivityHeaderCell else {
                return UITableViewCell()
            }
        cell.selectionStyle = .none
        
        var headerName = ""
        switch viewModel.arraySections[section] {
        case .today:
            headerName = "Today"
        case .currentWeek:
            headerName = "This Week"
        case .lastWeek:
            headerName = "Last Week"
        }
        
        cell.lblHeader.text = headerName
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        guard let footerView = self.tblviewActivity.dequeueCell(
            withType: ActivityFooterCell.self,
            for: IndexPath.init(row: 0, section: section)) as? ActivityFooterCell else {
                return UITableViewCell()
            }
        footerView.selectionStyle = .none

        
//        let footerView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.size.width, height: 1))
//        footerView.backgroundColor = UIColor.App_BG_SeafoamBlue_Color
        let isLastSection = viewModel.arraySections.count - 1 == section
        switch viewModel.arraySections[section] {
        case .today:
            return isLastSection ? nil :footerView
        case .currentWeek:
            return isLastSection ? nil :footerView
        case .lastWeek:
            return isLastSection ? nil :footerView
        }
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        let isLastSection = viewModel.arraySections.count - 1 == section
        return isLastSection ? 0 : 16
    }
}
