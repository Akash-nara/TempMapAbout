//
//	RootClass.swift
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation 
import SwiftyJSON


class TagListModel : NSObject, NSCoding{

	var id : Int!
	var name : String!
	var subTagsList : [SubCategoryListModel]!
    var isSelected = false

	/**
	 * Instantiate the instance using the passed json values to set the properties values
	 */
	init(fromJson json: JSON!){
		if json.isEmpty{
			return
		}
		id = json["id"].intValue
		name = json["name"].stringValue
        subTagsList = [SubCategoryListModel]()
        let interestsArray = json["subTagsList"].arrayValue
        for interestsJson in interestsArray{
            let value = SubCategoryListModel(fromJson: interestsJson)
            subTagsList.append(value)
        }
	}

	/**
	 * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
	 */
	func toDictionary() -> [String:Any]
	{
		var dictionary = [String:Any]()
		if id != nil{
			dictionary["id"] = id
		}
		if name != nil{
			dictionary["name"] = name
		}
		if subTagsList != nil{
			dictionary["subTagsList"] = subTagsList
		}
		return dictionary
	}

    /**
    * NSCoding required initializer.
    * Fills the data from the passed decoder
    */
    @objc required init(coder aDecoder: NSCoder)
	{
         id = aDecoder.decodeObject(forKey: "id") as? Int
         name = aDecoder.decodeObject(forKey: "name") as? String
         subTagsList = aDecoder.decodeObject(forKey: "subTagsList") as? [SubCategoryListModel]

	}

    /**
    * NSCoding required method.
    * Encodes mode properties into the decoder
    */
    func encode(with aCoder: NSCoder)
	{
		if id != nil{
			aCoder.encode(id, forKey: "id")
		}
		if name != nil{
			aCoder.encode(name, forKey: "name")
		}
		if subTagsList != nil{
			aCoder.encode(subTagsList, forKey: "subTagsList")
		}

	}

}
