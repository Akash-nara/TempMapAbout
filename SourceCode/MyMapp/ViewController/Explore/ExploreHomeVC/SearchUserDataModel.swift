//
//  SearchUserDataModel.swift
//  MyMapp
//
//  Created by Akash Nara on 27/03/22.
//

import Foundation


class SearchUserDataModel:Equatable {
    static func == (lhs: SearchUserDataModel, rhs: SearchUserDataModel) -> Bool {
        return lhs.id == rhs.id
    }
    
    var id = 0
    var displayName = ""
    
    init(param:JSON) {
        self.id = param["id"].intValue
        self.displayName = param["displayName"].stringValue
    }
    
}
