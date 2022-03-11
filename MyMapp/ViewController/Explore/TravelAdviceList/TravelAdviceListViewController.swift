//
//  TravelAdviceListViewController.swift
//  MyMapp
//
//  Created by Akash on 11/03/22.
//

import UIKit
import RESegmentedControl

class TravelAdviceListViewController: UIViewController {
    
    //MARK: - OUTLETS
    enum EnumTravelType:Int {
        case topTips = 0,stories, logistics
        
        var title:String{
            switch self {
            case .topTips:
                return "Top Tips"
                
            case .stories:
                return "Stories"
                
            case .logistics:
                return "Logistics"
                
            }
        }
    }
    var cityId = 0
    var cityName = "Spain"
    /// Segmented Control
    @IBOutlet weak var segmentedControl: RESegmentedControl!
    @IBOutlet weak var labelTitle: UILabel!
    @IBOutlet weak var tblviewData: UITableView!{
        didSet{
            tblviewData.setDefaultProperties(vc: self)
            tblviewData.registerCell(type: ExploreTripTopCellXIB.self, identifier: ExploreTripTopCellXIB.identifier)
            tblviewData.contentInset = UIEdgeInsets.init(top: 0, left: 0, bottom: 30, right: 0)
        }
    }
    
    var isShowWholeContent = false
    var arrayOfToolTips = [Bool]()
    var arrayOfStories = [Bool]()
    var arrayOfLogistics = [Bool]()
    
    var selectedTab:EnumTravelType = .topTips
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        labelTitle.text = cityName
        labelTitle.numberOfLines = 2
        
        arrayOfToolTips.append(false)
        arrayOfToolTips.append(false)
        arrayOfToolTips.append(false)
        
        arrayOfStories.append(false)
        arrayOfStories.append(false)
        arrayOfStories.append(false)
        
        arrayOfLogistics.append(false)
        arrayOfLogistics.append(false)
        arrayOfLogistics.append(false)
        
        
        // Specify a list of string that will be shown
        let titles:[EnumTravelType] = [.topTips, .stories, .logistics]
        
        // Map a list of string to the [SegmentModel]
        var segmentItems: [SegmentModel] {
            return titles.map({ SegmentModel(title: $0.title) })
        }
        // Create a preset to style the segmentedControl
        var preset = BootstapPreset(backgroundColor: .white, selectedBackgroundColor: .white)
        preset.selectedTextColor = UIColor.App_BG_SeafoamBlue_Color
        preset.selectedTintColor = UIColor.App_BG_SeafoamBlue_Color
        preset.textColor = UIColor.App_BG_SecondaryDark2_Color
        preset.textFont = UIFont.Montserrat.Medium(15)
        preset.segmentItemSeparator?.color = UIColor.App_BG_SeafoamBlue_Color
        preset.selectedTextFont = UIFont.Montserrat.Medium(15)
        
        // segmentedControl configuration method
        segmentedControl.configure(segmentItems: segmentItems, preset: preset)
        segmentedControl.selectedSegmentIndex = 0
        segmentedControl.addTarget(self, action: #selector(segmentedControlTap), for: .valueChanged)
    }
    
    @objc func segmentedControlTap(_ sender:RESegmentedControl){
        debugPrint(sender.selectedSegmentIndex)
        self.selectedTab = EnumTravelType.init(rawValue: sender.selectedSegmentIndex) ?? .topTips
        tblviewData.reloadData()
    }
    
    @IBAction func buttonBackTapp(_ sender:UIButton){
        self.navigationController?.popViewController(animated: true)
    }
}

