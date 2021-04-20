//
//  LoginPageViewController.swift
//  LetsGo
//
//  Created by KSU on 2019/11/14.
//  Copyright © 2019 KSU. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class LoginPageViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var accountText: UITextField!
    @IBOutlet weak var pwdText: UITextField!
    
    
    let paccount = "aaaaa"
    let ppwd = "bbbbb"
    
    var account: String = ""
    var pwd: String = ""
    var nkname: String = ""
    
    let url = CONFIG.API_PREFIX + CONFIG.LOGIN
        
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == accountText{
            pwdText.becomeFirstResponder()
        }
        if textField == pwdText{
            self.login()
        }
        return true
    }
    
    @IBAction func login() {
        var params : [String : Any] = [:]
        
        account = accountText.text!
        pwd = pwdText.text!

        if account != "" && pwd != "" {

            if (self.account == self.paccount && self.pwd == self.ppwd){
                 self.LoginSuccess()
            }
            else{
                
                params = [
                    "account": account,
                    "password": pwd,
                ]
                print(params)

                Alamofire.request(self.url, parameters: params, encoding: URLEncoding(destination: .queryString)).responseJSON(completionHandler: { response in
                    
                    print(response)
                    print(response.result)
    
                    if response.result.isSuccess{
                        let json = JSON(response.result.value!)
                        print(json)
                        print(json["success"])
                        
                        if ( json["success"] == true ){
                            self.nkname = json["nkname"].rawString()!
                            self.LoginSuccess()
                            
                        } else {
                            self.Alert(title: "Oops!", msg: "帳密錯誤！\n")
                            print("error: (response.error)")
                        }
                    }
                    else{
                         self.Alert(title: "Oops", msg: "網路或伺服器異常！\n建議使用下方訪客登入～")
                    }
                    
                })
                
            }
            
        }
        else {
            self.Alert(title: "訊息", msg: "請輸入完整資料\n")
        }
        
    }
    
    @IBAction func GuestLogin(_ sender: Any) {
        UserDefaults.standard.set("guest", forKey: "UserIdentity")
        UserDefaults.standard.set("guest", forKey: "UserName")
        UserDefaults.standard.set(true, forKey: "IsLogin")
        let homeViewController = self.storyboard?.instantiateViewController(withIdentifier: "HomeVCTabBar") as? UITabBarController

        self.view.window?.rootViewController = homeViewController
        self.view.window?.makeKeyAndVisible()
        
    }
    
    func LoginSuccess(){
        UserDefaults.standard.set(account, forKey: "UserIdentity")
        UserDefaults.standard.set(nkname, forKey: "UserName")
        UserDefaults.standard.set(true, forKey: "IsLogin")
        
        if PersonalInformation.readFromeFile() == nil{
            let info = PersonalInformation(points: "0", name: nkname)
            PersonalInformation.savetoFile(record: info)
        }

        
        let homeViewController = self.storyboard?.instantiateViewController(withIdentifier: "HomeVCTabBar") as? UITabBarController
        
        self.view.window?.rootViewController = homeViewController
        self.view.window?.makeKeyAndVisible()
    }
    
    func Alert(title: String ,msg: String){
        let controller = UIAlertController(title: title, message: msg, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        controller.addAction(okAction)
        
        present(controller, animated: true, completion: nil)
        
    }

}
