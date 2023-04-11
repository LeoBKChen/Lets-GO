//
//  RegisterViewController.swift
//  LetsGo
//
//  Created by KSU on 2019/11/21.
//  Copyright © 2019 KSU. All rights reserved.
//

import UIKit
//import Alamofire
//import SwiftyJSON

class RegisterViewController: UIViewController, UITextFieldDelegate{
    
    
    @IBOutlet weak var nameText: UITextField!
    @IBOutlet weak var nicknameText: UITextField!
    @IBOutlet weak var emailText: UITextField!
    @IBOutlet weak var accountText: UITextField!
    @IBOutlet weak var pwdText: UITextField!
    @IBOutlet weak var pwdCheckText: UITextField!
    @IBOutlet weak var phoneText: UITextField!

    let url = CONFIG.API_PREFIX + CONFIG.REGISTER
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == nameText{
            nicknameText.becomeFirstResponder()
        }
        else if textField == nicknameText{
            emailText.becomeFirstResponder()
        }
        else if textField == emailText{
            accountText.becomeFirstResponder()
        }
        else if textField == accountText{
            pwdText.becomeFirstResponder()
        }
        else if textField == pwdText{
            pwdCheckText.becomeFirstResponder()
        }
        else if textField == pwdCheckText{
            phoneText.becomeFirstResponder()
        }
        
        return true
    }

    @IBAction func callRegisterAPI(_ sender: Any) {
        
        let name = nameText.text!
        let nkname = nicknameText.text!
        let email = emailText.text!
        let account = accountText.text!
        let pwd = pwdText.text!
        let pwdCheck = pwdCheckText.text!
        let phone = phoneText.text!
        
        if ( pwd != pwdCheck){
            self.Alert(title: "訊息", msg: "密碼不相符\n")
        }else {
            if ( name != "" && nkname != "" && email != ""
                && account != "" && pwd != "" && pwdCheck != ""
                && phone != ""){
                
                
                let params = ["nkname": nkname,
                               "realname": name,
                               "account": account,
                               "password": pwd,
                               "email": email,
                               "phone": phone,
                               "birthday":"19990223",
                               ]
                print(params)
//                Alamofire.request(url, parameters: params, encoding: URLEncoding(destination: .queryString)).responseJSON(completionHandler: { response in
//
//                    print(response)
//                    print(response.result)
//
//
//                    if response.result.isSuccess {
//                     
//                        let json = JSON(response.result.value!)
//
//                        print(json)
//
//                        self.Alert(title: "伺服器回應", msg: json["註冊成功"].stringValue)
//                     
//                    } else {
//                        self.Alert(title: "伺服器回應", msg: "註冊失敗")
//                        print("error: (response.error)")
//                    }
//
//                })
            }else{
                self.Alert(title: "訊息", msg: "資料不完整")
            }
        }
        
    }
    
    func Alert(title: String ,msg: String){
        let controller = UIAlertController(title: title, message: msg, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        controller.addAction(okAction)
        
        present(controller, animated: true, completion: nil)
        
    }
}
