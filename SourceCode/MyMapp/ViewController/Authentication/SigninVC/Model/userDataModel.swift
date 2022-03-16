//
//	RootClass.swift
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation
import SwiftyJSON
import UIKit
import SwiftyJSON



class userDataModel: NSObject,NSCoding {
    
    var displayName = ""
    var displayNameAdded = false
    var emailId = ""
    var emailVerified = false
    var profilePicPath = ""
    var profilePictureAdded = false
    
    var preference = [NSDictionary]()
    static var shared: userDataModel = userDataModel()
    override init()
    {
        super.init()
        let encodedObject:NSData? = UserDefaults.standard.object(forKey: "taskTapUser") as? NSData
        if encodedObject != nil
        {
            let userDefaultsReference = UserDefaults.standard
            let encodedeObject:NSData = userDefaultsReference.object(forKey: "taskTapUser") as! NSData
            let kUSerObject:userDataModel = NSKeyedUnarchiver.unarchiveObject(with: encodedeObject as Data) as! userDataModel
            self.loadContent(fromUser: kUSerObject);
        }
    }
    
    @objc required init(coder aDecoder: NSCoder)
        {
             
            displayName = (aDecoder.decodeObject(forKey: "displayName") as? String)!
            displayNameAdded = (aDecoder.decodeBool(forKey: "displayNameAdded") as? Bool)!
            emailId = (aDecoder.decodeObject(forKey: "emailId") as? String)!
            emailVerified = (aDecoder.decodeBool(forKey: "emailVerified") as? Bool)!
            profilePicPath = (aDecoder.decodeObject(forKey: "profilePicPath") as? String)!
            profilePictureAdded = (aDecoder.decodeBool(forKey: "profilePictureAdded") as? Bool)!

        }

        /**
        * NSCoding required method.
        * Encodes mode properties into the decoder
        */
        func encode(with aCoder: NSCoder)
        {
            if displayName != nil{
                aCoder.encode(displayName, forKey: "displayName")
            }
            if displayNameAdded != nil{
                aCoder.encode(displayNameAdded, forKey: "displayNameAdded")
            }
            if emailId != nil{
                aCoder.encode(emailId, forKey: "emailId")
            }
            if emailVerified != nil{
                aCoder.encode(emailVerified, forKey: "emailVerified")
            }
            if profilePicPath != nil{
                aCoder.encode(profilePicPath, forKey: "profilePicPath")
            }
            if profilePictureAdded != nil{
                aCoder.encode(profilePictureAdded, forKey: "profilePictureAdded")
            }
            

        }
    
    init(fromJson json: JSON!){
        if json.isEmpty{
            return
        }
        displayName = json["displayName"].stringValue
        displayNameAdded = json["displayNameAdded"].boolValue
        emailId = json["emailId"].stringValue
        emailVerified = json["emailVerified"].boolValue
        profilePicPath = json["profilePicPath"].stringValue
        profilePictureAdded = json["profilePictureAdded"].boolValue

    }
    
    func loadUser() -> userDataModel
    {
        let userDefaultsReference = UserDefaults.standard
        let encodedeObject:NSData = userDefaultsReference.object(forKey: "taskTapUser") as! NSData
        let kUSerObject:userDataModel = NSKeyedUnarchiver.unarchiveObject(with: encodedeObject as Data) as! userDataModel
        return kUSerObject
    }
    
    
    private func loadContent(fromUser user:userDataModel) -> Void    {
        
        self.displayName = user.displayName
        self.displayNameAdded = user.displayNameAdded
        self.emailId = user.emailId
        self.emailVerified = user.emailVerified
        self.profilePicPath = user.profilePicPath
        self.profilePictureAdded = user.profilePictureAdded
        
        
        
    }
    
    func save() -> Void    {
        let encodedObject = NSKeyedArchiver.archivedData(withRootObject: self)
        UserDefaults.standard.setValue(encodedObject, forKey: "taskTapUser")
        UserDefaults.standard.synchronize()
    }
    
    func clear() -> Void
    {
        
        
        self.displayName = ""
        self.displayNameAdded = Bool()
        self.emailId = ""
        self.emailVerified = Bool()
        self.profilePicPath = ""
        self.profilePictureAdded = Bool()
        
        
        userDataModel.shared.save()
        
        //remove all user data from app
        UserDefaults.standard.removePersistentDomain(forName: Bundle.main.bundleIdentifier!)
        UserDefaults.standard.synchronize()
    }
    
    func setData(dict:JSON) -> Void {
        
        let json = dict
        if json.isEmpty{
            return
        }
        
        displayName = json["displayName"].stringValue
        displayNameAdded = json["displayNameAdded"].boolValue
        emailId = json["emailId"].stringValue
        emailVerified = json["emailVerified"].boolValue
        profilePicPath = json["profilePicPath"].stringValue
        profilePictureAdded = json["profilePictureAdded"].boolValue
        
        userDataModel.shared.save()
    }
    func setPrefranceData(dict:[NSDictionary]) -> Void {
        userDataModel.shared.preference = dict
        userDataModel.shared.save()
    }
}




