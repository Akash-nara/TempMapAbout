//
//	Advice.swift
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation 
import SwiftyJSON


class Advice : NSObject, NSCoding{

	var one : String!
	var two : String!
	var three : String!


	/**
	 * Instantiate the instance using the passed json values to set the properties values
	 */
	init(fromJson json: JSON!){
		if json.isEmpty{
			return
		}
        one = json["1"].stringValue
		two = json["2"].stringValue
        three = json["3"].stringValue
	}

	/**
	 * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
	 */
	func toDictionary() -> [String:Any]
	{
		var dictionary = [String:Any]()
		if one != nil{
			dictionary["1"] = one
		}
		if two != nil{
			dictionary["2"] = two
		}
		if three != nil{
			dictionary["3"] = three
		}
		return dictionary
	}

    /**
    * NSCoding required initializer.
    * Fills the data from the passed decoder
    */
    @objc required init(coder aDecoder: NSCoder)
	{
         one = aDecoder.decodeObject(forKey: "1") as? String
         two = aDecoder.decodeObject(forKey: "2") as? String
         three = aDecoder.decodeObject(forKey: "3") as? String

	}

    /**
    * NSCoding required method.
    * Encodes mode properties into the decoder
    */
    func encode(with aCoder: NSCoder)
	{
		if one != nil{
			aCoder.encode(one, forKey: "1")
		}
		if two != nil{
			aCoder.encode(two, forKey: "2")
		}
		if three != nil{
			aCoder.encode(three, forKey: "3")
		}

	}

}
