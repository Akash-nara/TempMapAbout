//
//  TravelAdviceDataModel.swift
//  MyMapp
//
//  Created by Akash on 12/03/22.
//

import Foundation
class TravelAdviceDataModel{
    
    enum EnumAdviceType:Int {
    case topTips = 1, stories, logistics
    }
    var isExpand = false
    var isSaved = false
    var id  = 0
    var savedCount = 0
    var key = 0
    var subTitle = ""
    var title = ""
    var savedId = 0
    var enumAdviceType:EnumAdviceType{
        return EnumAdviceType.init(rawValue: key) ?? .topTips
    }
    
    init() {}
    init(param:JSON) {
        self.isSaved = param["isSaved"].boolValue
        self.id = param["id"].intValue
        self.savedCount = param["savedCount"].intValue
    }
    
    var userName = ""
    var userProfilePic = ""
    var savedComment = ""
    var userId = 0
    var travelEnumTypeValue = 0
    init(savedObject param:JSON) {
        self.userId = param["userId"].intValue
        self.id = param["id"].intValue
        self.userName = param["userDisplayName"].stringValue
        self.userProfilePic = param["profilePicPath"].stringValue
        self.savedComment = param["comment"].stringValue
        
        if let topTips = param["1"].string{
            savedComment = topTips
            travelEnumTypeValue = 1
        }
        
        if let stories = param["2"].string{
            savedComment = stories
            travelEnumTypeValue = 2
        }

        if let logistic = param["3"].string{
            savedComment = logistic
            travelEnumTypeValue = 3
        }
    }
}
