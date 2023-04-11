//
//  ScheduleDetailViewController.swift
//  Let'sGo
//
//  Created by KSU on 2019/4/16.
//  Copyright © 2019 KSU. All rights reserved.
//

import UIKit
import MapKit
//import Alamofire
//import SwiftyJSON

class ScheduleDetailViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, CLLocationManagerDelegate, UINavigationControllerDelegate, CheckInPageViewControllerDelegate {
    

    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var tableView: UITableView!

    
    var locationManager: CLLocationManager = CLLocationManager()
    var centerCoordinate = CLLocationCoordinate2D()
    
    var timeLength: String = ""
    var radius: String = ""
    var category: String = ""
    var center = CLLocationCoordinate2D()
    
    var placeIDs: [String]! = []
    var places: [String]! = []
    var types: [String]! = []
    var vicinitys: [String]! = []
    var coordinate: [CLLocationCoordinate2D]! = []
    var startTimes: [String]! = []
    var endTimes: [String]! = []

    var records = [SinglePlaceRecord]()
    var personalInfoRecord : PersonalInformation!
    var points : Int!
    
    private var missionCellExpanded: [Bool]!
    
    func update(record: SinglePlaceRecord) {
        records.insert(record, at: 0)
        SingleScheduleRecord.savetoFile(records: records)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let infoRecord = PersonalInformation.readFromeFile(){
            self.points = Int(infoRecord.points)
            self.personalInfoRecord = infoRecord
        }
        else{
            self.points = 0
            self.personalInfoRecord = PersonalInformation(points:"0", name:"Guest")
            PersonalInformation.savetoFile(record: self.personalInfoRecord)
        }

        if let records = SingleScheduleRecord.readFromeFile(){
            self.records = records
        }
        
        mapView.mapType = .standard
        mapView.showsUserLocation = true
        mapView.isZoomEnabled = true
        
        locationManager.requestWhenInUseAuthorization()
        
        locationManager.distanceFilter = kCLLocationAccuracyNearestTenMeters
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.delegate = self
        locationManager.startUpdatingLocation() // Start location

        
        if (category == "test"){
            createTestSchedule()
        }
        else if (category != ""){
            createSchedule()
        }

        // Do any additional setup after loading the view.
        tableView.tableFooterView = UIView()
        
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if (locations.count == 0) { return }
        let cntLocation = locations[locations.count - 1]
        print("scheduleDetail: latitude: \(cntLocation.coordinate.latitude), longitude: \(cntLocation.coordinate.longitude)")
        
        centerCoordinate = CLLocationCoordinate2D(latitude: cntLocation.coordinate.latitude,
                                                 longitude: cntLocation.coordinate.longitude)
        
    }
   
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return places.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cellIdentifier = "ScheduleDetailCell"
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier,for :indexPath) as! ScheduleDetailTableViewCell
        
        cell.layer.masksToBounds = true

        cell.placeLabel?.text = places[indexPath.row]
        cell.vicinity?.text = vicinitys[indexPath.row]
        cell.startTimeLabel?.text = startTimes[indexPath.row]
        cell.endTimeLabel?.text = endTimes[indexPath.row]

        cell.missionContent?.text = ScheduleCreateController.getMission()
        
        cell.navButton.tag = indexPath.row
        cell.checkInButton.tag = indexPath.row
        cell.signInButton.tag = indexPath.row
        cell.panoButton.tag = indexPath.row
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        configure(location: (coordinate?[indexPath.row])!, index: indexPath.row)
        
        if missionCellExpanded[indexPath.row] {
            missionCellExpanded[indexPath.row] = false
        } else {
            missionCellExpanded[indexPath.row] = true
        }
        tableView.beginUpdates()
        tableView.endUpdates()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {

        if missionCellExpanded[indexPath.row] {
            return 200
        } else {
            return 120
        }
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "checkInSegue"{
            let destinationController = segue.destination as! CheckInPageViewController
            if let button:UIButton = sender as! UIButton? {
                print(button.tag) //optional

                let now:Date = Date()
                print("preparing - current Date:")
                print(now)
                let formatter = DateFormatter()
                formatter.dateFormat = "yyyy/MM/dd"
                let currentDate = formatter.string(from: now)
                print(currentDate)
                destinationController.delegate = self
                destinationController.placeName = self.places[button.tag]
                destinationController.addressText = self.vicinitys[button.tag]
                destinationController.dateText = currentDate
                destinationController.coordianate = self.coordinate[button.tag]

            }
        }
        else if segue.identifier == "showPanoSegue"{
            let destinationController = segue.destination as! PanoramaViewController
            if let button:UIButton = sender as! UIButton? {
                print(button.tag) //optional

                let now:Date = Date()
                print("preparing - current Date:")
                print(now)
                let formatter = DateFormatter()
                formatter.dateFormat = "yyyy/MM/dd"
                let currentDate = formatter.string(from: now)
                print(currentDate)

                destinationController.location = self.coordinate[button.tag]
                destinationController.titleText = self.places[button.tag]
            }
        }
    }
    
    @IBAction func navigate(_ sender: UIButton) {
        if let button:UIButton = sender as UIButton? {
            print(button.tag) //optional
            let source = MKMapItem(placemark: MKPlacemark(coordinate: self.centerCoordinate))
            source.name = "Your Position"
            let destination = MKMapItem(placemark: MKPlacemark(coordinate: self.coordinate[button.tag]))
            destination.name = self.places[button.tag]            
            MKMapItem.openMaps(with: [source, destination], launchOptions: [MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving])
        }
    }
    
    @IBAction func signIn(_ sender: UIButton) {
        if let button:UIButton = sender as UIButton? {
            print(button.tag) //optional
            
            if let identity = UserDefaults.standard.value(forKey: "UserIdentity") {
                if identity as! String == "guest"{
                    self.Alert(title: "伺服器回應", msg: "此功能需登入後才能使用～\n建議您前往註冊帳號！")
                }
                else {
                    if( checkLocation(tag: button.tag) ){
                        button.isEnabled = false
                        var account: String
                        
                        if let identity = UserDefaults.standard.value(forKey: "UserIdentity") {
                            account = identity as! String
                        }else{
                            account = "ch9765141"
                        }
                        
                        let params = [ "account" : account ]
                        let url = CONFIG.API_PREFIX + CONFIG.SIGN
//                        Alamofire.request(url, parameters: params, encoding: URLEncoding(destination: .queryString)).responseJSON(completionHandler: { response in
//
//                            print(response)
//
//                            if response.result.isSuccess{
//                                let json = JSON(response.result.value!)
//                                print(json)
//
//                                if ( json["check"] == true ){
//                                    self.Alert(title: "簽到檢查", msg: "簽到成功！")
//                                    let indexPath = IndexPath(row: button.tag, section: 0)
//                                    let cell = self.tableView.cellForRow(at: indexPath) as! ScheduleDetailTableViewCell
//                                    cell.pointsLabel.backgroundColor = UIColor(red: 252/255, green: 248/255, blue: 0/255, alpha: 1.0)
//                                    self.points += 1
//                                    self.personalInfoRecord.points = String(self.points)
//                                    PersonalInformation.savetoFile(record: self.personalInfoRecord)
//                                } else {
//                                    self.Alert(title: "伺服器回應", msg: "異常簽到狀況\n")
//                                    print("error: (response.error)")
//                                    button.isEnabled = true
//                                }
//                            }
//                            else{
//                                self.Alert(title: "Oops", msg: "網路或伺服器異常")
//                                button.isEnabled = true
//                            }
//                        })
                    }
                    else{
                       Alert(title: "打卡檢查", msg: "尚未到達目的地！")
                    }
                }
            }
        }
    }
    
    @IBAction func checkin(_ sender: UIButton) {
        if let button:UIButton = sender as UIButton? {
            print(button.tag) //optional
            if( checkLocation(tag: button.tag)){
                performSegue(withIdentifier: "checkInSegue", sender: sender)
            }
            else{
                Alert(title: "打卡檢查", msg: "尚未到達目的地！")
            }
        }
    }
    
    func checkLocation(tag: Int)-> Bool{
        print(tag) //optional
        return true
        print(centerCoordinate.latitude)
        print(centerCoordinate.longitude)
        print(self.coordinate[tag].latitude)
        print(self.coordinate[tag].longitude)
        
        let x = centerCoordinate.latitude - self.coordinate[tag].latitude
        let y = centerCoordinate.longitude - self.coordinate[tag].longitude
        if( (x.magnitude < 0.001 ) && (y.magnitude < 0.001 )){
            return true
        }
        else{
            return false
        }
    }
    
    func createSchedule(){
        if let placeNumbers = Int(self.timeLength){
            
            let now:Date = Date()
            print("current Date:")
            print(now)
            let formatter = DateFormatter()
            formatter.dateFormat = "HH"
            let currentHour = formatter.string(from: now)
            formatter.dateFormat = "mm"
            let currentMinute = formatter.string(from: now)
            
            for i in 1...placeNumbers {
                
                let startHourInt = (Int(currentHour)!+i-1) % 24
                var startTime:String = ""
                if(startHourInt < 10) {
                    startTime = "0" + String(startHourInt) + ":" + currentMinute
                }
                else{
                    startTime = String(startHourInt) + ":" + currentMinute
                }
                let endHourInt = (Int(currentHour)!+i) % 24
                var endTime:String = ""
                if(endHourInt < 10) {
                    endTime = "0" + String(endHourInt) + ":" + currentMinute
                }
                else{
                    endTime = String(endHourInt) + ":" + currentMinute
                }

                let type = ScheduleCreateController.getType(category: self.category)
                print("type: " + type)
                NearbyPlacesHelper.shared.getNearbyPlaces(type: type, radius: radius, coordinates: center, token: nil, completion: didReceiveResponse)
                
                startTimes.append(startTime)
                endTimes.append(endTime)
                types.append(type)
            }
        }
    }
    
    func createTestSchedule(){
        let testPlaceName = ["Much主幼商場", "異人館" , "星巴克", "7-11", "真暖暖麵包製造所", "仁愛眼鏡 崑大店", "和德藥局"]
        if let placeNumbers = Int(self.timeLength){
            
            let now:Date = Date()
            print("current Date:")
            print(now)
            let formatter = DateFormatter()
            formatter.dateFormat = "HH"
            let currentHour = formatter.string(from: now)
            formatter.dateFormat = "mm"
            let currentMinute = formatter.string(from: now)
            
            for i in 1...placeNumbers {
                
                let startHourInt = (Int(currentHour)!+i-1) % 24
                var startTime:String = ""
                if(startHourInt < 10) {
                    startTime = "0" + String(startHourInt) + ":" + currentMinute
                }
                else{
                    startTime = String(startHourInt) + ":" + currentMinute
                }
                let endHourInt = (Int(currentHour)!+i) % 24
                var endTime:String = ""
                if(endHourInt < 10) {
                    endTime = "0" + String(endHourInt) + ":" + currentMinute
                }
                else{
                    endTime = String(endHourInt) + ":" + currentMinute
                }

//                cell.placeLabel?.text = places[indexPath.row]
//                cell.vicinity?.text = vicinitys[indexPath.row]
//                cell.startTimeLabel?.text = startTimes[indexPath.row]
//                cell.endTimeLabel?.text = endTimes[indexPath.row]
                
                places.append(testPlaceName[i])
                vicinitys.append("test vicinity" + String(i))
                
                coordinate.append(center)
                
                startTimes.append(startTime)
                endTimes.append(endTime)
                
                self.tableView.reloadData()
                
                configure(location: coordinate[coordinate.count-1], index: coordinate.count-1)
                configure(location: coordinate[0], index: 0)
                
                missionCellExpanded = [Bool](repeating: false, count: places.count)
            }
            
        }
    }
    
    func didReceiveResponse(response:NearbyPlacesResponse?) -> Void{
        
        if(response != nil && response?.status == "OK"){
            
            let place1 = response?.results[0].name ?? "none"
            print("place name : " + place1)
            
            let place = response?.results.randomElement()
            
            if let name = place?.name{
                places.append(name)
            }
            if let placeId = place?.placeID{
                placeIDs.append(placeId)
            }
            
            if let vicinity = place?.vicinity{
                vicinitys.append(vicinity)
            }
            
            if let location = place?.geometry.locationCoordinate2D{
                coordinate.append(location)
            }
                        
            self.tableView.reloadData()
            
            configure(location: coordinate[coordinate.count-1], index: coordinate.count-1)
            configure(location: coordinate[0], index: 0)
            
            missionCellExpanded = [Bool](repeating: false, count: places.count)
        }
        else{
            print("internet error or nothing found")
            self.Alert(title: "連線問題", msg: "請檢查網路狀況\n")
        }
        
        if places.count == Int(self.timeLength) {
            let msg = "1.選取行程，點擊\"出發\"按鈕，前往導航畫面\n 2.到達目的地後，點擊\"簽到\"按鈕，獲得簽到積分\n 3.選取行程，展開查看任務，盡力完成任務！\n 4.過程中可點擊\"打卡\"按鈕，拍照並留下評論後，將美好回憶保存～"
            
            self.Alert(title: "流程操作簡介", msg: msg)
        }
    }
    
    func configure(location: CLLocationCoordinate2D, index: Int){
        
        let annotation = MKPointAnnotation()
        annotation.title = self.places[index]
        
        annotation.coordinate = location
        
        self.mapView.addAnnotation(annotation)
        
        let region = MKCoordinateRegion(center: annotation.coordinate, latitudinalMeters: 250, longitudinalMeters: 250)
        
        self.mapView.setRegion(region, animated: false)
        
    }
    
    func Alert(title: String ,msg: String){
        let controller = UIAlertController(title: title, message: msg, preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        controller.addAction(okAction)
        
        present(controller, animated: true, completion: nil)
        
    }

}


