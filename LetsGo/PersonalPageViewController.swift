//
//  PersonalPageViewController.swift
//  LetsGo
//
//  Created by KSU on 2019/12/19.
//  Copyright © 2019 KSU. All rights reserved.
//

import UIKit

class PersonalPageViewController: UIViewController {

    var records: [SinglePlaceRecord]!
    
    @IBOutlet weak var nicknameLabel: UILabel!
    @IBOutlet weak var pointsLabel: UILabel!
    @IBOutlet weak var schedulesCountLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        points = PersonalInformation.readFromeFile()?.points
//        pointsLabel.text = points
        // Do any additional setup after loading the view.
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        
        if let infoRecord = PersonalInformation.readFromeFile(){
            self.pointsLabel.text = infoRecord.points
            self.nicknameLabel.text = infoRecord.name
        }
        
        if let records = SingleScheduleRecord.readFromeFile(){
            self.schedulesCountLabel.text = String(records.count)
        }
    }
    @IBAction func logout(_ sender: Any) {
        UserDefaults.standard.set(false, forKey: "IsLogin")
        let homeViewController = self.storyboard?.instantiateViewController(withIdentifier: "LoginNavigationController") as? UINavigationController
        
        self.view.window?.rootViewController = homeViewController
        self.view.window?.makeKeyAndVisible()
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
