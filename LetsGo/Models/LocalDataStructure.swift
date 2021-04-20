//
//  localDataStructure.swift
//  LetsGo
//
//  Created by KSU on 2019/11/27.
//  Copyright © 2019 KSU. All rights reserved.
//

import Foundation

struct PersonalInformation: Codable{
    static let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
    
    static let key = "guest"
    var points: String
    var name: String
    
    static func savetoFile(record: PersonalInformation){
        
        print("saving personal info")
        var filename: String
        
        let propertyEncoder = PropertyListEncoder()
        if let identity = UserDefaults.standard.value(forKey: "UserIdentity") {
            print(identity)
            filename = identity as! String
        }
        else{
            filename = key
        }
        if let data = try? propertyEncoder.encode(record) {
            
            let url = PersonalInformation.documentDirectory.appendingPathComponent(filename)
            try? data.write(to: url)
            
        }
    }
    
    static func readFromeFile() -> PersonalInformation? {
        
        print("reading personal info")
        var filename: String
        
        let propertyDecoder = PropertyListDecoder()
        if let identity = UserDefaults.standard.value(forKey: "UserIdentity") {
            print(identity)
            filename = identity as! String
        }
        else{
            filename = key
        }
        
        let url = PersonalInformation.documentDirectory.appendingPathComponent(filename)
        if let data = try? Data(contentsOf: url),
            let records = try?
                propertyDecoder.decode(PersonalInformation.self, from: data){
            print("read personal info successful")
            return records
        }
        else {
            print("fail to read personal info")
            return nil
        }
        
    }
    
    
}

struct SinglePlaceRecord: Codable {
    var placeTitle: String
    var placeName: String
    var dateText: String
    var addressText: String
    var comment: String
    var photoID: String
}

struct SingleScheduleRecord: Codable {
    
    static let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
    static let key = "places"
    static func savetoFile(records: [SinglePlaceRecord]){   
        var filename: String
        if let identity = UserDefaults.standard.value(forKey: "UserIdentity") {
            print(identity)
            filename = (identity as! String) + "places"
        }
        else{
            filename = key
        }
        let propertyEncoder = PropertyListEncoder()
        if let data = try? propertyEncoder.encode(records) {  
            let url = SingleScheduleRecord.documentDirectory.appendingPathComponent(filename)
            try? data.write(to: url)
        }
    }
    
    static func readFromeFile() -> [SinglePlaceRecord]? {
        
        var filename: String
        
        if let identity = UserDefaults.standard.value(forKey: "UserIdentity") {
            print(identity)
            filename = (identity as! String) + "places"
        }
        else{
            filename = key
        }
        
        print("reading places")
        let propertyDecoder = PropertyListDecoder()
        
        let url = SingleScheduleRecord.documentDirectory.appendingPathComponent(filename)
        if let data = try? Data(contentsOf: url),
            let records = try?
                propertyDecoder.decode([SinglePlaceRecord].self, from: data){
            print("success places")
            return records
        }
        else {
            print("fail places")
            return nil
        }
        
    }
    
    static func deleteFile(){
        print("deleting places")
        do {
            let url = SingleScheduleRecord.documentDirectory.appendingPathComponent(key)
            try FileManager.default.removeItem(at: (url))
            print("delete success")

        } catch{
            print(error.localizedDescription)
        }
        
    }
    
}

struct AllScheduleRecord: Codable {
    
}
