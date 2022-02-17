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
    
    struct TripCity{
        var cityName = ""
        var countryName = ""
        var id = 0
        
        init() {}
        init(param:JSON) {
            self.cityName = param["cityName"].stringValue
            self.countryName = param["country"].stringValue
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
                return width > height
            }
            var image = ""
            var isDummyItem = false
            var itemHeight:CGFloat = 0
            
            var height = ""
            var width = ""
        }
        var hash = ""
        var arrayOfImageURL = [TripImage]()
        
        init() {}
        init(param:JSON) {
            self.hash = param["hash"].stringValue
            param["imageArray"].arrayValue.forEach { objJson in
                let arraySplited = objJson.stringValue.components(separatedBy: ",")
                var objTripImage = TripImage.init()
                if let imgUrl = arraySplited.first{
                    objTripImage.image = imgUrl
                }
                if arraySplited.indices.contains(1){
                    objTripImage.width = arraySplited[1].replacingOccurrences(of: "px", with: "")
                }
                
                if arraySplited.indices.contains(2){
                    objTripImage.height = arraySplited[2].replacingOccurrences(of: "px", with: "")
                }
                self.arrayOfImageURL.append(objTripImage)

            }
//            self.arrayOfImageURL = param["imageArray"].arrayValue
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
    var photoUploadedArrayDetail = [TripPhotoDetails]()
    var tripDescription = ""
    var advicesOfArray = [EnumTripSection]()
    var isBookmarked = false
    var isLiked = false
    var bookmarkedTotalCount = 0
    var likedTotalCount = 0

    
    /*
    func processDetailArray(){
        photoUploadedArrayDetail.removeAll()
        photoUploadedArrayDetail.append(TripDataModel.TripPhotoDetails.TripImage.init(isVerticle: false, image: ""))
        photoUploadedArrayDetail.append(TripDataModel.TripPhotoDetails.TripImage.init(isVerticle: true, image: ""))
        photoUploadedArrayDetail.append(TripDataModel.TripPhotoDetails.TripImage.init(isVerticle: true, image: ""))
        photoUploadedArrayDetail.append(TripDataModel.TripPhotoDetails.TripImage.init(isVerticle: true, image: ""))
//        photoUploadedArrayDetail.append(TripDataModel.TripPhotoDetails.TripImage.init(isVerticle: false, image: ""))
//        photoUploadedArrayDetail.append(TripDataModel.TripPhotoDetails.TripImage.init(isVerticle: true, image: ""))
//        photoUploadedArrayDetail.append(TripDataModel.TripPhotoDetails.TripImage.init(isVerticle: false, image: ""))
        photoUploadedArrayDetail.append(TripDataModel.TripPhotoDetails.TripImage.init(isVerticle: true, image: ""))
        photoUploadedArrayDetail.append(TripDataModel.TripPhotoDetails.TripImage.init(isVerticle: true, image: ""))
        photoUploadedArrayDetail.append(TripDataModel.TripPhotoDetails.TripImage.init(isVerticle: true, image: ""))

        
        photoUploadedArrayDetail.append(TripDataModel.TripPhotoDetails.TripImage.init(isVerticle: true, image: ""))
        photoUploadedArrayDetail.append(TripDataModel.TripPhotoDetails.TripImage.init(isVerticle: true, image: ""))

        var collectionViewHeight:CGFloat = 500
        var longCellHeight = ((collectionViewHeight - 10 - 10)/5)*2 //231
        var smallCellHeight = (collectionViewHeight - 10 - 10)/5

        let localArray = photoUploadedArrayDetail
        var dummyItemCount = 0
        var columHeight:CGFloat = 0
    
        
        for (i, obj) in localArray.enumerated(){
            var indexMain: Int { i + dummyItemCount }
            var itemHeight = photoUploadedArrayDetail[indexMain].isVerticle ? longCellHeight : smallCellHeight
            print("columHeight Begin: \(columHeight)")
            if !columHeight.isZero {
                columHeight += 10
            }
            columHeight += itemHeight
                
            if columHeight > collectionViewHeight{
                columHeight -= itemHeight
                itemHeight = collectionViewHeight - columHeight
                columHeight += itemHeight
                photoUploadedArrayDetail.insert(
                    TripDataModel.TripPhotoDetails.TripImage(isVerticle: false, image: "", isDummyItem: true, itemHeight: itemHeight),
                    at: indexMain)
                dummyItemCount += 1
//                columHeight = 0
            }
            photoUploadedArrayDetail[indexMain].itemHeight = itemHeight
            print("columHeight End: \(columHeight)")
            if columHeight == collectionViewHeight {
                columHeight = 0
            }
        }

    }*/
    
    var dateFromatedOftrip:String{
        let date = Date(timeIntervalSince1970: TimeInterval(tripDate == tripEndDate ? tripDate : tripEndDate))
        let diffInDays = Calendar.current.dateComponents([.day], from: date, to: Date()).day ?? 0
        if diffInDays == 0{
            return "Today"
        }else{
            return diffInDays > 1 ? "\(diffInDays) days" : "\(diffInDays) day"
        }
//        return "\(diffInDays) days"//self.setTimestamp(epochTime: tripDate == tripEndDate ? "\(tripDate)" : "\(tripEndDate)")//self.relativeDate(for: tripDate == tripEndDate ? startDate : endDate) //relativeDate
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
    
    init(){}
    init(param:JSON) {
        
        self.defaultImageKey = param["defaultImageKey"].stringValue
        self.id = param["id"].intValue
        self.bucketHash = param["bucketHash"].stringValue
        self.city = TripCity.init(param: param["city"])

        self.tripDate = param["tripDate"].int64Value
        if let endTrip = param["tripEndDate"].int64, endTrip != 0{
            self.tripEndDate = param["tripEndDate"].int64Value
        }else{
            self.tripEndDate = self.tripDate
        }
        self.photoCount = param["photoCount"].intValue
        self.tripDescription = param["description"].stringValue
        
        locationList.removeAll()
        let arrayOfLocation = param["locationList"].arrayValue
        arrayOfLocation.forEach { jsonLocation in
            locationList.append(AddTripFavouriteLocationDetail.init(param: jsonLocation))
        }
        
        
        let photoArray = param["photoDetails"].dictionaryValue
        self.photoUploadedArray.removeAll()
        arraYOfPhotoCount.removeAll()
        photoArray.keys.forEach { jsonKey in
            let imageUrl = photoArray[jsonKey]?.arrayValue ?? []
            arraYOfPhotoCount.append(imageUrl.count)
            let filterObj = locationList.filter({$0.locationHash == jsonKey}).first
            self.photoUploadedArray.append(TripPhotoDetails.init(param: JSON(["hash":jsonKey,"imageArray":imageUrl,
//                                                                              "cityName":filterObj.name,
//                                                                              "countryName":filterObj,
                                                                             ])))
        }
                
        if let adviceArray = param["additionalInfo"].dictionary?["advice"]?.arrayValue{
            adviceArray.forEach { jsonObject in
                if jsonObject.dictionaryValue.keys.contains("1"){
                    advicesOfArray.append(.topTips("Top Tip", jsonObject.dictionaryValue["1"]?.stringValue ?? ""))
                }else if jsonObject.dictionaryValue.keys.contains("2"){
                    advicesOfArray.append(.travelStory("Favorite Travel Story", jsonObject.dictionaryValue["2"]?.stringValue ?? ""))
                }else if jsonObject.dictionaryValue.keys.contains("3"){
                    advicesOfArray.append(.logisticsRoute("Logistics & Tips", jsonObject.dictionaryValue["3"]?.stringValue ?? ""))
                }
            }
        }
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
