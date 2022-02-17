//
//  ActivityHomeViewModel.swift
//  MyMapp
//
//  Created by Akash on 17/02/22.
//

import Foundation
import UIKit

class ActivityHomeViewModel{
    
    enum EnumActivityType {
        case today, currentWeek, lastWeek
    }
    
    var arrayTodayList = [String]()
    var arrayCurrentWeekList = [String]()
    var arrayLastWeekList = [String]()
    var arraySections = [EnumActivityType]()

    init() {
        arraySections.removeAll()
        arraySections.append(.today)
        arraySections.append(.currentWeek)
        arraySections.append(.lastWeek)
    }
}
