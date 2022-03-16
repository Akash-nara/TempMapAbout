//
//	RootClass.swift
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation 
import SwiftyJSON


class TripApiPassModel : NSObject, NSCoding{

	var additionalInfo : AdditionalInfo!
	var bucketHash : String!
	var city : Int!
	var descriptionField : String!
	var tripDate : String!
	var tripEndDate : String!
	var tripLocationList : [TripLocationList]!


	init(fromJson json: JSON!){
		if json.isEmpty{
			return
		}
		let additionalInfoJson = json["additionalInfo"]
		if !additionalInfoJson.isEmpty{
			additionalInfo = AdditionalInfo(fromJson: additionalInfoJson)
		}
        
        
		bucketHash = json["bucketHash"].stringValue
		city = json["city"].intValue
		descriptionField = json["description"].stringValue
		tripDate = json["tripDate"].stringValue
		tripEndDate = json["tripEndDate"].stringValue
		tripLocationList = [TripLocationList]()
        
		let tripLocationListArray = json["tripLocationList"].arrayValue
		for tripLocationListJson in tripLocationListArray{
			let value = TripLocationList(fromJson: tripLocationListJson)
			tripLocationList.append(value)
		}
	}

	/**
	 * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
	 */
	func toDictionary() -> [String:Any]
	{
		var dictionary = [String:Any]()
		if additionalInfo != nil{
			dictionary["additionalInfo"] = additionalInfo.toDictionary()
		}
		if bucketHash != nil{
			dictionary["bucketHash"] = bucketHash
		}
		if city != nil{
			dictionary["city"] = city
		}
		if descriptionField != nil{
			dictionary["description"] = descriptionField
		}
		if tripDate != nil{
			dictionary["tripDate"] = tripDate
		}
		if tripEndDate != nil{
			dictionary["tripEndDate"] = tripEndDate
		}
		if tripLocationList != nil{
			var dictionaryElements = [[String:Any]]()
			for tripLocationListElement in tripLocationList {
				dictionaryElements.append(tripLocationListElement.toDictionary())
			}
			dictionary["tripLocationList"] = dictionaryElements
		}
		return dictionary
	}

    /**
    * NSCoding required initializer.
    * Fills the data from the passed decoder
    */
    @objc required init(coder aDecoder: NSCoder)
	{
         additionalInfo = aDecoder.decodeObject(forKey: "additionalInfo") as? AdditionalInfo
         bucketHash = aDecoder.decodeObject(forKey: "bucketHash") as? String
         city = aDecoder.decodeObject(forKey: "city") as? Int
         descriptionField = aDecoder.decodeObject(forKey: "description") as? String
         tripDate = aDecoder.decodeObject(forKey: "tripDate") as? String
         tripEndDate = aDecoder.decodeObject(forKey: "tripEndDate") as? String
         tripLocationList = aDecoder.decodeObject(forKey: "tripLocationList") as? [TripLocationList]

	}

    /**
    * NSCoding required method.
    * Encodes mode properties into the decoder
    */
    func encode(with aCoder: NSCoder)
	{
		if additionalInfo != nil{
			aCoder.encode(additionalInfo, forKey: "additionalInfo")
		}
		if bucketHash != nil{
			aCoder.encode(bucketHash, forKey: "bucketHash")
		}
		if city != nil{
			aCoder.encode(city, forKey: "city")
		}
		if descriptionField != nil{
			aCoder.encode(descriptionField, forKey: "description")
		}
		if tripDate != nil{
			aCoder.encode(tripDate, forKey: "tripDate")
		}
		if tripEndDate != nil{
			aCoder.encode(tripEndDate, forKey: "tripEndDate")
		}
		if tripLocationList != nil{
			aCoder.encode(tripLocationList, forKey: "tripLocationList")
		}

	}

}
