//
//  Routing.swift
//  MyMapp
//
//  Created by Akash Nara on 22/12/20.
//  Copyright © 2021 Akash. All rights reserved.
//

import Foundation

enum Routing {
    
    case signIn
    case signUP
    case forgotPasswordApi
    
    case is_display_name_unique(String)
    case uploadPic
    case getUser
    case user
    case cityList
    case addTrip
    case getTags
    case getAdviceForCityTrip
    case updateCityTrip
    case uploadTripImage
    case generateLocationHash
    case deleteUploadedPhoto
    case getTripList
    case deleteTripLocation
    case getFeedList
    case getUserDetail(Int)
    case getAdminSuggestions
    case getListOfSuggestions
    case submitListOfSuggestions
    case saveTrip
    case getSearchUserList
    case unSaveTrip
    case getSavedTripList
    var getPath: String {
        switch self {
        case .signIn:
            return "api/public/signin"
        case .signUP:
            return "api/public/signup"
        case .forgotPasswordApi:
            return "api/public/forgotPassword"
            
        case .is_display_name_unique(let name):
            return "api/private/user/isDisplayNameUnique?displayName=\(name)"
        case .uploadPic:
            return "api/private/user/uploadPic"
        case .getUser:
            return "api/private/user/get-user"
        case .user:
            return "api/private/user"
        case .cityList:
            return "api/private/config/cityList"
        case .addTrip:
            return "api/private/feed/add"
        case .getTags:
            return "api/private/tags"
        case .getAdviceForCityTrip:
            return "api/private/config/getAdvices"
        case .updateCityTrip:
            return "api/private/feed/update"
        case .uploadTripImage:
            return "https://pv80m0iz3f.execute-api.us-east-1.amazonaws.com/dev/v1/"
        case .generateLocationHash:
            return "api/private/feed/generateHash"
        case .deleteUploadedPhoto:
            return "api/private/feed/deletePhoto"
        case .getTripList:
            return "api/private/feed/list"
        case .deleteTripLocation:
           return "api/private/feed/deleteTripLocation"
            
        case .getFeedList:
            return "api/private/feed/dashboard"

        case .getUserDetail(let id):
            return "api/private/user/\(id)"

        case .getAdminSuggestions:
            return "api/private/suggestion/public"
        case .getListOfSuggestions:
            return "api/private/suggestion/city/suggestions"
        case .submitListOfSuggestions:
            return "api/private/suggestion/add"
            
        case .saveTrip:
            return "api/private/event/add"
            
        case .getSearchUserList:
           return "api/private/user/search"
            
        case .unSaveTrip:
            return "api/private/event/delete"
            
        case .getSavedTripList:
            return "api/private/savedInterest/getUserSavedInterests"
        }
    }
}
