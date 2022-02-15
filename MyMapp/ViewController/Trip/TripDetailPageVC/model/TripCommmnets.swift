//
//  TripCommmnets.swift
//  MyMapp
//
//  Created by Akash on 15/02/22.
//

import Foundation

class TripCommmnets {
    var name = ""
    var id = 0
    var comment = ""
    var userImage = ""
    var bookmark = false
    
    var likeUnLiked = false
    init(){}
    
    init(param:JSON) {
        self.name = param["name"].stringValue
        self.id = param["id"].intValue
        self.comment = param["comment"].stringValue
        self.userImage = param["userImage"].stringValue
        self.likeUnLiked = param["likeUnLiked"].boolValue
        self.likeUnLiked = param["likeUnLiked"].boolValue
        
    }
}
