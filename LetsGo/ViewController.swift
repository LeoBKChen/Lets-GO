//
//  ViewController.swift
//  Let'sGo
//
//  Created by KSU on 2019/3/21.
//  Copyright © 2019 KSU. All rights reserved.
//

import UIKit
import MapKit
import LocalAuthentication

class ViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, CLLocationManagerDelegate {
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var conditionPickerView: UIPickerView!
    
    var locationManager: CLLocationManager = CLLocationManager()
    var cntLocation: CLLocation!
    var centerCoordinte = CLLocationCoordinate2D()
        
    var PickerViewTimeData = ["1", "2", "3", "4", "5", "6"]
    var PickerViewDistanceData = ["500", "1000", "1500", "2000", "5000", "7000", "10000", "15000"]
    var PickerViewTypeData = ["走走看看", "吃吃喝喝", "逛街購物", "交新朋友", "神秘行程", "踏溯臺南", "test"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        conditionPickerView.delegate = self
        conditionPickerView.dataSource = self
        
        mapView.mapType = .standard
        mapView.showsUserLocation = true
        mapView.isZoomEnabled = true
        
        myLocation()
        
    }
    
    func myLocation(){
        locationManager.distanceFilter = kCLLocationAccuracyNearestTenMeters
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.delegate = self
        
        locationManager.requestWhenInUseAuthorization()
        
        switch CLLocationManager.authorizationStatus() {
            case .notDetermined:
                locationManager.requestWhenInUseAuthorization() // First time lanch app need to get authorize from user
                fallthrough
            case .authorizedWhenInUse:
                locationManager.startUpdatingLocation() // Start location
            case .denied:
                let alertController = UIAlertController(title: "定位權限已關閉", message:"如要變更權限，請至 設定 > 隱私權 > 定位服務 開啟", preferredStyle: .alert)
                let okAction = UIAlertAction(title: "確認", style: .default, handler:nil)
                alertController.addAction(okAction)
                self.present(alertController, animated: true, completion: nil)
            default:
                break
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if (locations.count == 0) { return }
        let cntLocation = locations[locations.count - 1]
        print("latitude: \(cntLocation.coordinate.latitude), longitude: \(cntLocation.coordinate.longitude)")
        
        let center = CLLocationCoordinate2D(latitude: cntLocation.coordinate.latitude,
                                               longitude: cntLocation.coordinate.longitude)
        
        centerCoordinte = center
        
        // paramater span means the range of map
        let region = MKCoordinateRegion(center: center,
                                        span: MKCoordinateSpan(latitudeDelta: 0.01,
                                                               longitudeDelta: 0.01)
        )
        mapView.setRegion(region, animated: true)
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 3
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch component {
        case 0:
            return PickerViewTimeData.count
        case 1:
            return PickerViewDistanceData.count
        case 2:
            return PickerViewTypeData.count
        default:
            return PickerViewTypeData.count
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        
        var pickerLabel = UILabel()
        if let v = view {
            pickerLabel = v as! UILabel
        }
        switch component {
        case 0:
            pickerLabel.text = PickerViewTimeData[row] + "hr"
        case 1:
            pickerLabel.text = PickerViewDistanceData[row] + "m"
        case 2:
            pickerLabel.text = PickerViewTypeData[row]
        default:
            pickerLabel.text = "undefined"
        }
        pickerLabel.font = UIFont(name: "System", size: 28)
        
        return pickerLabel
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "newScheduleDetail"{
            let destinationController = segue.destination as! ScheduleDetailViewController
            destinationController.timeLength = PickerViewTimeData[conditionPickerView.selectedRow(inComponent: 0)]
            destinationController.radius = PickerViewDistanceData[conditionPickerView.selectedRow(inComponent: 1)]
            destinationController.category = PickerViewTypeData[conditionPickerView.selectedRow(inComponent: 2)]
            
            destinationController.center = centerCoordinte
        }
        
        if segue.identifier == "COLANCKUSchedule"{
            let destinationController = segue.destination as! COLANCKUScheduleDetailViewController
            destinationController.timeLength = PickerViewTimeData[conditionPickerView.selectedRow(inComponent: 0)]
            destinationController.radius = PickerViewDistanceData[conditionPickerView.selectedRow(inComponent: 1)]
            destinationController.category = PickerViewTypeData[conditionPickerView.selectedRow(inComponent: 2)]
            
            destinationController.center = centerCoordinte
        }
    }
    
    @IBAction func letsGoButtonPressed(_ sender: Any) {
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.setLogoutReminderTimeStart()
        appDelegate.logoutRemindTimeInterval = Int(PickerViewTimeData[conditionPickerView.selectedRow(inComponent: 0)])
        if(PickerViewTypeData[conditionPickerView.selectedRow(inComponent: 2)] == "踏溯臺南"){
            performSegue(withIdentifier: "COLANCKUSchedule", sender: Any?.self)
        }
        else{
            performSegue(withIdentifier: "newScheduleDetail", sender: Any?.self)
        }
        
    }
    
    public func Alert(title: String ,msg: String){
        let controller = UIAlertController(title: title, message: msg, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        controller.addAction(okAction)
        
        present(controller, animated: true, completion: nil)
        
    }
}

