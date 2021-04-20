//
//  ScheduleDetailViewController.swift
//  Let'sGo
//
//  Created by KSU on 2019/4/16.
//  Copyright © 2019 KSU. All rights reserved.
//

import UIKit
import MapKit


class COLANCKUScheduleDetailViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, CLLocationManagerDelegate, UINavigationControllerDelegate, CheckInPageViewControllerDelegate , MKMapViewDelegate{
    

    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var tableView: UITableView!
    
    var artGroup: ArtGroup?
    var alertMessage1 = String()
    var alertMessage2 = String()
    var isNavigation:Bool = false
    var annotationIdentifier = String()
    
    var locationManager: CLLocationManager = CLLocationManager()
    var centerCoordinte = CLLocationCoordinate2D()
    
    var timeLength: String = ""
    var radius: String = ""
    var category: String = ""
    var center = CLLocationCoordinate2D()
    
    var placeIDs: [String]! = []

    var startTimes: [String]! = []
    var endTimes: [String]! = []

    var records = [SinglePlaceRecord]()
    var pointRecord : PersonalInformation!
    var points : Int!
    
    var isLoadJSON:Bool = true
    var COLANCKUTainanArtGroups = [ArtGroup]()


    
    private var missionCellExpanded: [Bool]!
    
    func update(record: SinglePlaceRecord) {
        records.insert(record, at: 0)
        SingleScheduleRecord.savetoFile(records: records)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let pointsRecord = PersonalInformation.readFromeFile(){
            self.points = Int(pointsRecord.points)
            self.pointRecord = pointsRecord
        }
        else{
            self.points = 0
            self.pointRecord = PersonalInformation(points:"0", name:"Guest")
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

        
        if (category == "踏溯臺南"){
            print()
            createCOLANCKUSchedule()
        }
        
        // Do any additional setup after loading the view.
        tableView.tableFooterView = UIView()
        
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if (locations.count == 0) { return }
        let cntLocation = locations[locations.count - 1]
        print("scheduleDetail: latitude: \(cntLocation.coordinate.latitude), longitude: \(cntLocation.coordinate.longitude)")
        
        centerCoordinte = CLLocationCoordinate2D(latitude: cntLocation.coordinate.latitude,
                                                 longitude: cntLocation.coordinate.longitude)
        
    }
   
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return COLANCKUTainanArtGroups.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cellIdentifier = "ScheduleDetailCell"
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier,for :indexPath) as! ScheduleDetailTableViewCell
        
        cell.layer.masksToBounds = true

        cell.placeLabel?.text = COLANCKUTainanArtGroups[indexPath.row].locationName
        cell.vicinity?.text = COLANCKUTainanArtGroups[indexPath.row].address
        cell.startTimeLabel?.text = startTimes[indexPath.row]
        cell.endTimeLabel?.text = endTimes[indexPath.row]

        cell.missionContent?.text = ScheduleCreateController.getMission()
        
        cell.navButton.tag = indexPath.row
        cell.signInButton.tag = indexPath.row
        cell.checkInButton.tag = indexPath.row
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        configure(location: (COLANCKUTainanArtGroups[indexPath.row].coordinate), index: indexPath.row)
        
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
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        view.image = UIImage(named: "onebit_02")
        //if CLLocationManager.authorizationStatus() == .denied {
        // retrieve the search bar if it is appeared
        //tableView.tableHeaderView = self.navigationItem.titleView
        let annotation = view.annotation!
        for artGroup in COLANCKUTainanArtGroups {
            if (annotation.title!)!.contains(artGroup.title!) {
                self.artGroup = annotation as? ArtGroup
                //mapView.removeAnnotations([annotation_MD, annotation_MS])
                break
            }
        }
//        // used only to pick the artGroup when the authorization is not allowed
//        if annotation.isEqual(artGroup) {
//            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 2.0) {
//                self.showInfo(annotation)
//            }
//        }
        //}
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        let leftIconView = UIImageView(frame: CGRect.init(x: 0, y: 0, width: 53, height: 53))
        var leftIconViewImage = UIImage()
        // check whether the current annotation inherits from the MKUserLocation
        if annotation.isKind(of: MKUserLocation.self) {
            return nil //return nil so mapView draws "blue dot" for standard user location
        }

        artGroup = (annotation as? ArtGroup)!
        self.annotationIdentifier = (artGroup?.identifier)!

        print("mapView for annotation for resource from \(self.annotationIdentifier)")
        
