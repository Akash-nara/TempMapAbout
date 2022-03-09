//
//  ExploreTripDetailViewController.swift
//  MyMapp
//
//  Created by Akash on 09/03/22.
//

import UIKit

class ExploreTripDetailViewController: UIViewController {
    
    var cityId = 0
    //MARK: - OUTLETS
    @IBOutlet weak var labelTitle: UILabel!
    @IBOutlet weak var labelToSaved: UILabel!

    @IBOutlet weak var tblviewData: UITableView!{
        didSet{
            tblviewData.setDefaultProperties(vc: self)
            tblviewData.registerCell(type: SearchHeaderXIB.self, identifier: SearchHeaderXIB.identifier)
            tblviewData.registerCell(type: ExploreTableDataCell.self, identifier: ExploreTableDataCell.identifier)
            tblviewData.contentInset = UIEdgeInsets.init(top: 0, left: 0, bottom: 30, right: 0)
        }
    }
    
    enum EnumTripType:Int {
        case mostLiked = 0, mostSaved, thisMonthPopuler
        
        var title:String{
            switch self{
            case .mostLiked:
                return "Most Liked"
            case .mostSaved:
                return "Most Saved"
            case .thisMonthPopuler:
                return "Popular this month"
            }
        }
    }
    
    var arrayOfSections:[EnumTripType] = [.mostLiked,.mostSaved,.thisMonthPopuler]
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

//MARK: - TABLEVIEW METHODS
extension ExploreTripDetailViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch arrayOfSections[section] {
        default:
            return 1
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int{
        return 0//arrayOfSections.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch arrayOfSections[indexPath.section]{
        case .mostLiked:
            guard let cell = self.tblviewData.dequeueCell(
                withType: ExploreTableDataCell.self,
                for: indexPath) as? ExploreTableDataCell else {
                    return UITableViewCell()
                }
            cell.collectionviewPlace.tag = arrayOfSections[indexPath.section].rawValue
            //            cell.collectionviewPlace.delegate = self
            //            cell.collectionviewPlace.dataSource = self
            //            self.collectionviewSearch = cell.collectionviewPlace
            return cell
        case .mostSaved:
            guard let cell = self.tblviewData.dequeueCell(
                withType: ExploreTableDataCell.self,
                for: indexPath) as? ExploreTableDataCell else {
                    return UITableViewCell()
                }
            
            cell.collectionviewPlace.tag = arrayOfSections[indexPath.section].rawValue
            //            cell.collectionviewPlace.delegate = self
            //            cell.collectionviewPlace.dataSource = self
            //            self.collectionviewSearch = cell.collectionviewPlace
            
            return cell
        case .thisMonthPopuler:
            guard let cell = self.tblviewData.dequeueCell(
                withType: ExploreTableDataCell.self,
                for: indexPath) as? ExploreTableDataCell else {
                    return UITableViewCell()
                }
            
            cell.collectionviewPlace.tag = arrayOfSections[indexPath.section].rawValue
            //            cell.collectionviewPlace.delegate = self
            //            cell.collectionviewPlace.dataSource = self
            ////            self.collectionviewSearch = cell.collectionviewPlace
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){}
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return nil
        let indexPath = IndexPath.init(row: 0, section: section)
        switch arrayOfSections[section] {
        default:
            guard let cell = self.tblviewData.dequeueCell(
                withType: SearchHeaderXIB.self,
                for: indexPath) as? SearchHeaderXIB else {
                    return UITableViewCell()
                }
            cell.labelTitle.text = arrayOfSections[section].title
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        switch arrayOfSections[section] {
        default:
            return  60
        }
    }
}
