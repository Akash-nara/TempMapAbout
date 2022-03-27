//
//  TripDataModel.swift
//  MyMapp
//
//  Created by Akash on 27/01/22.
//

import Foundation
import SwiftyJSON
import MapKit

struct TripDataModel{
    
    
//    struct UserCreatedTrip{
//        var username = ""
//        var profilePic = ""
//        var region = ""
//        
//        init() {}
//        init(param:JSON) {
//            self.username = param["username"].stringValue
//            self.profilePic = param["profilePic"].stringValue
//            self.region = param["region"].stringValue
//        }
//    }
    struct TripCity{
        var cityName = ""
        var countryName = ""
        var id = 0
        var countryCode = ""
        
        init() {}
        init(param:JSON) {
            self.cityName = param["cityName"].stringValue
            self.countryName = param["country"].stringValue
            self.countryCode = param["countryCode"].stringValue
            self.id = param["id"].intValue
        }
    }
    
    struct TripFavLocations{
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
    var advicesOfArray = [EnumTripSection]()
    var advicesOfArrayOfDataModel = [TravelAdviceDataModel]()
    var isBookmarked = false
    var isLiked = false
    var bookmarkedTotalCount = 0
    var likedTotalCount = 0
    mutating func increaeeDecreaseBookmarkCount(){
        if isBookmarked{
            bookmarkedTotalCount += 1
        }else{
            if bookmarkedTotalCount != 0{
                bookmarkedTotalCount -= 1
            }
        }
    }
    
    mutating func increaeeDecreaseLikeUNLIkeCount(){
        if isLiked{
            likedTotalCount += 1
        }else{
            if likedTotalCount != 0{
                likedTotalCount -= 1
            }
        }
    }

    func UTCToLocal(date:Date) -> Date? {
        let localDateFormatter = DateFormatter()
        // No timeZone configuration is required to obtain the
        // local time from DateFormatter.

        // Printing a Date
        let date = date
        print(localDateFormatter.string(from: date))
        // Parsing a string representing a date
        let dateString = "May 30, 2020"
        guard let localDate = localDateFormatter.date(from: dateString) else { return nil }
       return localDate
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
    
    func relativeDate(for date:Date) -> String {
         let components = Calendar.current.dateComponents([.day, .year, .month, .weekOfYear], from: date, to: Date())
         if let year = components.year, year == 1{
             return "\(year) year"
         }
         if let year = components.year, year > 1{
             return "\(year) years"
         }
         if let month = components.month, month == 1{
             return "\(month) month"
         }
         if let month = components.month, month > 1{
             return "\(month) months"
         }

         if let week = components.weekOfYear, week == 1{
             return "\(week) week"
         }
         if let week = components.weekOfYear, week > 1{
             return "\(week) weeks"
         }        
         if let day = components.day{
             if day > 1{
                 return "\(day) days"
             }else{
                 return "Yesterday"
             }
         }
         return "Today"
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
                let id = jsonObject.dictionaryValue["id"]?.intValue
                let isSaved = jsonObject.dictionaryValue["isSaved"]?.boolValue
                let model = TravelAdviceDataModel.init(param: jsonObject)
                
                if jsonObject.dictionaryValue.keys.contains("1"){
                    model.key = 1
                    model.title = "Top Tip"
                    advicesOfArray.append(.topTips("Top Tip", jsonObject.dictionaryValue["1"]?.stringValue ?? "",id,isSaved))
                }else if jsonObject.dictionaryValue.keys.contains("2"){
                    model.key = 2
                    model.title = "Favorite Travel Story"
                    advicesOfArray.append(.travelStory("Favorite Travel Story", jsonObject.dictionaryValue["2"]?.stringValue ?? "",id,isSaved))
                }else if jsonObject.dictionaryValue.keys.contains("3"){
                    model.key = 3
                    model.title = "Logistics & Tips"
                    advicesOfArray.append(.logisticsRoute("Logistics & Tips", jsonObject.dictionaryValue["3"]?.stringValue ?? "",id,isSaved))
                }
                model.subTitle = jsonObject.dictionaryValue["\(model.key)"]?.stringValue ?? ""
                advicesOfArrayOfDataModel.append(model)
            }
        }
        
//        advicesOfArray.removeAll()
//        advicesOfArray.append(.topTips("Top Tip", "adajddjanalkdadljkadnadljkandajldkandadda"))
//        advicesOfArray.append(.travelStory("Favorite Travel Story", "dmadndlkjndalkdjnadlajdnadljkadnaldjdnadlajkdnaldjaksnas"))
//        advicesOfArray.append(.logisticsRoute("Logistics & Tips", "damdakldmadlakdmadlkamdaldkamdalkdmadlakdmadlkdmadlkdmd"))

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
    
    mutating func setCityData(json:JSON){
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
