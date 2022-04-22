//
//  TripDataModel.swift
//  MyMapp
//
//  Created by Akash on 27/01/22.
//

import Foundation
import SwiftyJSON
import MapKit

class TripDataModel{
    
    
    class TripCity{
        var cityName = ""
        var countryName = ""
        var id = 0
        var countryCode = ""
        var longitude:Double = 0.0
        var latitude:Double = 0.0

        init() {}
        init(param:JSON) {
            self.cityName = param["cityName"].stringValue
            self.countryName = param["country"].stringValue
            self.countryCode = param["countryCode"].stringValue
            self.id = param["id"].intValue
            self.longitude = param["longitude"].doubleValue
            self.latitude = param["latitude"].doubleValue
        }
    }
    
    class TripFavLocations{
        var name = ""
        var longitude:Double = 0.0
        var latitude:Double = 0.0
        var id = 0
        
        init() {}
        init(param:JSON) {
            self.id = param["id"].intValue
            self.name = param["name"].stringValue
            self.longitude = param["longitude"].doubleValue
            self.latitude = param["latitude"].doubleValue
        }
    }
    
    
    class TripPhotoDetails{
        
        struct TripImage {
            var isVerticle:Bool{
                return width < height
            }
            var isDummyItem = false
            var itemHeight:CGFloat = 0
            
            var image = ""
            var height:Double = 0
            var width:Double = 0
            var isDefaultImage:Bool=false
            var isLocationImage = false

        }
        var hash = ""
        var arrayOfImageURL = [TripImage]()
        init() {}
        init(param:JSON, deafultImageName:String = "", isLocationImage:Bool=false) {
            self.hash = param["hash"].stringValue
            param["imageArray"].arrayValue.forEach { objJson in
                let arraySplited = objJson.stringValue.components(separatedBy: ",")
                var objTripImage = TripImage.init()
                if let imgUrl = arraySplited.first{
                    objTripImage.image = imgUrl
                }
                if arraySplited.indices.contains(1){
                    objTripImage.width = Double(arraySplited[1].replacingOccurrences(of: "px", with: "")) ?? 0
                }
                
                if arraySplited.indices.contains(2){
                    objTripImage.height = Double(arraySplited[2].replacingOccurrences(of: "px", with: "")) ?? 0
                }
                debugPrint(deafultImageName)
                if deafultImageName == objTripImage.image{
                    objTripImage.isDefaultImage = true
                }
                
                objTripImage.isLocationImage = isLocationImage
                self.arrayOfImageURL.append(objTripImage)

            }
        }
    }
    
    var heightOfImage:CGFloat = 0
    var isVerticalImage = false
    var id = 0
    var bucketHash = ""
    var tripDate:Int64 = 0
    var photoCount = 0
    var city = TripCity()
    var tripEndDate : Int64 = 0

    var locationList = [AddTripFavouriteLocationDetail]()
    var photoUploadedArray = [TripPhotoDetails]()
    var tripDescription = ""
    var advicesOfArrayOfDataModel = [TravelAdviceDataModel]()
    var isBookmarked = false
    var isLiked = false
    var bookmarkedTotalCount = 0
    var likedTotalCount = 0
    func increaeeDecreaseBookmarkCount(){
        if isBookmarked{
            bookmarkedTotalCount += 1
        }else{
            if bookmarkedTotalCount != 0{
                bookmarkedTotalCount -= 1
            }
        }
    }
    
    func increaeeDecreaseLikeUNLIkeCount(){
        if isLiked{
            likedTotalCount += 1
        }else{
            if likedTotalCount != 0{
                likedTotalCount -= 1
            }
        }
    }

    var dateFromatedOftrip:String{
        let date = Date(timeIntervalSince1970: TimeInterval(tripDate/1000))
        let endDate = Date(timeIntervalSince1970: TimeInterval(tripEndDate/1000))
        let diffInDays = Calendar.current.dateComponents([.day], from: date, to: endDate).day ?? 0
        if diffInDays == 0{
            return "Today"
        }else{
            return diffInDays > 1 ? "\(diffInDays) days" : "\(diffInDays) day"
        }
    }

    var defaultImageKey = ""
    var arraYOfPhotoCount = [Int]()
    
    var userCreatedTrip:AppUser? = nil
    var monthYearOfTrip:String{
        let date = Date(timeIntervalSince1970: TimeInterval(tripDate/1000))
        
        let localDateFormatter = DateFormatter()
        localDateFormatter.dateFormat = "MMM, YYYY"
        localDateFormatter.timeZone = .current
        return localDateFormatter.string(from: date)
    }
    
