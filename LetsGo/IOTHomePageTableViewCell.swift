//
//  IOTHomePageTableViewCell.swift
//  LetsGo
//
//  Created by KSU on 2019/6/21.
//  Copyright © 2019 KSU. All rights reserved.
//

import UIKit

class IOTHomePageTableViewCell: UITableViewCell {

    
    @IBOutlet weak var lightSwitch: UISwitch!
    @IBOutlet weak var devicename: UILabel!
    @IBOutlet weak var comment: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
