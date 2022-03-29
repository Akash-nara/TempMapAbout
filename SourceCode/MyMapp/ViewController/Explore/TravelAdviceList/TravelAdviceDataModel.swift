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
    var enumAdviceType:EnumAdviceType{
        return EnumAdviceType.init(rawValue: key) ?? .topTips
    }
    
    init() {}
    init(param:JSON) {
        self.isSaved = param["isSaved"].boolValue
        self.id = param["id"].intValue
        self.savedCount = param["savedCount"].intValue
    }
}
