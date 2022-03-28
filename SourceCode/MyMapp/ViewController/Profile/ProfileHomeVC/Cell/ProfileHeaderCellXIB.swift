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
    @IBOutlet weak var buttonEditAndFollowingProfile: UIButton!
    @IBOutlet weak var viewOnlineOfflineStatus: UIView!
    @IBOutlet weak var segmentControll: UISegmentedControl!
    @IBOutlet weak var searchtextField: UITextField!
    @IBOutlet weak var buttonMessage: UIButton!
    @IBOutlet weak var stackViewBoxsContainer: UIStackView!
    @IBOutlet weak var stackViewFollower: UIStackView!
    @IBOutlet weak var sepratorHorizentalFollower: UIView!
    @IBOutlet weak var sepratorHorizentalFollowerWidth: NSLayoutConstraint!
    @IBOutlet weak var stackViewFollowerWidthConstrint: NSLayoutConstraint!


    override func awakeFromNib() {
        super.awakeFromNib()
        
        // temp commented hidden
        stackViewFollowerWidthConstrint.constant = 0
        sepratorHorizentalFollowerWidth.constant = 0
        stackViewBoxsContainer.isHidden = true  // as of now hidden
        viewSaved.isHidden = true
        viewAlbum.isHidden = true
        viewMap.isHidden = true
        sepratorHorizentalFollower.isHidden = true
        stackViewFollower.isHidden = true
        buttonMessage.isHidden = true
        buttonEditAndFollowingProfile.isHidden = true
        
        viewOnlineOfflineStatus.isHidden = true
        profilePic.cornerRadius = profilePic.frame.size.width/2
        profilePic.clipsToBounds = true
        buttonEditAndFollowingProfile.addAction(for: .touchUpInside) { [weak self] in
            CustomAlertView.init(title: "Coming soon.",forPurpose: .success).showForWhile(animated: true)
        }
        
        buttonMessage.addAction(for: .touchUpInside) { [weak self] in
            CustomAlertView.init(title: "Coming soon.",forPurpose: .success).showForWhile(animated: true)
        }
        
        buttonMessage.backgroundColor = .App_BG_SeafoamBlue_Color
    }
    
    func configureUserObject(tripObj:TripDataModel? = nil){
        var userName = ""
        var userDescription = ""
        var address = ""
        var followerCount = 0
        var profilePicPath = ""
        
        if let tripDataModel = tripObj{
            userName = tripDataModel.userCreatedTrip?.displayName ?? "NA"
            userDescription = tripDataModel.userCreatedTrip?.userDescription ?? "NA"
            address = tripDataModel.userCreatedTrip?.userLocationCity ?? "NA"
            followerCount = tripDataModel.userCreatedTrip?.followersCount ?? 1
            profilePicPath = tripDataModel.userCreatedTrip?.profilePicPath ?? "NA"
//            self.buttonMessage.isHidden = false
            self.buttonMessage.setTitle("Message", for: .normal)
            buttonEditAndFollowingProfile.setTitle("Following", for: .normal)
            
        }else{
//            self.buttonMessage.isHidden = true
            buttonEditAndFollowingProfile.setTitle("Edit Profile", for: .normal)
            
            if let name = APP_USER?.displayName, !name.isEmpty{
                userName = name.capitalized
                labelUsername.text = name.capitalized
            }else{
                userName = "NA"
            }
            
            if let userDes = APP_USER?.userDescription, !userDes.isEmpty{
                userDescription = userDes
            }else{
                userDescription = "I love to share my travel discoveries with the people who share this passion."
            }
            
            if let userLocationCity = APP_USER?.userLocationCity, !userLocationCity.isEmpty{
                address = userLocationCity
            }else{
                address = "London, United Kingdom"
            }
            
            profilePicPath = APP_USER?.profilePicPath ?? ""
            followerCount = APP_USER?.followersCount ?? 0
        }
        
        labelUsername.text = userName
        labelUserDescription.text = userDescription
        labelUserAddress.text = address
        labelUserFollowerCounts.text = "\(followerCount)"
        profilePic.setImage(url: profilePicPath, placeholder: UIImage(named: "ic_user_image_defaulut_one"))
    }

}
