//
//  CollectionViewTVCell.swift
//  MyMapp
//
//  Created by Akash Nara on 12/03/22.
//

import UIKit
import SwiftyJSON

class CollectionViewTVCell: UITableViewCell {
    
    @IBOutlet weak var collectionViewMain: UICollectionView!
    var arrayFeaturedPlaces = [JSON]()
    var reachedScrollEndTap: (() -> Void)?
    static var isGooglelPageApiWorking = false
    var cityId = 0
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        collectionViewMain.registerCellNib(identifier: FeaturedPlacesCVCell.identifier)
        collectionViewMain.dataSource = self
        collectionViewMain.delegate = self
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    func cellConfigFeaturedPlacesCell(data: [JSON]) {
        arrayFeaturedPlaces = data
        collectionViewMain.reloadData()
    }
}

extension CollectionViewTVCell: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return arrayFeaturedPlaces.count.isZero() ? 0 : 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrayFeaturedPlaces.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FeaturedPlacesCVCell.identifier, for: indexPath) as! FeaturedPlacesCVCell
        cell.cellConfig(data: arrayFeaturedPlaces[indexPath.row])
        cell.buttonSaveToggle.tag = indexPath.row
        cell.buttonSaveToggle.addTarget(self, action: #selector(buttonToggleSave), for: .touchUpInside)
        return cell
    }
    
    @objc func buttonToggleSave(sender:UIButton){
//        sender.isSelected.toggle()
        
        saveGoogleApi(indexRow: sender.tag) {
            sender.isSelected.toggle()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if (indexPath.row == arrayFeaturedPlaces.count - 1) && !CollectionViewTVCell.isGooglelPageApiWorking { //it's your last cell
           //Load more data & reload your collection view
            CollectionViewTVCell.isGooglelPageApiWorking = true
             reachedScrollEndTap?()
         }
    }
}

extension CollectionViewTVCell: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return FeaturedPlacesCVCell.cellSize
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

        let strJson = JSON([placeId:placeId, "INTEREST_CATEGORY": "google"]).rawString(.utf8, options: .sortedKeys) ?? ""
        let param: [String: Any] = ["requestJson" : strJson]
        API_SERVICES.callAPI(param, path: .unSaveTrip, method: .post) { [weak self] dataResponce in
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
