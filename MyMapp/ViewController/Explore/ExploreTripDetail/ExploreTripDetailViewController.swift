//
//  ExploreTripDetailViewController.swift
//  MyMapp
//
//  Created by Akash on 09/03/22.
//

import UIKit

class ExploreTripDetailViewController: UIViewController {
    
    //MARK: - OUTLETS
    var cityId = 0
    var cityName = "Spain"
    @IBOutlet weak var labelTitle: UILabel!
    @IBOutlet weak var labelToSaved: UILabel!
    @IBOutlet weak var tblviewData: UITableView!{
        didSet{
            tblviewData.setDefaultProperties(vc: self)
            tblviewData.registerCell(type: SearchHeaderXIB.self, identifier: SearchHeaderXIB.identifier)
            tblviewData.registerCell(type: ExploreTableDataCell.self, identifier: ExploreTableDataCell.identifier)
            tblviewData.registerCell(type: MapExploreTVCell.self, identifier: MapExploreTVCell.identifier)
            tblviewData.registerCell(type: ExploreTripTopCellXIB.self, identifier: ExploreTripTopCellXIB.identifier)
            
            tblviewData.contentInset = UIEdgeInsets.init(top: 0, left: 0, bottom: 30, right: 0)
        }
    }
    var isShowWholeContent = false
    enum EnumTripType:Int {
        case map = 0, popularCities, featuredPlaces, topTips, fromMyFeed
        var title:String{
            switch self{
            case .map:
                return ""
            case .popularCities:
                return "Most Popular Cities"
            case .featuredPlaces:
                return "Featured Places"
            case .topTips:
                return "Top Tips"
            case .fromMyFeed:
                return "From my Feed"
            }
        }
    }
    var arrayOfToolTips = [Bool]()
    var arrayOfSections:[EnumTripType] = [.map,.topTips]
    override func viewDidLoad() {
        super.viewDidLoad()
        
        labelTitle.text = cityName
        labelTitle.numberOfLines = 2
        labelToSaved.isHidden = true
        
        arrayOfToolTips.append(false)
        arrayOfToolTips.append(false)
        arrayOfToolTips.append(false)
    }
    
    @IBAction func buttonBackTapp(_ sender:UIButton){
        self.navigationController?.popViewController(animated: true)
    }
}

//MARK: - TABLEVIEW METHODS
extension ExploreTripDetailViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int{
        return arrayOfSections.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch arrayOfSections[section] {
        case .map:
            return 1
        case .topTips:
            return arrayOfToolTips.count > 4 ? 3 : arrayOfToolTips.count
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch arrayOfSections[indexPath.section]{
        case .map:
            guard let cell = self.tblviewData.dequeueCell(
                withType: MapExploreTVCell.self,
                for: indexPath) as? MapExploreTVCell else {
                    return UITableViewCell()
                }
            return cell
        case .topTips:
            return configureAdvanceTravelCell(indexPath: indexPath, title: "Xi YangYangYangYangYangYang", subTitle: "I would suggest to book all public transport tickets beforehand because I would suggest to book all public transport tickets beforehand because I would suggest to book all public transport tickets beforehand because....", icon: "ic_Default_city_image_one", isExpadCell: arrayOfToolTips[indexPath.row])
        default:
            return UITableViewCell()
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
//        arrayOfToolTips[sender.tag].toggle()
//        tblviewData.reloadData()
    }
    
    //MARK: - OTHER FUNCTIONS
    @objc func isExpandTravelAdvice(_ sender:UITapGestureRecognizer){
        let section = (Int(sender.accessibilityHint ?? "") ?? 0)
        let row = (Int(sender.accessibilityLabel ?? "") ?? 0)
        arrayOfToolTips[IndexPath.init(row: row, section: section).row].toggle()
        self.tblviewData.reloadData()
    }

    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){}
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let indexPath = IndexPath.init(row: 0, section: section)
        switch arrayOfSections[section] {
        case.topTips,.map:
            guard let cell = self.tblviewData.dequeueCell(
                withType: SearchHeaderXIB.self,
                for: indexPath) as? SearchHeaderXIB else {
                    return UITableViewCell()
                }
            cell.labelTitle.text = arrayOfSections[section].title
            return cell
        default:
            return nil
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        switch arrayOfSections[section] {
        case .topTips:
            return 60
        default:
            return  0.01
        }
    }
}
