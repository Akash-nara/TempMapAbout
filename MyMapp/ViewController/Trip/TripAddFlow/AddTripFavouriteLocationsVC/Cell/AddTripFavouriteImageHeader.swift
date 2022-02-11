//
//  AddTripFavouriteImageHeader.swift
//  MyMapp
//
//  Created by Akash on 25/01/22.
//

import UIKit

class AddTripFavouriteImageHeader: UICollectionReusableView {

    @IBOutlet weak var btnTitleAddImage: UIButton!

    override func awakeFromNib() {
        super.awakeFromNib()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1, execute: {
            self.btnTitleAddImage.dropShadowButton()
        })
    }
}
