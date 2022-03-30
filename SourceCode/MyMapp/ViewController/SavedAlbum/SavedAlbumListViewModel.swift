//
//  SavedAlbumListViewModel.swift
//  MyMapp
//
//  Created by Akash Nara on 29/03/22.
//

import Foundation

import Foundation

class SavedAlbumListViewModel{
    
    var arrayOfTripList = [TripDataModel]()
    func getSavedTripListApi(paramDict:[String:Any],success: (([String: JSON]?) -> ())? = nil){
        let pageNo = JSON.init(paramDict)["pager"]["currentPage"].intValue
        let strJson = JSON(paramDict).rawString(.utf8, options: .sortedKeys) ?? ""
        let param: [String: Any] = ["requestJson" : strJson]
        API_SERVICES.callAPI(param, path: .getSavedTripList, method: .post) { response in
            guard let feedList = response?["responseJson"]?["feeds"].arrayValue, let totalRecord =  response?["responseJson"]?["totalRecord"].intValue else {
                return
            }
            self.totalElements = totalRecord
            if pageNo == 1 { self.arrayOfTripList.removeAll() }
            debugPrint(feedList)
            for obj in feedList{
                let objSavedModel = TripDataModel.init(withSavedFeed: obj["feed"])
                objSavedModel.tripSavedId = obj["id"].intValue
                self.arrayOfTripList.append(objSavedModel)
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
    private let pageSize = 10
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
    
    
    func getOtherUserDetail(otherUserId:Int,success: ((AppUser?) -> ())? = nil){
        API_SERVICES.callAPI(path: .getUserDetail(otherUserId), method: .get) { response in
            guard let feedList = response?["responseJson"] else {
                return
            }
            let objUser:AppUser? = AppUser.init(parameterProfile: feedList)
            success?(objUser)
        } failureInform: {
            HIDE_CUSTOM_LOADER()
        }
    }
    
    func updateCount(id:Int){
        if let index = self.arrayOfTripList.firstIndex(where: {$0.id == id}){
            arrayOfTripList.remove(at: index)
            totalElements -= 1
        }
    }
}

