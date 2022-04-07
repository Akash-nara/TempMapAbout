//
//  CollectionViewTVCell.swift
//  MyMapp
//
//  Created by Akash Nara on 12/03/22.
//

import UIKit
import SwiftyJSON

class CollectionViewTVCell: UITableViewCell {
    
    enum CellType {
        case featuredPlaces, savedAlbums
    }
    
    var cellType: CellType = .featuredPlaces
    
    @IBOutlet weak var collectionViewMain: UICollectionView!
    var arrayFeaturedPlaces = [JSON]()
    var arraySavedAlbums = [TripDataModel]()

    var reachedScrollEndTap: (() -> Void)?
    var didTapUserName: ((Int) -> Void)?
    static var isGooglelPageApiWorking = false
    var cityId = 0
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        collectionViewMain.registerCellNib(identifier: FeaturedPlacesCVCell.identifier)
        collectionViewMain.registerCellNib(identifier: SavedAlbumCVCell.identifier)
        collectionViewMain.dataSource = self
        collectionViewMain.delegate = self
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    func cellConfigFeaturedPlacesCell(data: [JSON]) {
        cellType = .featuredPlaces
        arrayFeaturedPlaces = data
        collectionViewMain.reloadData()
    }
    
    func cellConfigSavedAlbums(data: [TripDataModel]) {
        cellType = .savedAlbums
        arraySavedAlbums = data
        collectionViewMain.reloadData()
    }
}

extension CollectionViewTVCell: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        switch cellType {
        case .featuredPlaces:
            return arrayFeaturedPlaces.count.isZero() ? 0 : 1
        case .savedAlbums:
            return arraySavedAlbums.count.isZero() ? 0 : 1
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch cellType {
        case .featuredPlaces:
            return arrayFeaturedPlaces.count
        case .savedAlbums:
            return arraySavedAlbums.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch cellType {
        case .featuredPlaces:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FeaturedPlacesCVCell.identifier, for: indexPath) as! FeaturedPlacesCVCell
            cell.cellConfig(data: arrayFeaturedPlaces[indexPath.row], arrayOfPlaceIdsStored: ExploreTripDetailViewController.arrayStorePlaceId)
            cell.buttonSaveToggle.tag = indexPath.row
            cell.buttonSaveToggle.addTarget(self, action: #selector(buttonToggleSave), for: .touchUpInside)
            return cell
        case .savedAlbums:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SavedAlbumCVCell.identifier, for: indexPath) as! SavedAlbumCVCell
            cell.cellConfig(data: arraySavedAlbums[indexPath.row])
            cell.buttonUser.tag = indexPath.row
            cell.buttonUser.addTarget(self, action: #selector(cellButtonUserActionListener(_:)), for: .touchUpInside)
            cell.labelTripDate.textColor = UIColor.white
            cell.labelUsername.textColor = UIColor.white

            return cell
        }
    }
    
    @objc func cellButtonUserActionListener(_ sender: UIControl){
        print("cellControlUserActionListener : \(sender.tag)")
        didTapUserName?(arraySavedAlbums[sender.tag].userSavedId )
    }
    
    func  getCell(index:Int) -> FeaturedPlacesCVCell? {
        return collectionViewMain.cellForItem(at: IndexPath.init(row: index, section: 0)) as? FeaturedPlacesCVCell
    }
    
    @objc func buttonToggleSave(sender:UIButton){
        if sender.isSelected{
            unSaveGooglePhotoApi(indexRow: sender.tag) {
                sender.isSelected.toggle()
                guard let cell = self.getCell(index: sender.tag), let placeId = self.arrayFeaturedPlaces[sender.tag].dictionaryValue["place_id"]?.string else {
                    return
                }
                if let index = ExploreTripDetailViewController.arrayStorePlaceId.firstIndex(where: {$0 == placeId}){
                    ExploreTripDetailViewController.arrayStorePlaceId.remove(at: index)
                }
            }
        }else{
            saveGoogleApi(indexRow: sender.tag) {
                sender.isSelected.toggle()
                guard let cell = self.getCell(index: sender.tag), let placeId = self.arrayFeaturedPlaces[sender.tag].dictionaryValue["place_id"]?.string else {
                    return
                }
                ExploreTripDetailViewController.arrayStorePlaceId.append(placeId)
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        switch cellType {
        case .featuredPlaces:
            if (indexPath.row == arrayFeaturedPlaces.count - 1) && !CollectionViewTVCell.isGooglelPageApiWorking { //it's your last cell
               //Load more data & reload your collection view
                CollectionViewTVCell.isGooglelPageApiWorking = true
                 reachedScrollEndTap?()
             }
        case .savedAlbums:
            break
        }
    }
}

extension CollectionViewTVCell: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        switch cellType {
        case .featuredPlaces:
            return FeaturedPlacesCVCell.cellSize
        case .savedAlbums:
            return SavedAlbumCVCell.cellSize
        }
    }
}

extension CollectionViewTVCell: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("didSelect \(indexPath)")
    }
}


extension CollectionViewTVCell{
    func saveGoogleApi(indexRow:Int, success: (() -> ())? = nil){
        
        guard let placeId = arrayFeaturedPlaces[indexRow].dictionaryValue["place_id"]?.stringValue else {
            return
        }
        let strJson = JSON(["placeId":placeId,
                            "city": cityId]).rawString(.utf8, options: .sortedKeys) ?? ""
        let param: [String: Any] = ["requestJson" : strJson]
        
        API_SERVICES.callAPI(param, path: .googleSavePhoto, method: .post) { [weak self] dataResponce in
            guard let status = dataResponce?["status"]?.intValue, status == 200 else {
                return
            }
            NotificationCenter.default.post(name: NSNotification.Name.init(rawValue: "reloadSavedTripList"), object: nil)
            success?()
        }  internetFailure: {
            debugPrint("internetFailure")
        } failureInform: {
        }
    }
    
    func unSaveGooglePhotoApi(indexRow:Int, success: (() -> ())? = nil){
        guard let placeId = arrayFeaturedPlaces[indexRow].dictionaryValue["place_id"]?.stringValue else {
            return
        }

        let strJson = JSON(["placeId":placeId]).rawString(.utf8, options: .sortedKeys) ?? ""
        let param: [String: Any] = ["requestJson" : strJson]
        API_SERVICES.callAPI(param, path: .unSaveGooglePhoto, method: .post) { [weak self] dataResponce in
            guard let status = dataResponce?["status"]?.intValue, status == 200 else {
                return
            }
            NotificationCenter.default.post(name: NSNotification.Name.init(rawValue: "reloadSavedTripList"), object: nil)
            success?()
        }  internetFailure: {
            debugPrint("internetFailure")
        } failureInform: {
        }
    }

    
}
