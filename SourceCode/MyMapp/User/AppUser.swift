//
//  User.swift
//  BaseProject
//
//  Created by MAC240 on 04/06/18.
//  Copyright © 2018 MAC240. All rights reserved.
//

import Foundation

class AppUser : NSObject, NSCoding {
    
    var accessToken: String?
    var refreshToken: String?
    
    var userId              :Int = 0
    var displayName        :String = ""
    var displayNameAdded              = false
    var profilePictureAdded          = false
    var profileStatus     :String = ""
    var emailVerified = false
    var emailId = ""
    var loggedin = false
    var profilePicPath = ""
    
    var firstName: String = ""
    var lastName: String = ""
    var fullName: String { return [firstName, lastName].removeEmptiesAndJoinWith(" ") }
    var timeout: Int = 0
    var userLocationCity:String?
    var userDescription:String?
    var followersCount: Int = 0
    
    
    /// This method is used to show card alert on application level
    /// :param: Dictionary is passed as `parameter` with all user data
    /// :returns: returns `User` object
    required init(parameter: JSON) {
        if parameter.isEmpty != true {
            self.userId = parameter["id"].intValue
            self.emailId = parameter["emailId"].stringValue
            self.displayName = parameter["displayName"].stringValue
            self.displayNameAdded = parameter["displayNameAdded"].boolValue
            self.profilePictureAdded = parameter["profilePictureAdded"].boolValue
            self.profileStatus = parameter["profile"].stringValue
            self.emailVerified = parameter["emailVerified"].boolValue
            
            self.loggedin = parameter["loggedin"].boolValue
            self.profilePicPath = parameter["profilePicPath"].stringValue
            
            self.userLocationCity = parameter["city"].stringValue
            self.userDescription = parameter["personalDescription"].stringValue
            self.followersCount = parameter["followers"].intValue
            
            if self.followersCount == 0{
                self.followersCount = Int(arc4random_uniform(3))
            }
        }
    }
    
    
    required init(loginResponse: JSON, authToken: String) {
        super.init()
        if loginResponse.isEmpty != true {
            self.accessToken = authToken
            self.update(profileResponse: loginResponse)
        }
    }

    var username = ""
    var region = ""
    func update(profileResponse: JSON) {
        debugPrint("userId parsed:=\(profileResponse["id"].intValue)")
        self.userId = profileResponse["id"].intValue
        self.emailId = profileResponse["emailId"].stringValue
        self.displayName = profileResponse["displayName"].stringValue
        self.displayNameAdded = profileResponse["displayNameAdded"].boolValue
        self.profilePictureAdded = profileResponse["profilePictureAdded"].boolValue
        self.profileStatus = profileResponse["profile"].stringValue
        self.emailVerified = profileResponse["emailVerified"].boolValue
        
        self.loggedin = profileResponse["loggedin"].boolValue
        if let path = profileResponse["profilePicPath"].string{
            self.profilePicPath = path
        }else if let path = profileResponse["profilePic"].string{
            self.profilePicPath = path
        }
        self.username = profileResponse["username"].stringValue
        
        self.userLocationCity = profileResponse["city"].stringValue
        self.userDescription = profileResponse["personalDescription"].stringValue
        self.followersCount = profileResponse["followers"].intValue
        self.region = profileResponse["region"].stringValue
        
        if self.followersCount == 0{
            self.followersCount = Int(arc4random_uniform(3))
        }
    }
    
    required init(accessToken: String, refreshToken: String) {
        self.accessToken = accessToken
        self.refreshToken = refreshToken
    }
    
    required init(parameterProfile: JSON) {
        super.init()
        self.update(profileResponse: parameterProfile)
    }
    
    required init(coder decoder: NSCoder) {
        
        self.userId = decoder.decodeInteger(forKey: "userId")
        self.followersCount = decoder.decodeInteger(forKey: "followersCount")

        if self.followersCount == 0{
            self.followersCount = Int(arc4random_uniform(3))
        }

        if let emailId = decoder.decodeObject(forKey: "emailId") as? String {
            self.emailId = emailId
        }
        if let displayName = decoder.decodeObject(forKey: "displayName") as? String {
            self.displayName = displayName
        }
        if let displayNameAdded = decoder.decodeBool(forKey: "displayNameAdded") as? Bool{
            self.displayNameAdded = displayNameAdded
        }
        if let profilePictureAdded = decoder.decodeBool(forKey: "profilePictureAdded") as? Bool{
            self.profilePictureAdded = profilePictureAdded
        }
        if let profileStatus = decoder.decodeObject(forKey: "profileStatus") as? String{
            self.profileStatus = profileStatus
        }
        if let emailVerified = decoder.decodeBool(forKey: "emailVerified") as? Bool{
            self.emailVerified = emailVerified
        }
        if let loggedin = decoder.decodeBool(forKey: "loggedin") as? Bool {
            self.loggedin = loggedin
        }
        if let profilePicPath = decoder.decodeObject(forKey: "profilePicPath") as? String {
            self.profilePicPath = profilePicPath
        }
        
        if let accessToken = decoder.decodeObject(forKey: "accessToken") as? String {
            self.accessToken = accessToken
        }
        
        if let userLocationCity = decoder.decodeObject(forKey: "userLocationCity") as? String {
            self.userLocationCity = userLocationCity
        }

        if let userDescription = decoder.decodeObject(forKey: "userDescription") as? String {
            self.userDescription = userDescription
        }
    }
    
    func encode(with encoder: NSCoder) {
        encoder.encode(self.followersCount, forKey: "followersCount")
        encoder.encode(self.userId, forKey: "userId")
        encoder.encode(self.emailId, forKey: "emailId")
        encoder.encode(self.displayName, forKey: "displayName")
        encoder.encode(self.displayNameAdded, forKey: "displayNameAdded")
        encoder.encode(self.profilePictureAdded, forKey: "profilePictureAdded")
        encoder.encode(self.profileStatus, forKey: "profileStatus")
        encoder.encode(self.emailVerified, forKey: "emailVerified")
        encoder.encode(self.loggedin, forKey: "loggedin")
        encoder.encode(self.profilePicPath, forKey: "profilePicPath")
        encoder.encode(self.accessToken, forKey: "accessToken")
        encoder.encode(self.userDescription, forKey: "userDescription")
        encoder.encode(self.userLocationCity, forKey: "userLocationCity")
    }
}

