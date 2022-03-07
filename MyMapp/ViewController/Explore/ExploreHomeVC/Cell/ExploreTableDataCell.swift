//
//  ExploreTableDataCell.swift
//  MyMapp
//
//  Created by Akash on 07/03/22.
//

import UIKit

class ExploreTableDataCell: UITableViewCell {

    @IBOutlet weak var collectionviewPlace: UICollectionView!{
        didSet{
            collectionviewPlace.register(UINib(nibName: "ExploreCollectionDataCell", bundle: nil), forCellWithReuseIdentifier: "ExploreCollectionDataCell")

        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
