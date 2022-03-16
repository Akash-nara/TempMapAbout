//
//  UserLocationDataSetModel.swift
//  MyMapp
//
//  Created by Akash on 04/01/22.
//

import Foundation

struct UserLocationDataSetModel {
    
    var lattitude:Double = 0.000000
    var longitude:Double = 0.000000
    var address:String = ""
    var isPermissionAccess:Bool = false
    
    init() {}
    init(lattitude: Double, longitude: Double, address:String, isPermission:Bool){
        self.lattitude = lattitude
        self.longitude = longitude
        self.address = address
        self.isPermissionAccess = isPermission
    }
}