//MARK: - TABLEVIEW METHODS
extension TravelAdviceListViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int{
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch selectedTab {
        case .topTips:
            return arrayOfToolTips.count
        case .stories:
            return arrayOfStories.count - 1
        case .logistics:
            return arrayOfLogistics.count - 2
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch self.selectedTab{
        case .topTips:
            
            return configureAdvanceTravelCell(indexPath: indexPath, title: "Xi YangYangYangYangYangYang", subTitle: "I would suggest to book all public transport tickets beforehand because I would suggest to book all public transport tickets beforehand because I would suggest to book all public transport tickets beforehand because....", icon: "ic_Default_city_image_one", isExpadCell: arrayOfToolTips[indexPath.row])
        case .stories:
            
            return configureAdvanceTravelCell(indexPath: indexPath, title: "Xi YangYangYangYangYangYang", subTitle: "I would suggest to book all public transport tickets beforehand because I would suggest to book all public transport tickets beforehand because I would suggest to book all public transport tickets beforehand because....", icon: "ic_Default_city_image_one", isExpadCell: arrayOfToolTips[indexPath.row])
            
        case .logistics:
            return configureAdvanceTravelCell(indexPath: indexPath, title: "Xi YangYangYangYangYangYang", subTitle: "I would suggest to book all public transport tickets beforehand because I would suggest to book all public transport tickets beforehand because I would suggest to book all public transport tickets beforehand because....", icon: "ic_Default_city_image_one", isExpadCell: arrayOfToolTips[indexPath.row])
        }
    }
    
    func configureAdvanceTravelCell(indexPath:IndexPath, title:String, subTitle:String, icon:String,isExpadCell:Bool) -> ExploreTripTopCellXIB{
        let cell = self.tblviewData.dequeueReusableCell(withIdentifier: "ExploreTripTopCellXIB", for: indexPath) as! ExploreTripTopCellXIB
        cell.userIcon.image = UIImage.init(named: icon)
        cell.trealingViewExpand.constant = 50
        
        cell.buttonBookmark.setImage(UIImage(named: "ic_selected_saved"), for: .selected)
        cell.buttonBookmark.setImage(UIImage(named: "ic_saved_Selected_With_just_border"), for: .normal)
        cell.buttonBookmark.addTarget(self, action: #selector(buttonBookmarkClicked(sender:)), for: .touchUpInside)
        cell.buttonBookmark.tag = indexPath.row
        cell.buttonBookmark.accessibilityHint = "\(indexPath.section)"
        
        cell.lblHeader.text = title
        cell.labelSubTitle.text = subTitle
        cell.bottomConstrainOfMainStackView.constant = isExpadCell ? 20 : 8
        
        cell.labelSubTitle.tag = indexPath.row
        let str = subTitle
        if str.isEmpty {
            cell.labelSubTitle.isHidden = true
        } else {
            cell.labelSubTitle.isHidden = false
            cell.labelSubTitle.isShowWholeContent = self.arrayOfToolTips[cell.labelSubTitle.tag]
            cell.labelSubTitle.readLessText = " " + "see less"
            cell.labelSubTitle.readMoreText = " " + "see more"
            cell.labelSubTitle.isOneLinedContent = true
            cell.labelSubTitle.setContent(str, noOfCharacters: 35, readMoreTapped: {
                self.arrayOfToolTips[cell.labelSubTitle.tag] = true
                self.isShowWholeContent = true
                self.tblviewData.reloadData()
            }) {
                self.arrayOfToolTips[cell.labelSubTitle.tag] = false
                self.isShowWholeContent = false
                self.tblviewData.reloadData()
            }
        }
        return cell
    }
    
    @objc func buttonBookmarkClicked(sender:UIButton){
        sender.isSelected.toggle()
    }
    
    //MARK: - OTHER FUNCTIONS
    @objc func isExpandTravelAdvice(_ sender:UITapGestureRecognizer){
        let section = (Int(sender.accessibilityHint ?? "") ?? 0)
        let row = (Int(sender.accessibilityLabel ?? "") ?? 0)
        arrayOfToolTips[IndexPath.init(row: row, section: section).row].toggle()
        self.tblviewData.reloadData()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){}
}
