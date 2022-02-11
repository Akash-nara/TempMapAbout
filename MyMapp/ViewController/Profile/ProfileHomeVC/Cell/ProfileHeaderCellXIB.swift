//
//  ProfileHeaderCellXIB.swift
//  MyMapp
//
//  Created by Chirag Pandya on 14/11/21.
//

import UIKit

class ProfileHeaderCellXIB: UICollectionReusableView {
    
    @IBOutlet weak var viewSearchview: UIView!
    @IBOutlet weak var viewSearchStack: UIStackView!
    
    @IBOutlet weak var btnHandlerSaved: UIButton!
    @IBOutlet weak var btnHandlerMaps: UIButton!
    @IBOutlet weak var btnHandlerAlbums: UIButton!
    @IBOutlet weak var viewSaved: UIView!
    @IBOutlet weak var viewMap: UIView!
    @IBOutlet weak var viewAlbum: UIView!
    @IBOutlet weak var profilePic: UIImageView!
    @IBOutlet weak var labelUsername: UILabel!
    @IBOutlet weak var labelUserDescription: UILabel!
    @IBOutlet weak var labelUserAddress: UILabel!
    @IBOutlet weak var labelUserFollowerTitle: UILabel!
    @IBOutlet weak var labelUserFollowerCounts: UILabel!
    @IBOutlet weak var buttonEditProfile: UIButton!
    @IBOutlet weak var viewOnlineOfflineStatus: UIView!
    @IBOutlet weak var segmentControll: UISegmentedControl!
    @IBOutlet weak var searchtextField: UITextField!

    override func awakeFromNib() {
        super.awakeFromNib()
        
        viewOnlineOfflineStatus.isHidden = true
        profilePic.cornerRadius = profilePic.frame.size.width/2
        profilePic.clipsToBounds = true
        buttonEditProfile.addAction(for: .touchUpInside) { [weak self] in
            CustomAlertView.init(title: "Coming soon.",forPurpose: .success).showForWhile(animated: true)
        }
        configureUserObject()
    }
    
    func configureUserObject(){
        if let name = APP_USER?.displayName, !name.isEmpty{
            labelUsername.text = name.capitalized
        }else{
            labelUsername.text = "NA"
        }
        
        if let userDescription = APP_USER?.userDescription, !userDescription.isEmpty{
            labelUserDescription.text = userDescription
        }else{
            labelUserDescription.text = "I love to share my travel discoveries with the people who share this passion."
        }

        if let userLocationCity = APP_USER?.userLocationCity, !userLocationCity.isEmpty{
            labelUserAddress.text = userLocationCity
        }else{
            labelUserAddress.text = "London, United Kingdom"
        }
        
        labelUserFollowerCounts.text = "\(APP_USER?.followersCount ?? 0)"
        profilePic.setImage(url: APP_USER?.profilePicPath ?? "", placeholder: UIImage(named: "ic_user_image_defaulut_one"))
    }

}
