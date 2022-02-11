//
//	AdditionalInfo.swift
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation 
import SwiftyJSON


class AdditionalInfo : NSObject, NSCoding{

	var advice : Advice!


	/**
	 * Instantiate the instance using the passed json values to set the properties values
	 */
	init(fromJson json: JSON!){
		if json.isEmpty{
			return
		}
		let adviceJson = json["advice"]
		if !adviceJson.isEmpty{
			advice = Advice(fromJson: adviceJson)
		}
	}

	/**
	 * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
	 */
	func toDictionary() -> [String:Any]
	{
		var dictionary = [String:Any]()
		if advice != nil{
			dictionary["advice"] = advice.toDictionary()
		}
		return dictionary
	}

    /**
    * NSCoding required initializer.
    * Fills the data from the passed decoder
    */
    @objc required init(coder aDecoder: NSCoder)
	{
         advice = aDecoder.decodeObject(forKey: "advice") as? Advice

	}

    /**
    * NSCoding required method.
    * Encodes mode properties into the decoder
    */
    func encode(with aCoder: NSCoder)
	{
		if advice != nil{
			aCoder.encode(advice, forKey: "advice")
		}

	}

}