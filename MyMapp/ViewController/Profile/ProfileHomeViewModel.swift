//
//  ProfileHomeViewModel.swift
//  MyMapp
//
//  Created by Akash on 29/01/22.
//

import Foundation
class ProfileHomeViewModel{
    
    var arrayOfTripList = [TripDataModel]()
    func getTripListApi(paramDict:[String:Any],success: (([String: JSON]?) -> ())? = nil){
        let pageNo = JSON.init(paramDict)["pager"]["currentPage"].intValue
        let strJson = JSON(paramDict).rawString(.utf8, options: .sortedKeys) ?? ""
        let param: [String: Any] = ["requestJson" : strJson]
        API_SERVICES.callAPI(param, path: .getTripList, method: .post) { response in
            guard let feedList = response?["responseJson"]?["feed"].arrayValue, let totalRecord =  response?["responseJson"]?["totalRecord"].intValue else {
                return
            }
            self.totalElements = totalRecord
            if pageNo == 1 { self.arrayOfTripList.removeAll() }
            debugPrint(feedList)
            for obj in feedList{
                self.arrayOfTripList.append(TripDataModel.init(param: obj))
            }
            success?(nil)
        } failureInform: {
            HIDE_CUSTOM_LOADER()
        }
    }
    
    
    var isTripListFetched: Bool = false
    // Pagination work for Binding Rule
    private var totalElements = 0
    var getAvailableElements: Int { return arrayOfTripList.count }
    var getTotalElements: Int { return totalElements }
    private let pageSize = 5
    func getPageDict(_ isFromPullToRefresh: Bool) -> [String: Any] {
        // here 1 for requested list
        func getPageNo() -> Int {
            if isFromPullToRefresh {
                return 1
            } else {
                let passingValue = (getAvailableElements / pageSize) + 1
                debugPrint("Passing value: \(passingValue)")
                return passingValue
            }
        }
        return ["currentPage": getPageNo(), "pageSize": pageSize,"sortOrder":2]
    }
    
    
    func getOtherUserDetail(success: ((AppUser?) -> ())? = nil){
        API_SERVICES.callAPI(path: .getUserDetail, method: .get) { response in
            guard let feedList = response?["responseJson"] else {
                return
            }
            let objUser:AppUser? = AppUser.init(parameterProfile: feedList)
            success?(objUser)
        } failureInform: {
            HIDE_CUSTOM_LOADER()
        }
    }
}

