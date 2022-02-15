//
//  AddTripFavouriteLocationDetail.swift
//  MyMapp
//
//  Created by Akash on 25/01/22.
//

import UIKit
import SwiftyJSON

class AddTripFavouriteLocationDetail{
    
    struct TripFavLocations{
        var name = ""
        var longitude:Double = 0.0
        var latitude:Double = 0.0
        var id = 0
        var lastRecord = false

        init() {}
        init(param:JSON) {
            self.id = param["id"].intValue
            self.name = param["name"].stringValue
            self.longitude = param["longitude"].doubleValue
            self.latitude = param["latitude"].doubleValue

        }
    }
    
    var notes = ""
    var firstTag = ""
    var secondTag = ""
    var arrayOfImages = [TripImagesModel]()
    var indexOfObject = 0
    var id = 0
    var combinedTag:String {
        return firstTag+","+secondTag
    }
    var recommendation = false
    var locationHash = ""
    var locationFav:TripFavLocations? = nil
    var isEdited = false
    
    init(){}
    init(param:JSON) {
        
        self.recommendation = param["recommendation"].boolValue
        self.id = param["id"].intValue
        
        let arrayofTags = param["tags"].stringValue.components(separatedBy: ",")
        if arrayofTags.indices.contains(0){
            let tagWithoutParen = arrayofTags.first ?? "".replacingOccurrences(of: "(", with: "").replacingOccurrences(of: ")", with: "")

            self.firstTag = tagWithoutParen//arrayofTags.first ?? ""
        }
        if arrayofTags.indices.contains(1){
            let tagWithoutParen = arrayofTags.last ?? "".replacingOccurrences(of: "(", with: "").replacingOccurrences(of: ")", with: "")
            self.secondTag = tagWithoutParen//arrayofTags.last ?? ""
        }
        self.locationHash = param["hash"].stringValue
        self.notes = param["notes"].stringValue
        
        locationFav = TripFavLocations.init(param: param["location"])
    }
}
