//
//  QSchedule.swift
//  LetsGo
//
//  Created by KSU on 2019/5/15.
//  Copyright © 2019 KSU. All rights reserved.
//

import Foundation
import UIKit


class Schedule{
    
    var Images : String?
    var Dates : String?
    var Places : String?
    var Costs : String?
    var Times : String?
    var details :[ScheduleDetail]?
    
    init(dic:[String : Any]?) {
        
    }
}

struct ScheduleDetail {
    var places: [String]!
    var startTimes: [String]!
    var endTimes: [String]!
    var costs: [String]!
    var toolImageNames: [String]!
}
