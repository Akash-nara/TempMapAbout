//
//	TripLocationList.swift
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation 
import SwiftyJSON


class TripLocationList : NSObject, NSCoding{

	var location : Location!
	var notes : String!
	var tags : String!


	/**
	 * Instantiate the instance using the passed json values to set the properties values
	 */
	init(fromJson json: JSON!){
		if json.isEmpty{
			return
		}
		let locationJson = json["location"]
		if !locationJson.isEmpty{
			location = Location(fromJson: locationJson)
		}
		notes = json["notes"].stringValue
		tags = json["tags"].stringValue
	}
    
    init(fromDict dictionary : [String:Any]){

        if dictionary["location"] != nil{
            if let data = dictionary["location"] as? [String:Any]{
                self.location = Location.init(fromDict:data ) //
            }
            
        }
        if dictionary["notes"] != nil{
            if let data = dictionary["notes"] as? String{
                self.notes = data
            }
            
        }
        if dictionary["notes"] != nil{
            if let data = dictionary["tags"] as? String{
                self.tags = data
            }
        }
    }

	/**
	 * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
	 */
	func toDictionary() -> [String:Any]
	{
		var dictionary = [String:Any]()
		if location != nil{
			dictionary["location"] = location.toDictionary()
		}
		if notes != nil{
			dictionary["notes"] = notes
		}
		if tags != nil{
			dictionary["tags"] = tags
		}
		return dictionary
	}

    /**
    * NSCoding required initializer.
    * Fills the data from the passed decoder
    */
    @objc required init(coder aDecoder: NSCoder)
	{
         location = aDecoder.decodeObject(forKey: "location") as? Location
         notes = aDecoder.decodeObject(forKey: "notes") as? String
         tags = aDecoder.decodeObject(forKey: "tags") as? String

	}

    /**
    * NSCoding required method.
    * Encodes mode properties into the decoder
    */
    func encode(with aCoder: NSCoder)
	{
		if location != nil{
			aCoder.encode(location, forKey: "location")
		}
		if notes != nil{
			aCoder.encode(notes, forKey: "notes")
		}
		if tags != nil{
			aCoder.encode(tags, forKey: "tags")
		}

	}

}
