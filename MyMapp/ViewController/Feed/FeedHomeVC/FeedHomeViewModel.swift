//
//  FeedHomeViewModel.swift
//  MyMapp
//
//  Created by Akash on 16/02/22.
//

import Foundation
class FeedHomeViewModel {
    
    var arrayOfFeed = [TripDataModel]()
    
    init() {
        loadStaticData()
    }
    
    func loadStaticData(){
        arrayOfFeed.removeAll()
        arrayOfFeed.append(TripDataModel())
        arrayOfFeed.append(TripDataModel())
        arrayOfFeed.append(TripDataModel())
        arrayOfFeed.append(TripDataModel())
        arrayOfFeed.append(TripDataModel())
        arrayOfFeed.append(TripDataModel())
        arrayOfFeed.append(TripDataModel())
        arrayOfFeed.append(TripDataModel())
        arrayOfFeed.append(TripDataModel())
        arrayOfFeed.append(TripDataModel())
        arrayOfFeed.append(TripDataModel())
        arrayOfFeed.append(TripDataModel())
        
    }
}
