//
//  TripMainPageHeaderCellXIB.swift
//  MyMapp
//
//  Created by Chirag Pandya on 05/12/21.
//

import UIKit

class TripMainPageHeaderCellXIB: UITableViewCell {

    @IBOutlet weak var labelUserName : UILabel!
    @IBOutlet weak var labelAddress : UILabel!
    @IBOutlet weak var userImage : UIImageView!
    
    @IBOutlet weak var cityName : UILabel!
    @IBOutlet weak var cityAddress : UILabel!
    @IBOutlet weak var tripDate : UILabel!
    @IBOutlet weak var tripDescription : UILabel!
    @IBOutlet weak var stackViewUserNameAndAddress : UIStackView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func configureCell(dataModel:TripDataModel?){
        guard let model = dataModel else {
            return
        }
        labelUserName.text = model.userCreatedTrip?.username
        labelAddress.text = model.userCreatedTrip?.region
        userImage.setImage(url: model.userCreatedTrip?.profilePic ?? "", placeholder: UIImage.init(named: "ic_user_image_defaulut_one"))
        cityName.text = model.city.cityName
        cityAddress.text = model.city.cityName+", "+model.city.countryName
        tripDate.text = model.monthYearOfTrip//model.dateFromatedOftrip
        tripDescription.text = "This city is beautiful during summer. The weather is so pleasant with the summer breeze. I would not recommend more than 5 days to see the whole city. "//model.tripDescription
        tripDescription.text = model.tripDescription
        tripDescription.isHidden = model.tripDescription.isEmpty
    }
}
