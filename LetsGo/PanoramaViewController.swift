//
//  PanoramaViewController.swift
//  LetsGo
//
//  Created by guest1 on 2020/4/14.
//  Copyright © 2020 KSU. All rights reserved.
//

import UIKit
import GoogleMaps

class PanoramaViewController: UIViewController {

    @IBOutlet weak var panoramaView: GMSPanoramaView!
    @IBOutlet weak var navigationTitleItem: UINavigationItem!
    
    var location: CLLocationCoordinate2D!
    var titleText: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("enter pano")
        print(location)
        if let titleExist = titleText{
            navigationTitleItem.title = titleExist
        }
//        panoramaView.moveNearCoordinate(CLLocationCoordinate2D(latitude: 37.3317134, longitude: -122.0307466))
        panoramaView.moveNearCoordinate(location)
//        GMSPanoramaService().requestPanoramaNearCoordinate(CLLocationCoordinate2D(latitude: 37.3317134, longitude: -122.0307466)){
//            (pano, error) in
//            if error != nil{
//                print(error!.localizedDescription)
//                return
//            }
//            self.panoramaView.panorama = pano
//        }
        
        // Do any additional setup after loading the view.
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
