//
//  ScheduleDetailTableViewCell.swift
//  Let'sGo
//
//  Created by KSU on 2019/4/16.
//  Copyright © 2019 KSU. All rights reserved.
//

import UIKit

class ScheduleDetailTableViewCell: UITableViewCell {

    @IBOutlet weak var signInButton: UIButton!
    @IBOutlet weak var checkInButton: UIButton!
    @IBOutlet weak var startTimeLabel: UILabel!
    @IBOutlet weak var endTimeLabel: UILabel!
    @IBOutlet weak var placeLabel: UILabel!
    @IBOutlet weak var pointsLabel: UILabel!
    
    @IBOutlet weak var missionContent: UILabel!
    @IBOutlet weak var vicinity: UILabel!
    @IBOutlet weak var navButton: UIButton!
    @IBOutlet weak var panoButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
