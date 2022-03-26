//
//  FeedHomeViewModel.swift
//  MyMapp
//
//  Created by Akash on 16/02/22.
//

import Foundation
class FeedHomeViewModel {
    
    var arrayOfTripList = [TripDataModel]()
    
    init() {
//        loadStaticData()
    }
    
    func loadStaticData(){
        arrayOfTripList.removeAll()
        arrayOfTripList.append(TripDataModel())
        arrayOfTripList.append(TripDataModel())
        arrayOfTripList.append(TripDataModel())
        arrayOfTripList.append(TripDataModel())
        arrayOfTripList.append(TripDataModel())
        arrayOfTripList.append(TripDataModel())
        arrayOfTripList.append(TripDataModel())
        arrayOfTripList.append(TripDataModel())
        arrayOfTripList.append(TripDataModel())
        arrayOfTripList.append(TripDataModel())
        arrayOfTripList.append(TripDataModel())
        arrayOfTripList.append(TripDataModel())
    }
    
    func getTripListApi(paramDict:[String:Any],success: (([String: JSON]?) -> ())? = nil){
        let pageNo = JSON.init(paramDict)["pager"]["currentPage"].intValue
        let strJson = JSON(paramDict).rawString(.utf8, options: .sortedKeys) ?? ""
        let param: [String: Any] = ["requestJson" : strJson]
        API_SERVICES.callAPI(param, path: .getFeedList, method: .post) { response in
            guard let feedList = response?["responseJson"]?["feed"].arrayValue, let totalRecord =  response?["responseJson"]?["totalRecord"].intValue else {
                return
            }
            self.totalElements = totalRecord
            if pageNo == 1 { self.arrayOfTripList.removeAll() }
//            debugPrint(feedList)
            for obj in feedList{
                self.arrayOfTripList.append(TripDataModel.init(param: obj))
            }
            success?(nil)
        } failureInform: {
            HIDE_CUSTOM_LOADER()
            success?(nil)
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
    
    func addNewTripInArray(objTripModel:TripDataModel){
        totalElements += 1
        arrayOfTripList.insert(objTripModel, at: 0)
    }
}
