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
import Combine

    // https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=22.966623,%20120.294835&radius=1500&type=gym&key=AIzaSyBYMLqPtkWYHAGOZwDVHebF6HiiZwliG2M
    //https://developers.google.com/places/web-service/supported_types
class NearbyPlacesHelper {
    static let shared = NearbyPlacesHelper()

    static let searchApiHost = "https://maps.googleapis.com/maps/api/place/nearbysearch/json?"

    var cancellableSet: Set<AnyCancellable> = []

    func getNearbyPlaces(type:String, radius:String, coordinates:CLLocationCoordinate2D, token: String?, completion: @escaping (NearbyPlacesResponse?) -> Void) {

        var params : String
        
        if let t = token {
            params = "key=\(CONFIG.googlePlacesAPIKey)&pagetoken=\(t)"
        } else {
            params = "key=\(CONFIG.googlePlacesAPIKey)&radius=\(radius)&location=\(coordinates.latitude),\(coordinates.longitude)&type=\(type.lowercased())"
        }
        print(params)
        guard let url = URL(string: NearbyPlacesHelper.searchApiHost + params) else { return }
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "GET"
        
        URLSession.shared.dataTaskPublisher(for: urlRequest)
            .receive(on: DispatchQueue.main)
            .tryMap() { element -> Data in
                guard let httpResponse = element.response as? HTTPURLResponse,
                      httpResponse.statusCode == 200 else {
                          throw URLError(.badServerResponse)
                      }
                print("response: \(element.data)")
                return element.data
            }
            .decode(type: NearbyPlacesResponse.self, decoder: JSONDecoder())
            .sink(receiveCompletion: {
                print ("Received appDetail completion: \($0).")
            }, receiveValue: {
                completion($0)
            })
            .store(in: &cancellableSet)
        
//
//        Alamofire.request(searchApiHost, parameters: params, encoding: URLEncoding(destination: .queryString)).responseJSON(completionHandler: { response in
//
//            if let json = response.result.value {
//                print("json: \(json)")
//            }
//            if response.result.isSuccess {
//
//                let response = QNearbyPlacesResponse.init(dic: response.result.value as? [String: Any])
//                completion(response)
//
//            } else {
//                print("error: (response.error)")
//                completion(nil)
//            }
//        })
    }
}
//
//struct QNearbyPlacesResponse: Decodable {
//    let nextPageToken: String?
//    var status: String = "NOK"
//    let results: [QPlace]
//    
////    init?(dic:[String : Any]?) {
////        nextPageToken = dic?["next_page_token"] as? String
////
////        if let status = dic?["status"] as? String {
////            self.status = status
////        }
////
////        if let results = dic?["results"] as? [[String : Any]]{
////            var places = [QPlace]()
////            for place in results {
////                places.append(QPlace.init(placeInfo: place))
////            }
////            self.places = places
////        }
////    }
//    
//    private enum CodingKeys: String, CodingKey {
//        case nextPageToken = "next_page_token"
//        case status = "status"
//        case results = "results"
//    }
//    
//    init(from decoder: Decoder) throws {
//        let values = try decoder.container(keyedBy: CodingKeys.self)
//        nextPageToken = try values.decode(String.self, forKey: .nextPageToken)
//        status = try values.decode(String.self, forKey: .status)
//        results = try values.decode([QPlace].self, forKey: .results)
//    }
//    
////    func canLoadMore() -> Bool {
////        if status == "OK" && nextPageToken != nil && nextPageToken?.characters.count ?? 0 > 0 {
////            return true
////        }
////        return false
////    }
//}


