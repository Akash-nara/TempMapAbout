//
//  SavedAlbumDetailViewController.swift
//  MyMapp
//
//  Created by Akash Nara on 30/03/22.
//

import UIKit

class SavedAlbumDetailViewController: UIViewController {
    
    //MARK: - OUTLETS
    @IBOutlet weak var labelTitle: UILabel!
    @IBOutlet weak var labelGotoCityPage: UILabel!
    @IBOutlet weak var tblviewData: UITableView!{
        didSet{
            tblviewData.setDefaultProperties(vc: self)
            tblviewData.registerCell(type: TitleHeaderTVCell.self, identifier: TitleHeaderTVCell.identifier)
            tblviewData.registerCell(type: ExploreTableDataCell.self, identifier: ExploreTableDataCell.identifier)
            tblviewData.registerCell(type: MapExploreTVCell.self, identifier: MapExploreTVCell.identifier)
            tblviewData.registerCell(type: ExploreTripTopCellXIB.self, identifier: ExploreTripTopCellXIB.identifier)
            tblviewData.registerCell(type: CollectionViewTVCell.self, identifier: CollectionViewTVCell.identifier)
            tblviewData.registerCellNib(identifier: ExpandableTVCell.identifier)
            
            tblviewData.contentInset = UIEdgeInsets.init(top: 0, left: 0, bottom: 30, right: 0)
        }
    }
    enum EnumSavedAlbumType:Int {
        case savedAlbums = 0, savedLocations, savedToptips
        var title:String{
            switch self{
            case .savedAlbums:
                return "Saved Albums"
            case .savedLocations:
                return "Saved Locations"
            case .savedToptips:
                return "Saved Advice"
            }
        }
    }
    var viewModel = SavedAlbumListViewModel()
    
    var arrayOfSections:[EnumSavedAlbumType] = []
    var arrayOfToolTips = [TravelAdviceDataModel]()
    var arraySavedAlbums = [TripDataModel]()
    var arraySavedLocations = [TripDataModel.TripFavLocations]()
    var nextPageToken:String = ""
    var cityId = 0
    var cityName = "Spain"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        labelTitle.text = cityName
        labelTitle.numberOfLines = 2
        labelGotoCityPage.isHidden = false
        let tap = UITapGestureRecognizer.init(target: self, action: #selector(handleGestureGotoCityPage))
        tap.numberOfTapsRequired = 1
        labelGotoCityPage.addGestureRecognizer(tap)
        
        arrayOfSections.append(.savedAlbums)
        arrayOfSections.append(.savedLocations)
        arrayOfSections.append(.savedToptips)
        tblviewData.reloadData()
        
    }
    
    @objc func handleGestureGotoCityPage(){
        self.navigationController?.popViewController(animated: true)
    }
}

//MARK: - TABLEVIEW METHODS
extension SavedAlbumDetailViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func numberOfSections(in tableView: UITableView) -> Int{
        return arrayOfSections.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch arrayOfSections[indexPath.section]{
        case .savedAlbums:
            guard let cell = self.tblviewData.dequeueCell(
                withType: ExploreTableDataCell.self,
                for: indexPath) as? ExploreTableDataCell else {
                    return UITableViewCell()
                }
            return cell
        case .savedLocations:
            guard let cell = self.tblviewData.dequeueCell(
                withType: ExploreTableDataCell.self,
                for: indexPath) as? ExploreTableDataCell else {
                    return UITableViewCell()
                }
            return cell
        case .savedToptips:
            guard let cell = self.tblviewData.dequeueCell(
                withType: ExploreTableDataCell.self,
                for: indexPath) as? ExploreTableDataCell else {
                    return UITableViewCell()
                }
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){}
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let cell = self.tblviewData.dequeueCell(withType: TitleHeaderTVCell.self) as! TitleHeaderTVCell
        cell.cellConfig(title: arrayOfSections[section].title)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 60
    }
}
// apis
extension SavedAlbumDetailViewController{
    
    // get saved trips
    func getSavedTripListApi(isNextPageRequest: Bool = false, isPullToRefresh:Bool = false){
        let param = viewModel.getPageDict(isPullToRefresh)
        let paramDict:[String:Any] = ["INTEREST_CATEGORY":"feed", "pager":param]
        viewModel.getSavedTripListApi(paramDict: paramDict, success: { response in
        })
    }
    
    // get saved locations
    func getSavedLocationsListApi(isNextPageRequest: Bool = false, isPullToRefresh:Bool = false){
        let param = viewModel.getPageDict(isPullToRefresh)
        let paramDict:[String:Any] = ["INTEREST_CATEGORY":"location", "pager":param]
        viewModel.getSavedTripListApi(paramDict: paramDict, success: { response in
        })
    }
    
    // get saved toptips
    func getSavedTopTipListApi(isNextPageRequest: Bool = false, isPullToRefresh:Bool = false){
        let param = viewModel.getPageDict(isPullToRefresh)
        let paramDict:[String:Any] = ["INTEREST_CATEGORY":"advice", "pager":param]
        viewModel.getSavedTripListApi(paramDict: paramDict, success: { response in
        })
    }
}