    init(){}
    init(param:JSON) {
        
        self.defaultImageKey = param["defaultImageKey"].stringValue
        self.id = param["id"].intValue
        self.bucketHash = param["bucketHash"].stringValue
        self.city = TripCity.init(param: param["city"])
        self.bookmarkedTotalCount = param["savedCount"].intValue
        
        self.tripDate = param["tripDate"].int64Value
        self.tripEndDate = param["tripEndDate"].int64Value
                
        self.isBookmarked = param["isSaved"].boolValue
        self.photoCount = param["photoCount"].intValue
        self.tripDescription = param["description"].stringValue
        
        userCreatedTrip = AppUser.init(parameterProfile: param["user"])
        let photoArray = param["photoDetails"].dictionaryValue
        self.photoUploadedArray.removeAll()
        arraYOfPhotoCount.removeAll()
        photoArray.keys.forEach { jsonKey in
            let imageUrl = photoArray[jsonKey]?.arrayValue ?? []
            arraYOfPhotoCount.append(imageUrl.count)
//            let filterObj = locationList.filter({$0.locationHash == jsonKey}).first
            self.photoUploadedArray.append(TripPhotoDetails.init(param: JSON(["hash":jsonKey,"imageArray":imageUrl,
//                                                                              "cityName":filterObj.name,
//                                                                              "countryName":filterObj,
                                                                             ]), deafultImageName:defaultImageKey, isLocationImage:jsonKey != "default"))
        }
        
        locationList.removeAll()
        let arrayOfLocation = param["locationList"].arrayValue
        arrayOfLocation.forEach { jsonLocation in
            let firstObject = photoUploadedArray.filter({$0.hash == jsonLocation["hash"].stringValue}).first
            let imageFirstObjectOfLocation = firstObject?.arrayOfImageURL.first?.image ?? ""
            
            let objModel = AddTripFavouriteLocationDetail.init(param: jsonLocation)
            objModel.firstLocationImage = imageFirstObjectOfLocation
            locationList.append(objModel)
        }
                
        if let adviceArray = param["additionalInfo"].dictionary?["advice"]?.arrayValue{
            adviceArray.forEach { jsonObject in
                let model = TravelAdviceDataModel.init(param: jsonObject)
                advicesOfArrayOfDataModel.append(model)
            }
        }
    }
    
    
    var tripSavedId = 0
    init(withSavedFeed param:JSON) {
        self.tripDate = param["tripDate"].int64Value
        self.tripEndDate = param["tripEndDate"].int64Value
        self.city = TripCity.init(param: param["city"])
        self.id = param["id"].intValue
        self.isBookmarked = param["isSaved"].boolValue
        self.bookmarkedTotalCount = param["savedCount"].intValue
        
        let userJsonObj = param["user"]
        self.userCreatedTrip = AppUser.init(savedTrip: userJsonObj)
        self.defaultImageKey = userJsonObj["defaultImageKey"].stringValue

        let photoArray = param["photoDetails"].dictionaryValue
        self.photoUploadedArray.removeAll()
        arraYOfPhotoCount.removeAll()
        photoArray.keys.forEach { jsonKey in
            let imageUrl = photoArray[jsonKey]?.arrayValue ?? []
            arraYOfPhotoCount.append(imageUrl.count)
//            let filterObj = locationList.filter({$0.locationHash == jsonKey}).first
            self.photoUploadedArray.append(TripPhotoDetails.init(param: JSON(["hash":jsonKey,"imageArray":imageUrl,
//                                                                              "cityName":filterObj.name,
//                                                                              "countryName":filterObj,
                                                                             ]), deafultImageName:defaultImageKey, isLocationImage:jsonKey != "default"))
        }
        
        locationList.removeAll()
    }
    
    func setTimestamp(epochTime: String) -> String {
        let currentDate = Date()
        let epochDate = Date(timeIntervalSince1970: TimeInterval(epochTime)!)

        let calendar = Calendar.current
        let currentDay = calendar.component(.day, from: currentDate)
        let currentHour = calendar.component(.hour, from: currentDate)
        let currentMinutes = calendar.component(.minute, from: currentDate)
        let currentSeconds = calendar.component(.second, from: currentDate)

        let epochDay = calendar.component(.day, from: epochDate)
        let epochMonth = calendar.component(.month, from: epochDate)
        let epochYear = calendar.component(.year, from: epochDate)
        let epochHour = calendar.component(.hour, from: epochDate)
        let epochMinutes = calendar.component(.minute, from: epochDate)
        let epochSeconds = calendar.component(.second, from: epochDate)

        if (currentDay - epochDay < 30) {
            if (currentDay == epochDay) {
                if (currentHour - epochHour == 0) {
                    if (currentMinutes - epochMinutes == 0) {
                        if (currentSeconds - epochSeconds <= 1) {
                            return String(currentSeconds - epochSeconds) + " second"
                        } else {
                            return String(currentSeconds - epochSeconds) + " seconds"
                        }

                    } else if (currentMinutes - epochMinutes <= 1) {
                        return String(currentMinutes - epochMinutes) + " minute"
                    } else {
                        return String(currentMinutes - epochMinutes) + " minutes"
                    }
                } else if (currentHour - epochHour <= 1) {
                    return String(currentHour - epochHour) + " hour"
                } else {
                    return String(currentHour - epochHour) + " hours"
                }
            } else if (currentDay - epochDay <= 1) {
                return String(currentDay - epochDay) + " day"
            } else {
                return String(currentDay - epochDay) + " days"
            }
        } else {
            return String(epochDay) + " " + getMonthNameFromInt(month: epochMonth) + " " + String(epochYear)
        }
    }
    
    func setCityData(json:JSON){
        self.city = TripCity.init(param: json)
    }

    func getMonthNameFromInt(month: Int) -> String {
        switch month {
        case 1:
            return "Jan"
        case 2:
            return "Feb"
        case 3:
            return "Mar"
        case 4:
            return "Apr"
        case 5:
            return "May"
        case 6:
            return "Jun"
        case 7:
            return "Jul"
        case 8:
            return "Aug"
        case 9:
            return "Sept"
        case 10:
            return "Oct"
        case 11:
            return "Nov"
        case 12:
            return "Dec"
        default:
            return ""
        }
    }
}

extension Date {
    func get(_ components: Calendar.Component..., calendar: Calendar = Calendar.current) -> DateComponents {
        return calendar.dateComponents(Set(components), from: self)
    }

    func get(_ component: Calendar.Component, calendar: Calendar = Calendar.current) -> Int {
        return calendar.component(component, from: self)
    }
}
