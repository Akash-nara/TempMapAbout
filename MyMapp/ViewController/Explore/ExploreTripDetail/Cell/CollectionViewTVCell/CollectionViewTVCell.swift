//
//  CollectionViewTVCell.swift
//  MyMapp
//
//  Created by smartsense ConsultingSolutions on 12/03/22.
//

import UIKit

class CollectionViewTVCell: UITableViewCell {

    @IBOutlet weak var collectionViewMain: UICollectionView!
    var arrayFeaturedPlaces = [Any]()
    
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
    
    func cellConfigFeaturedPlacesCell(data: [Any]) {
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
        cell.cellConfig(data: "")
        return cell
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

