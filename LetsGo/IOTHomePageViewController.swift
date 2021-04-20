//
//  IOTHomePageViewController.swift
//  LetsGo
//
//  Created by KSU on 2019/6/21.
//  Copyright © 2019 KSU. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class IOTHomePageViewController: UIViewController, UITableViewDataSource, UITableViewDelegate ,UINavigationControllerDelegate{
    
    let url = CONFIG.API_PREFIX + CONFIG.LIGHT
    
    let light_id = ["lamb_1", "lamb_2", "lamb_3"]
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return light_id.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = "IOTDeviceCell"
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier,for :indexPath) as! IOTHomePageTableViewCell
        cell.lightSwitch.tag = indexPath.row
        cell.devicename.text = light_id[indexPath.row]
        
        return cell
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func lightCommand(_ sender: UISwitch) {
        if sender.isOn == true{
            callLightAPI(command: "on", index: sender.tag)
        }else {
            callLightAPI(command: "off", index: sender.tag)
        }
    }
    
    func callLightAPI(command: String, index: Int){
        
        let params = ["command": command, "light_name": light_id[index], "account": "ch9765141"]
        
        Alamofire.request(url, parameters: params, encoding: URLEncoding(destination: .queryString)).responseJSON(completionHandler: { response in

            print(response)
            print(response.result)


            if response.result.isSuccess {

                let json = JSON(response.result.value!)

                print(json)


            } else {
                self.Alert(title: "response", msg: "fail\n")
                print("error: (response.error)")
            }

        })
        
    }

    func Alert(title: String ,msg: String){
        let controller = UIAlertController(title: title, message: msg, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "知道啦", style: .default, handler: nil)
        controller.addAction(okAction)
        
        present(controller, animated: true, completion: nil)
        
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
