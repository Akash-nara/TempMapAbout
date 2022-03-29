//
//  TravelAdviceListViewController.swift
//  MyMapp
//
//  Created by Akash on 11/03/22.
//

import UIKit
//import MaterialDesignWidgets

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
    @IBOutlet weak var segmentedControl: UIView!

    /// Segmented Control
    @IBOutlet weak var labelTitle: UILabel!
    @IBOutlet weak var tblviewData: UITableView!{
        didSet{
            tblviewData.setDefaultProperties(vc: self)
            tblviewData.registerCell(type: ExploreTripTopCellXIB.self, identifier: ExploreTripTopCellXIB.identifier)
            tblviewData.contentInset = UIEdgeInsets.init(top: 0, left: 0, bottom: 30, right: 0)
        }
    }
    
    var isShowWholeContent = false
    var arrayOfToolTips = [TravelAdviceDataModel]()
    var arrayOfStories = [TravelAdviceDataModel]()
    var arrayOfLogistics = [TravelAdviceDataModel]()
    
    var selectedTab:EnumTravelType = .topTips
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        labelTitle.text = cityName
        labelTitle.numberOfLines = 2
        
        arrayOfToolTips.append(TravelAdviceDataModel.init())
        arrayOfToolTips.append(TravelAdviceDataModel.init())
        arrayOfToolTips.append(TravelAdviceDataModel.init())
        
        arrayOfStories.append(TravelAdviceDataModel.init())
        arrayOfStories.append(TravelAdviceDataModel.init())
        arrayOfStories.append(TravelAdviceDataModel.init())
        
        arrayOfLogistics.append(TravelAdviceDataModel.init())
        arrayOfLogistics.append(TravelAdviceDataModel.init())
        arrayOfLogistics.append(TravelAdviceDataModel.init())
        
        setSampleSegments()
    }
    
    @objc func segmentedControlTap(_ sender:MaterialSegmentedControl){
        debugPrint(sender.selectedSegmentIndex)
        self.selectedTab = EnumTravelType.init(rawValue: sender.selectedSegmentIndex) ?? .topTips
        tblviewData.reloadData()
    }
    
    
    func setSampleSegments() {
        let segmentCn = MaterialSegmentedControl.init()
        segmentCn.preserveIconColor = false
        segmentCn.frame = CGRect.init(x: 20, y: segmentedControl.frame.origin.y, width: segmentedControl.frame.width - 60, height: segmentedControl.frame.height)
//        segmentCn.frame = segmentedControl.frame
//        segmentCn.backgroundColor = .red
        segmentCn.selectorStyle = .line
        segmentCn.foregroundColor = UIColor.App_BG_SecondaryDark2_Color
        segmentCn.selectorColor = UIColor.App_BG_SeafoamBlue_Color
        segmentCn.selectedForegroundColor = UIColor.App_BG_SeafoamBlue_Color
        segmentedControl.addSubview(segmentCn)

        let titles:[EnumTravelType] = [.topTips, .stories, .logistics]
        titles.forEach { enmType in
            segmentCn.appendTextSegment(text: enmType.title, textColor: .gray, font: UIFont.Montserrat.Medium(13), rippleColor: .lightGray)
        }
        segmentCn.addTarget(self, action: #selector(segmentedControlTap(_:)), for: .valueChanged)
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
            
            return configureAdvanceTravelCell(indexPath: indexPath, title: "Xi YangYangYangYangYangYang", subTitle: "I would suggest to book all public transport tickets beforehand because I would suggest to book all public transport tickets beforehand because I would suggest to book all public transport tickets beforehand because....", icon: "ic_Default_city_image_one", isExpadCell: arrayOfToolTips[indexPath.row].isExpand,isBookmark: arrayOfToolTips[indexPath.row].isSaved)
        case .stories:
            
            return configureAdvanceTravelCell(indexPath: indexPath, title: "Xi YangYangYangYangYangYang", subTitle: "I would suggest to book all public transport tickets beforehand because I would suggest to book all public transport tickets beforehand because I would suggest to book all public transport tickets beforehand because....", icon: "ic_Default_city_image_one", isExpadCell: arrayOfStories[indexPath.row].isExpand,isBookmark: arrayOfStories[indexPath.row].isSaved)
            
        case .logistics:
            return configureAdvanceTravelCell(indexPath: indexPath, title: "Xi YangYangYangYangYangYang", subTitle: "I would suggest to book all public transport tickets beforehand because I would suggest to book all public transport tickets beforehand because I would suggest to book all public transport tickets beforehand because....", icon: "ic_Default_city_image_one", isExpadCell: arrayOfLogistics[indexPath.row].isExpand,isBookmark: arrayOfLogistics[indexPath.row].isSaved)
        }
    }
    
    func configureAdvanceTravelCell(indexPath:IndexPath, title:String, subTitle:String, icon:String,isExpadCell:Bool, isBookmark:Bool) -> ExploreTripTopCellXIB{
        let cell = self.tblviewData.dequeueReusableCell(withIdentifier: "ExploreTripTopCellXIB", for: indexPath) as! ExploreTripTopCellXIB
        cell.userIcon.image = UIImage.init(named: icon)
        cell.trealingViewExpand.constant = 50
        
        cell.buttonBookmark.isSelected = isBookmark
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
            cell.labelSubTitle.isShowWholeContent = isExpadCell//self.arrayOfToolTips[cell.labelSubTitle.tag]
            cell.labelSubTitle.readLessText = " " + "see less"
            cell.labelSubTitle.readMoreText = " " + "see more"
            cell.labelSubTitle.isOneLinedContent = true
            cell.labelSubTitle.setContent(str, noOfCharacters: 120, readMoreTapped: {
                self.updateBoolFlagForExpand(index: cell.labelSubTitle.tag, flag: true)

                self.isShowWholeContent = true
                self.tblviewData.reloadData()
            }) {
                self.updateBoolFlagForExpand(index: cell.labelSubTitle.tag, flag: false)
                self.isShowWholeContent = false
                self.tblviewData.reloadData()
            }
        }
        return cell
    }
    
    func updateBoolFlagForExpand(index:Int,flag:Bool){
        switch self.selectedTab{
        case .topTips:
            self.arrayOfToolTips[index].isExpand = flag
        case .stories:
            self.arrayOfStories[index].isExpand = flag
        case .logistics:
            self.arrayOfLogistics[index].isExpand = flag
        }
    }
    
    @objc func buttonBookmarkClicked(sender:UIButton){
        sender.isSelected.toggle()
        switch self.selectedTab {
        case .topTips:
            arrayOfToolTips[sender.tag].isSaved.toggle()
        case .stories:
            arrayOfStories[sender.tag].isSaved.toggle()
        case .logistics:
            arrayOfLogistics[sender.tag].isSaved.toggle()
        }
    }
    
    //MARK: - OTHER FUNCTIONS
    @objc func isExpandTravelAdvice(_ sender:UITapGestureRecognizer){
        let section = (Int(sender.accessibilityHint ?? "") ?? 0)
        let row = (Int(sender.accessibilityLabel ?? "") ?? 0)
        
        switch self.selectedTab {
        case .topTips:
            arrayOfToolTips[IndexPath.init(row: row, section: section).row].isExpand.toggle()
        case .stories:
            arrayOfStories[IndexPath.init(row: row, section: section).row].isExpand.toggle()
        case .logistics:
            arrayOfLogistics[IndexPath.init(row: row, section: section).row].isExpand.toggle()
        }
        self.tblviewData.reloadData()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){}
}
