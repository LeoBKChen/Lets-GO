//
//  NearbyPlacesController.swift
//  Let'sGo
//
//  Created by KSU on 2019/5/7.
//  Copyright © 2019 KSU. All rights reserved.
//

import Foundation
import UIKit
import CoreLocation
import Alamofire

    // https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=22.966623,%20120.294835&radius=1500&type=gym&key=AIzaSyBYMLqPtkWYHAGOZwDVHebF6HiiZwliG2M
    //https://developers.google.com/places/web-service/supported_types
class NearbyPlacesController {

    static let searchApiHost = "https://maps.googleapis.com/maps/api/place/nearbysearch/json"

    static func getNearbyPlaces(type:String, radius:String, coordinates:CLLocationCoordinate2D, token: String?, completion: @escaping (QNearbyPlacesResponse?) -> Void) {

        var params : [String : Any]
        
        if let t = token {
            params = [
                "key" : CONFIG.googlePlacesAPIKey,
                "pagetoken" : t,
            ]
        } else {
            params = [
                "key" : CONFIG.googlePlacesAPIKey,
                "radius" : radius,
                "location" : "\(coordinates.latitude),\(coordinates.longitude)",
                "type" : type.lowercased()
            ]
        }
        print(params)
        Alamofire.request(searchApiHost, parameters: params, encoding: URLEncoding(destination: .queryString)).responseJSON(completionHandler: { response in
            
            if let json = response.result.value {
                print("json: \(json)")
            }
            if response.result.isSuccess {

                let response = QNearbyPlacesResponse.init(dic: response.result.value as? [String: Any])
                completion(response)

            } else {
                print("error: (response.error)")
                completion(nil)
            }
        })
    }
}

struct QNearbyPlacesResponse {
    var nextPageToken: String?
    var status: String  = "NOK"
    var places: [QPlace]?
    
    init?(dic:[String : Any]?) {
        nextPageToken = dic?["next_page_token"] as? String
        
        if let status = dic?["status"] as? String {
            self.status = status
        }
        
        if let results = dic?["results"] as? [[String : Any]]{
            var places = [QPlace]()
            for place in results {
                places.append(QPlace.init(placeInfo: place))
            }
            self.places = places
        }
    }
    
//    func canLoadMore() -> Bool {
//        if status == "OK" && nextPageToken != nil && nextPageToken?.characters.count ?? 0 > 0 {
//            return true
//        }
//        return false
//    }
}
