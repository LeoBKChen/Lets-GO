//
//  AppDelegate.swift
//  Let'sGo
//
//  Created by KSU on 2019/3/21.
//  Copyright © 2019 KSU. All rights reserved.
//

import UIKit
import CoreData
import GoogleMaps

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var timer: Timer?
    var logoutRemindTimeStartHr: Int?
    var logoutRemindTimeStartMin: Int?
    var logoutRemindTimeInterval: Int?
    // https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=22.966623,%20120.294835&radius=1500&type=gym&key=AIzaSyBYMLqPtkWYHAGOZwDVHebF6HiiZwliG2M
    
//    static let googlePlacesAPIKey = "AIzaSyBYwQfZBFt-YwF4h7w9U3Lee7uoN87orOY"

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        GMSServices.provideAPIKey("UseYourOwnAPIKey")
        
        self.logoutReminderInit()
        
        // Override point for customization after application launch.
        return true
    }
    
    func logoutReminderInit(){
        self.logoutRemindTimeInterval = 1
        self.setLogoutReminderTimeStart()
        self.timer = Timer.scheduledTimer(timeInterval: 1800.0, target: self, selector: #selector(AppDelegate.remindUserToLogOut), userInfo: nil, repeats: true)
    }
    
    @objc func remindUserToLogOut(){
        let now:Date = Date()
//        print("checking Time Interval:")
//        print(now)
//        //
//        print("start Hour:")
//        print(self.logoutRemindTimeStartHr!)
//        print("start Min:")
//        print(self.logoutRemindTimeStartMin!)
//        print("time Intertval:")
//        print(self.logoutRemindTimeInterval!)
        //
        let formatter = DateFormatter()
        formatter.dateFormat = "mm"
        let currentMin = Int(formatter.string(from: now))!
        formatter.dateFormat = "HH"
        let currentHr = Int(formatter.string(from: now))!
        
//        if( ( (currentMin - self.logoutRemindTimeStartMin!) >= self.logoutRemindTimeInterval! )){
//            self.Alert(title: "溫馨提醒", msg: "完成行程或結束使用前記得登出帳號哦！")
//            self.setLogoutReminderTimeStart()
//
//        }
        
        if( ( (currentHr - self.logoutRemindTimeStartHr!) >= self.logoutRemindTimeInterval! ) && ( (currentMin - self.logoutRemindTimeStartMin!) >= 0) ){
            self.Alert(title: "溫馨提醒", msg: "完成行程或結束使用前記得登出帳號哦！")
            self.setLogoutReminderTimeStart()
        }
    }
    
    public func setLogoutReminderTimeStart(){
        let now:Date = Date()
        print("Setting Reminder Time Start:")
        print(now)
        print("interval:")
        print(logoutRemindTimeInterval!)
        let formatter = DateFormatter()
        formatter.dateFormat = "HH"
        self.logoutRemindTimeStartHr = Int(formatter.string(from: now))
        formatter.dateFormat = "mm"
        self.logoutRemindTimeStartMin = Int(formatter.string(from: now))
    }
    
    func Alert(title: String ,msg: String){
        let controller = UIAlertController(title: title, message: msg, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        controller.addAction(okAction)
        self.window?.rootViewController?.present(controller, animated: true, completion: nil)
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        // Saves changes in the application's managed object context before the application terminates.
        self.saveContext()
    }

    // MARK: - Core Data stack

    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
        */
        let container = NSPersistentContainer(name: "LetsGo")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                 
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    // MARK: - Core Data Saving support

    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }

}

