//
//	RootClass.swift
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation 
import SwiftyJSON

class CityModel{

    var countryName:String!
    var countryCode:String = "IND"
    var cityName:String!
    var name : String!
	var id : Int!
	var latitude : Float!
	var longitude : Float!
	/**
	 * Instantiate the instance using the passed json values to set the properties values
	 */
	init(fromJson json: JSON!){
		if json.isEmpty{
			return
		}
        name = json["name"].stringValue
        if let first = name.components(separatedBy: ",").first?.trimSpace(){
            cityName = first
        }
        
        if let last = name.components(separatedBy: ",").last?.trimSpace(){
            countryName = last
        }
		id = json["id"].intValue
		latitude = json["latitude"].floatValue
		longitude = json["longitude"].floatValue
        self.countryCode = json["countryCode"].stringValue 
	}

}
