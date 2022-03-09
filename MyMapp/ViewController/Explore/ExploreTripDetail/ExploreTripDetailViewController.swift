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
            tblviewData.registerCell(type: AddTripTopExpandXIB.self, identifier: AddTripTopExpandXIB.identifier)
            
            tblviewData.contentInset = UIEdgeInsets.init(top: 0, left: 0, bottom: 30, right: 0)
        }
    }
    
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
    
    var arrayOfSections:[EnumTripType] = [.map,.topTips]
    override func viewDidLoad() {
        super.viewDidLoad()
        
        labelTitle.text = cityName
        labelTitle.numberOfLines = 2
        labelToSaved.isHidden = true
    }
}

//MARK: - TABLEVIEW METHODS
extension ExploreTripDetailViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch arrayOfSections[section] {
        case .topTips,.map:
            return 1
        default:
            return 0
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int{
        return arrayOfSections.count
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
            guard let cell = self.tblviewData.dequeueCell(
                withType: AddTripTopExpandXIB.self,
                for: indexPath) as? AddTripTopExpandXIB else {
                    return UITableViewCell()
                }
            return cell
        default:
            return UITableViewCell()
        }
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
