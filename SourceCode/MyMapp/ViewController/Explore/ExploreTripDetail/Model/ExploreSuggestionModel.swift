//
//  ExploreSuggestionModel.swift
//  MyMapp
//
//  Created by Akash  on 24/03/22.
//

import SwiftyJSON

struct ExploreSuggestionDataModel{

    enum EnumCellType {
        case covid19(String), languagesAndCurrencies(String)
        
        init?(typeName: String) {
            switch typeName {
            case "Language", "Currency":
                self = .languagesAndCurrencies(typeName)
            default:
                self = .covid19(typeName)
            }
        }
        
        var subType: String {
            switch self {
            case .covid19(let subType): return subType
            case .languagesAndCurrencies(let subType): return subType
            }
        }
        
    }
    
    struct ExploreSuggestionItemDataModel {
        var title = ""
        var detail = ""
    }
    
    var type = ""
    var title = ""
    var items = [ExploreSuggestionItemDataModel]()

    var cellType = EnumCellType.covid19("")
    var isOpenCell = false
    
    init() { }
    
    init(param: JSON) {
//        let typeName = param["category"]["suggestionCategory"]["value"].stringValue
        let typeName = param["category"]["value"].stringValue
        guard let cellType = EnumCellType(typeName: typeName) else {
            return
        }
        self.cellType = cellType
        switch cellType {
        case .covid19:
            title = typeName
        case .languagesAndCurrencies:
            title = "Languages and Currencies"
        }
        items.removeAll()
        param["suggestion"].stringValue.components(separatedBy: ",").forEach { item in
            items.append(ExploreSuggestionItemDataModel(title: cellType.subType, detail: item))
        }
        
//        "id" : 3,
//        "category" : {
//          "suggestionCategory" : {
//            "key" : "CITY_SUGGESTION",
//            "placeholder" : "Update the list of languages used in this city",
//            "value" : "Language",
//            "id" : 9
//          },
//          "id" : 3
//        },
//        "suggestion" : "sample suggestion"
  }
    
    mutating func mergeLanguagesAndCurrencies(data2: ExploreSuggestionDataModel) {
        var data = ExploreSuggestionDataModel()
        if self.cellType.subType == "Language" {
            data = self
            data2.items.forEach { item in
                data.items.append(item)
            }
        } else {
            data = data2
            self.items.forEach { item in
                data.items.append(item)
            }
        }
        self = data
    }
    
}
