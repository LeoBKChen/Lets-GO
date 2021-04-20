//
//  LaunchScreenViewController.swift
//  LetsGo
//
//  Created by Apple on 2020/3/24.
//  Copyright © 2020 KSU. All rights reserved.
//

import UIKit

class LaunchScreenViewController: UIViewController {

    @IBOutlet weak var messageLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        animation()
        // Do any additional setup after loading the view.
    }
    
    private func animation(){
        UIView.animate(withDuration: 3,
                       delay: 0,
                       options: .curveEaseInOut,
                       animations: {
                        self.messageLabel.transform = CGAffineTransform(rotationAngle: .pi)
                        self.messageLabel.transform = .identity
//                        self.view.alpha = 0.6
        }) { (finished) in
            if let islogin = UserDefaults.standard.value(forKey: "IsLogin") {
                print("islogin at launch screen : ")
                print(islogin)
                if islogin as! Bool == true{
                    print("already login")
    
                    let homeViewController = self.storyboard?.instantiateViewController(withIdentifier: "HomeVCTabBar") as? UITabBarController
    
                    self.view.window?.rootViewController = homeViewController
                    self.view.window?.makeKeyAndVisible()
    
                }
                else{
                    print("have logged out")
                    let homeViewController = self.storyboard?.instantiateViewController(withIdentifier: "LoginNavigationController") as? UINavigationController
    
                    self.view.window?.rootViewController = homeViewController
                    self.view.window?.makeKeyAndVisible()
                }
            }
            else {
                print("no login record")
                let homeViewController = self.storyboard?.instantiateViewController(withIdentifier: "LoginNavigationController") as? UINavigationController

                self.view.window?.rootViewController = homeViewController
                self.view.window?.makeKeyAndVisible()
            }
        }
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
