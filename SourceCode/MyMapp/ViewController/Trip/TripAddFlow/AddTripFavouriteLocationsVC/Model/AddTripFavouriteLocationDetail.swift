//
//  AddTripFavouriteLocationDetail.swift
//  MyMapp
//
//  Created by Akash on 25/01/22.
//

import UIKit
import SwiftyJSON

class AddTripFavouriteLocationDetail{
    
    class TripFavLocations{
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
//    var firstTag = ""
//    var secondTag = ""
    var firstTagFeed = ""
    var secondTagFeed = ""
    var arrayTagsFeed = [String]()
    var arrayOfImages = [TripImagesModel]()
    var indexOfObject = 0
    var id = 0
    var combinedTag:String {
        "("+firstTagFeed+"),("+secondTagFeed+")"
//        return "(firstTagFeed)+ "(\(secondTagFeed)"
    }
    var recommendation = false
    var locationHash = ""
    var locationFav:TripFavLocations? = nil
    var isEdited = false
    var firstLocationImage = ""
    var isSaved = false
    init(){}
    init(param:JSON) {
        
        self.recommendation = param["recommendation"].boolValue
        self.id = param["id"].intValue
        self.isSaved = param["isSaved"].boolValue
//        let arrayofTags = param["tags"].stringValue.components(separatedBy: ",")
//        if arrayofTags.indices.contains(0){
//            let tagWithoutParen = arrayofTags.first ?? "".replacingOccurrences(of: "(", with: "").replacingOccurrences(of: ")", with: "")
//
//            self.firstTag = tagWithoutParen//arrayofTags.first ?? ""
//        }
//        if arrayofTags.indices.contains(1){
//            let tagWithoutParen = arrayofTags.last ?? "".replacingOccurrences(of: "(", with: "").replacingOccurrences(of: ")", with: "")
//            self.secondTag = tagWithoutParen//arrayofTags.last ?? ""
//        }
        self.locationHash = param["hash"].stringValue
        self.notes = param["notes"].stringValue
        
        locationFav = TripFavLocations.init(param: param["location"])
        
        var tags = param["tags"].stringValue.components(separatedBy: ")")
        if let lastTag = tags.last, lastTag.isEmpty {
            tags.removeLast()
        }
        if var primaryTagString = tags.first {
            primaryTagString.removeAll(where: { $0 == "(" || $0 == ")" })
            firstTagFeed = primaryTagString
//            firstTag = primaryTagString
        }
        
        if var secondaryTagString = tags.last {
            secondaryTagString.removeAll(where: { $0 == "(" || $0 == ")" })
            secondTagFeed = secondaryTagString.trimmingCharacters(in: CharacterSet.init(charactersIn: ","))
//            secondTag = secondaryTagString.trimmingCharacters(in: CharacterSet.init(charactersIn: ","))
        }
        
        debugPrint("")

        
    }
}