        // return a useable annotation view (the current annotation) located by its identifier
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: self.annotationIdentifier) as? MKPinAnnotationView
        if annotationView == nil { //a reusable annotation view is not dequeued
            print("annotationView == nil")
            annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: self.annotationIdentifier)
            //annotationView?.calloutOffset = CGPoint(x: -5, y: 5)
            //annotationView?.pinTintColor = annotation.pinTintColor()
        } else {
            print("annotationView != nil")
            annotationView!.annotation = annotation
        }
        // annotation view is able to display extra info. in a callout bubble
        annotationView?.canShowCallout = true
        
        // callout for annotationView
        // setup the subtitle font
        let subtitleView = UILabel()
        subtitleView.font = subtitleView.font.withSize(16)
        subtitleView.numberOfLines = 0
        subtitleView.text = annotation.subtitle!
        print("Subtitle: \(String(describing: (annotation.subtitle!)!))")
        
        let btn = UIButton(type: .detailDisclosure)
        annotationView?.rightCalloutAccessoryView = btn // for right detail callout

    
        if annotation.isEqual(artGroup) {
            switch (artGroup?.discipline)! {
            case "一級古蹟", "二級古蹟", "三級古蹟", "博物館", "文創園區":
                annotationView?.pinTintColor = UIColor.red
                let circle = MKCircle(center: (artGroup?.coordinate)!, radius: 100)
                self.mapView.addOverlay(circle)
                print("Add pin color for \((artGroup?.title)!)")
            case "旗艦","旗艦A","旗艦B","旗艦C","旗艦D","旗艦E","旗艦F","旗艦G":
                annotationView?.pinTintColor = UIColor.purple
            case "藝廊1","藝廊2":
                annotationView?.pinTintColor = UIColor.orange
            default:
                annotationView?.pinTintColor = UIColor.green
            }
            let CPImage = artGroup?.artImage
            leftIconViewImage = UIImage(named: CPImage!)!
            //btn.addTarget(self, action: #selector(showInfo), for: .touchUpInside)
        }
        leftIconView.image = leftIconViewImage
        annotationView?.leftCalloutAccessoryView = leftIconView // for left image
        
        return annotationView
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
                formatter.dateFormat = "yyyy/MM/DD"
                let currentDate = formatter.string(from: now)
                
                destinationController.delegate = self
                destinationController.placeName = self.COLANCKUTainanArtGroups[button.tag].locationName
                destinationController.dateText = currentDate
            }
            
        }
    }
    
    @IBAction func navigate(_ sender: UIButton) {
        if let button:UIButton = sender as UIButton? {
            print(button.tag) //optional
            let source = MKMapItem(placemark: MKPlacemark(coordinate: self.center))
            source.name = "Your Position"
            
            let destination = MKMapItem(placemark: MKPlacemark(coordinate: self.COLANCKUTainanArtGroups[button.tag].coordinate))
            destination.name = self.COLANCKUTainanArtGroups[button.tag].locationName
            
            MKMapItem.openMaps(with: [source, destination], launchOptions: [MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving])
        }
    }
    
    @IBAction func signIn(_ sender: UIButton) {
        if let button:UIButton = sender as UIButton? {
            print(button.tag) //optional
            

            if( checkLocation(tag: button.tag) ){
                button.isEnabled = false
                Alert(title: "打卡檢查", msg: "打卡成功！")
                
                let indexPath = IndexPath(row: button.tag, section: 0)

                let cell = self.tableView.cellForRow(at: indexPath) as! ScheduleDetailTableViewCell
                cell.pointsLabel.backgroundColor = UIColor(red: 252/255, green: 248/255, blue: 0/255, alpha: 1.0)
                
                points += 1
                pointRecord.points = String(self.points)
                PersonalInformation.savetoFile(record: self.pointRecord)
            }
            else{
                Alert(title: "打卡檢查", msg: "尚未到達目的地！")
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
        
        print(centerCoordinte.latitude)
        print(self.COLANCKUTainanArtGroups[tag].coordinate.latitude)

        let x = centerCoordinte.latitude - self.COLANCKUTainanArtGroups[tag].coordinate.latitude
        let y = centerCoordinte.longitude - self.COLANCKUTainanArtGroups[tag].coordinate.longitude

        if( (x.magnitude < 0.001 ) && (y.magnitude < 0.001 )){
            return true
        }
        else{
            return false
        }
    }
    
    
    func createCOLANCKUSchedule(){
        loadCOLANCKUTainanInitialData()
        mapView.addAnnotations(COLANCKUTainanArtGroups)
        createSchedule()
        missionCellExpanded = [Bool](repeating: false, count: COLANCKUTainanArtGroups.count)

    }
    
    func loadCOLANCKUTainanInitialData() {
        print("Loading the COLANCKUTainan art group...")
        isLoadJSON = true
        let jsonResource = ScheduleCreateController.getThemeJsonData()
        let fileName = Bundle.main.path(forResource: jsonResource, ofType: "json");
        var data: Data?
        //data = try? Data(contentsOf: URL(fileURLWithPath: fileName!))
        //, options: NSData.ReadingOptions(rawValue: 0))
        do {
            data = try Data(contentsOf: URL(fileURLWithPath: fileName!), options: NSData.ReadingOptions(rawValue: 0))
        } catch let error as NSError {
            //data = nil
            print("Content could not be loaded with \(error.debugDescription)")
        }
        // 2
        var jsonObject: Any?
        if let data = data {
            do {
                jsonObject = try JSONSerialization.jsonObject(with: data, options:  JSONSerialization.ReadingOptions(rawValue: 0))
            } catch let error as NSError {
                print("No object is read with \(error.debugDescription)")
            }
        }
        // 3
        if let jsonObject = jsonObject as? [String: Any],
            // 4
            let jsonData = JSONValue.fromObject(jsonObject as AnyObject)?["data"]?.array {
            for (_,artworkJSON) in jsonData.enumerated() {
                if let artworkJSON = artworkJSON.array,
                    // 5
                    let artwork = ArtGroup.fromJSON(json: artworkJSON) {
                    COLANCKUTainanArtGroups.append(artwork)
                }
            }
        }
    }
    
    @objc func showInfo(_ annotation: MKAnnotation) {
        print("showInfo")
        //let alertMessagePrefix = NSLocalizedString("Location is selected for ", comment: "")
        var alertImage = UIImage()
        // setup alertController
        var alertView = UIAlertController()
        // weather view action: initialization
        var weatherViewAction = UIAlertAction()
        // Google panoramic views action: initialization
        var panoramicViewAction = UIAlertAction()
        // navigation action: initialization
        var navigationAction = UIAlertAction()
        // activity action
        var activityAction = UIAlertAction()
        // call action
        var callAction = UIAlertAction()
        var annotationObj = Int()
        var isSearchSetAsArtGroup: Bool = false
        
        let margin:CGFloat = 8.0
        let switchViewInAlert = UISwitch(frame: CGRect(x: alertView.view.frame.width-margin-70, y: 10, width: 0, height: 0))
        switchViewInAlert.setOn(false, animated: true)
//        switchViewInAlert.addTarget(self, action: #selector(self.switchStateDidChange(_:)), for: .valueChanged)
        
        OperationQueue.main.addOperation {
            self.alertMessage1 = (self.artGroup?.title)!
            //textToSpeech(alertMessagePrefix + alertMessage1, preUtteranceDelay: nan(nil), postUtteranceDelay: 0.1)
            self.alertMessage2 = (self.artGroup?.descriptive)!
            //textToSpeech(alertMessage2, preUtteranceDelay: nan(nil), postUtteranceDelay: 0.1)
        }
        let CPImage = artGroup?.artImage
        alertImage = UIImage(named: CPImage!)!
        
//        //action: activity
//        activityAction = UIAlertAction(title:"🎉" + NSLocalizedString("Activity Information", comment: "information"), style: .default) {action -> Void in
//            // stop speech
//            OperationQueue.main.addOperation {
//                myVariables.speechSynthesizer.stopSpeaking(at: AVSpeechBoundary.immediate)
//                //textToSpeech(NSLocalizedString("Please refer to webside for more information！", comment: "webside！"), preUtteranceDelay: nan(nil), postUtteranceDelay: 0.1)
//            }
//            let urlString: String = (self.artGroup?.urlString)!
//            let URL = NSURL(string: urlString)! as URL
//            UIApplication.shared.open(URL, options: [:], completionHandler: nil)
//        }
        
        // action: call
        let phoneNumber = artGroup?.phoneNumber
//        callAction = UIAlertAction(title: "☎️" + phoneNumber!, style: .default) {action -> Void in
//            // stop speech
//            myVariables.speechSynthesizer.stopSpeaking(at: AVSpeechBoundary.immediate)
//            //textToSpeech(NSLocalizedString("Ready to dial number！", comment: "dial number"), preUtteranceDelay: nan(nil), postUtteranceDelay: 0.1)
//            let scheme = "tel://\(String(describing: phoneNumber!))"
//            open(scheme: scheme)
//        }
        // weather action: implementation
//        weatherViewAction = UIAlertAction(title: "🌤" + NSLocalizedString("Weather", comment: "weather"), style: .default) {action -> Void in
//            // get weather view
//            self.weatherCoordinate = self.artGroup?.coordinate
//            self.weatherViewTitle = (self.artGroup?.title)!
//            self.getWeatherViews()
//        }
        
        
        // panoramic views action: implementation
//        panoramicViewAction = UIAlertAction(title: "🎡" + NSLocalizedString("360º Panoramic Views", comment: "panoramic views"), style: .default) {action -> Void in
//            // get panoramic view
//            self.panoramicCoordinate = self.artGroup?.coordinate
//            self.panoramicTitle = (self.artGroup?.title)!
//            self.getPanoramicViews()
//        }
        
        // action: map navigation
//        navigationAction = UIAlertAction(title:"📡" + NSLocalizedString("Navigation Service", comment: "navigation"), style: .default) {action -> Void in
//            // stop speech
//            OperationQueue.main.addOperation {
//                myVariables.speechSynthesizer.stopSpeaking(at: AVSpeechBoundary.immediate)
//                //textToSpeech(NSLocalizedString("Navigation to the selected destination！", comment: "navigation"), preUtteranceDelay: nan(nil), postUtteranceDelay: 0.1)
//            }
//            // get direction
//            self.artGroup = annotation as? ArtGroup
//            self.getDirections_loadingFromJSON()
//        }
        isSearchSetAsArtGroup = true
        isNavigation = true
        viewWillAppear(false)
        
        // add items to the main thread
        OperationQueue.main.addOperation {
            if self.isNavigation {
                // setup alertView
                alertView = UIAlertController(title: self.alertMessage1, message: self.alertMessage2, preferredStyle: .actionSheet)
                // setup imageView
                let imageViewInUIAlert = UIImageView(frame: CGRect(x: margin, y: 10, width: 53, height: 53))
                imageViewInUIAlert.image = alertImage
                // cancel action
                let cancelAction = UIAlertAction(title: NSLocalizedString("Cancel", comment: "cancel"), style: .cancel, handler: nil)
                alertView.view.addSubview(imageViewInUIAlert)
                alertView.view.addSubview(switchViewInAlert)
                alertView.view.autoresizesSubviews = true
                // add actions for cases 1, 2
//                if annotation.isEqual(self.artGroup) || isSearchSetAsArtGroup {
//                    alertView.addAction(activityAction)
//                    alertView.addAction(callAction)
//                }
//                alertView.addAction(weatherViewAction)
//                alertView.addAction(navigationAction)
//                alertView.addAction(panoramicViewAction)
                alertView.addAction(cancelAction)
                self.present(alertView, animated: true, completion: nil)
            }
        }
        self.viewWillAppear(true)
        
    }
    
//    @objc func switchStateDidChange(_ sender:UISwitch!){
//        if (sender.isOn == true){
//            printLog(self, funcName: #function, logString: "UISwitch state is now ON")
//            myVariables.speechSynthesizer.continueSpeaking()
//            textToSpeech(alertMessage2, preUtteranceDelay: nan(nil), postUtteranceDelay: 0.1)
//        } else {
//            printLog(self, funcName: #function, logString: "UISwitch state is now Off")
//            myVariables.speechSynthesizer.pauseSpeaking(at: AVSpeechBoundary.word)
//        }
//    }
    
    func createSchedule(){
        
        let placeNumbers = self.COLANCKUTainanArtGroups.count
            
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
            
            startTimes.append(startTime)
            endTimes.append(endTime)
            
        }
        
    }
    
    func configure(location: CLLocationCoordinate2D, index: Int){
        
        let region = MKCoordinateRegion(center: location, latitudinalMeters: 250, longitudinalMeters: 250)
        
        self.mapView.setRegion(region, animated: false)
        
    }
    
    func Alert(title: String ,msg: String){
        let controller = UIAlertController(title: title, message: msg, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        controller.addAction(okAction)
        
        present(controller, animated: true, completion: nil)
        
    }

}


