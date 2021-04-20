//
//  ScheduleGenerateController.swift
//  Let'sGo
//
//  Created by KSU on 2019/5/7.
//  Copyright © 2019 KSU. All rights reserved.
//

import Foundation
import UIKit

class ScheduleCreateController {
    

    static let sightTypes = ["aquarium", "art_gallery", "church", "campground", "city_hall", "mosque", "museum", "park", "zoo", "stadium", "rv_park"]
    static let foodTypes = ["bakery", "bar", "cafe", "convenience_store", "restaurant", "supermarket", "liquor_store", "meal_delivery", "meal_takeaway", "pharmacy", "store"]
    static let shoppingTypes = ["book_store", "clothing_store", "convenience_store", "department_store", "electronics_store", "furniture_store", "home_goods_store", "jewelry_store"]
    static let socialTypes = ["zoo", "park", "beauty_salon", "book_store", "gym", "night_club", "pet_store", "stadium", "subway_station", "train_station"]
    
    static let oddTypes = ["airport", "atm", "bar", "car_rental", "cemetery", "courthouse", "funeral_home", "hardware_store", "movie_theater", "pet_store", "physiotherapist", "post_office", "painter"]
    
    static let missionContent: [String]! = ["跟老闆聊天並合照", "向人詢問該地歷史", "找路人合唱一首歌並合照", "加到三位路人的好友", "找到並認出五種動植物"]
    
    static let themePlacesData = ["NCKU","Anping","GreatSouthGate","ZhengxingStreet","Chakam","GovernmentRoad"]
    
    static func getType(category: String) -> String{
        switch category {
        case "走走看看":
            return sightTypes.randomElement()!
        case "吃吃喝喝":
            return foodTypes.randomElement()!
        case "逛街購物":
            return shoppingTypes.randomElement()!
        case "交新朋友":
            return socialTypes.randomElement()!
        case "神秘行程":
            return oddTypes.randomElement()!
        default:
            return "cafe"
        }
    }
    
    static func getMission() -> String{
        return missionContent.randomElement()!
    }
    
    static func getThemeJsonData() -> String{
        return themePlacesData.randomElement()!
    }
    
}
