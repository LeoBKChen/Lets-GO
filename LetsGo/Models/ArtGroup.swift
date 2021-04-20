//
//  ArtGroup.swift
//  RelicsTracker
//
//  Created by jason Tseng on 2017/9/9.
//  Copyright © 2017年 jason Tseng. All rights reserved.
//

import Foundation
import MapKit
import Contacts

class ArtGroup: NSObject, MKAnnotation {
    let identifier: String
    let urlString: String
    let phoneNumber: String
    let descriptive: String
    let locationName: String
    let artImage: String
    let discipline: String
    var title: String?
    let address: String
    let coordinate: CLLocationCoordinate2D
    
    init(identifier: String, urlString: String, phoneNumber: String, descriptive: String, locationName: String, artImage: String, discipline: String, title: String, address: String, coordinate: CLLocationCoordinate2D) {
        self.identifier = identifier
        self.urlString = urlString
        self.phoneNumber = phoneNumber
        self.descriptive = descriptive
        self.locationName = locationName
        self.artImage = artImage
        self.discipline = discipline
        self.title = title
        self.address = address
        self.coordinate = coordinate
        
        super.init()
    }
    
    var subtitle: String? {
        return discipline
    }
    
    class func fromJSON(json: [JSONValue]) -> ArtGroup? {
        //1
        let identifier = json[1].string
        let urlString = json[9].string
        let phoneNumber = json[10].string
        let descriptive = json[11].string
        let locationName = json[12].string
        let artImage = json[13].string
        let discipline = json[15].string
        var title: String
        if let titleOrNil = json[16].string {
            title = titleOrNil
        } else {
            title = ""
        }
        let address = json[17].string
        // 2 convert String -> NSString -> Double
        //let latitude: Double = Double((json[18].string! as NSString).doubleValue)
        //let longitude: Double = Double((json[19].string! as NSString).doubleValue)
        //guard let longitude = NumberFormatter().number(from: json[19].string!)?.doubleValue else {return nil}
        guard let latitude = Double(json[18].string!) else { return nil}
        guard let longitude = Double(json[19].string!) else { return nil}
        let coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        
        // 3
        return ArtGroup(identifier: identifier!, urlString: urlString!, phoneNumber: phoneNumber!, descriptive: descriptive!, locationName: locationName!, artImage: artImage!, discipline: discipline!, title: title, address: address!, coordinate: coordinate)
    }
    
    // annotation callout opens this mapItem in Maps app
    func mapItem() -> MKMapItem {
        let addressDict = [String(CNPostalAddressStreetKey): self.subtitle!]
        let placemark = MKPlacemark(coordinate: self.coordinate, addressDictionary: addressDict)
        let mapItem = MKMapItem(placemark: placemark)
        mapItem.name = self.title
        
        return mapItem
    }
    
}



