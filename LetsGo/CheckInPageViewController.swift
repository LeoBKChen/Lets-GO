//
//  CheckInPageViewController.swift
//  LetsGo
//
//  Created by KSU on 2019/11/14.
//  Copyright © 2019 KSU. All rights reserved.
//

import UIKit
import Photos
//import Alamofire
//import SwiftyJSON

protocol CheckInPageViewControllerDelegate {
    func update(record: SinglePlaceRecord)
}

class CheckInPageViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {

    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var editView: UIView!
    @IBOutlet weak var photoView: UIView!

    @IBOutlet weak var image1: UIImageView!

    @IBOutlet weak var titleText: UITextField!
    @IBOutlet weak var placeNameText: UITextField!
    @IBOutlet weak var dateTextField: UITextField!
    @IBOutlet weak var placeCommentText: UITextView!
    
    var delegate: CheckInPageViewControllerDelegate?
    var placeName: String!
    var dateText: String!
    var addressText: String!
    var photos:[UIImage] = []
    var localID: String!
    var time:String!
    var coordianate: CLLocationCoordinate2D!
    
    var currentImage: UIImage!
    var record: SinglePlaceRecord!
    
    var defaultEditViewOrigin: CGFloat!
    var keyboardHeight: CGFloat!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        defaultEditViewOrigin = self.editView.frame.origin.y
        if placeName.isEmpty == false{
            placeNameText.text = placeName
        }
        if dateText.isEmpty == false{
            dateTextField.text = dateText
        }
        
//        NotificationCenter.default.addObserver(self,
//        selector: #selector(CheckInPageViewController.keyboardWillChange(_:)),
//        name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
        NotificationCenter.default.addObserver(self,
        selector: #selector(CheckInPageViewController.keyboardWillShow(_:)),
        name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self,
        selector: #selector(CheckInPageViewController.keyboardWillHide(_:)),
        name: UIResponder.keyboardWillHideNotification, object: nil)
        addTapGesture()
        
        // Do any additional setup after loading the view.
    }
    
    func resignKeyboardNotification(){
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
        
    }
    func addTapGesture(){
        let tap = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        scrollView.addGestureRecognizer(tap)
    }
    @objc func hideKeyboard(){
        self.view.endEditing(true)
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    // 键盘show
    @objc func keyboardWillShow(_ notification: Notification) {
        if let userInfo = notification.userInfo,
            let value = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue{
             
            let frame = value.cgRectValue
            let intersection = frame.intersection(self.view.frame)
            let offset = intersection.height*2/3
            print("keyboard show")

            scrollView.contentOffset = CGPoint(x:0, y: offset)
            
        }
    }
    
    // 键盘hide
    @objc func keyboardWillHide(_ notification: Notification) {
        
            print("keyboard hide")

            scrollView.contentOffset = CGPoint(x:0, y: 0)
           
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[.originalImage] as? UIImage{
            
            saveImage(image: image)
            currentImage = image
            image1.image = image
        }
        dismiss(animated: true, completion: nil)
    }
    
    func saveImage( image: UIImage){
        
        PHPhotoLibrary.shared().performChanges({
            let result = PHAssetChangeRequest.creationRequestForAsset(from: image)
            let assetPlaceholder = result.placeholderForCreatedAsset
            //保存标志符
            self.localID = assetPlaceholder?.localIdentifier
            print("localID : ")
            print(self.localID)
        }) { (isSuccess: Bool, error: Error?) in
            if isSuccess {
                print("保存成功!")                
            } else{
                print("保存失败：", error!.localizedDescription)
            }
        }
    }
    
    @IBAction func takePhoto(_ sender: Any) {
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = .camera
        imagePicker.delegate = self
        present(imagePicker, animated: true, completion: nil)
    }
    
    @IBAction func saveSinglePlaceData(_ sender: Any) {
        
        print(localID)
        if placeNameText.text?.isEmpty == false,
            placeCommentText.text?.isEmpty == false,
            localID != nil,
            let title = titleText.text,
            placeName.isEmpty == false,
            dateText.isEmpty == false,
            let comment = placeCommentText.text{
            print("date:")
            print(dateText)
            record = SinglePlaceRecord(placeTitle: title, placeName: placeName,
                                       dateText: dateText,addressText: addressText, comment: comment,
                                       photoID: self.localID)
            
            delegate?.update(record: record!)

            //upload image
            let url = CONFIG.API_PREFIX + CONFIG.CHECKIN_HISTORY
//            //method1
//            let imageBase64 = currentImage.jpegData(compressionQuality: 0.3)?.base64EncodedString()
//            let params = ["account": "1234",
////                         "image": imageBase64!,
//                        ]
//
//            Alamofire.request(url, method: .post, parameters: params).responseJSON{ response in
//                print(response)
//                if response.result.isSuccess{
//                    let json = JSON(response.result.value!)
//                    print(json)
//
//                }
//                else{
//                    self.Alert(title: "Oops", msg: "請檢查網路狀況")
//                }
//
//            }
            //method2
            
            var account: String = ""
            if let identity = UserDefaults.standard.value(forKey: "UserIdentity") {
                print(identity)
                account = identity as! String
            }
            else{
                account = "guest"
            }
            let data = currentImage.jpegData(compressionQuality: 0.5)
            
            let now:Date = Date()
            
            print("preparing - current Date:")
            print(now)
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy_MM_dd_HH_MM_SS"
            let currentDate = formatter.string(from: now)
            
            let filename = account + "image" + currentDate + ".jpg"
            print("file name = ")
            print(filename)
                        
            //
            let lng = String(self.coordianate.longitude)
            let lat = String(self.coordianate.latitude)
            //
            
//            Alamofire.upload(
//                multipartFormData: { MultipartFormData in
//                    MultipartFormData.append(account.data(using: String.Encoding.utf8)!, withName: "account")
//                    MultipartFormData.append(self.placeName.data(using: String.Encoding.utf8)!, withName: "address")
//                    MultipartFormData.append(title.data(using: String.Encoding.utf8)!, withName: "title")
//                    MultipartFormData.append(comment.data(using: String.Encoding.utf8)!, withName: "textfile")
//                    MultipartFormData.append(data!, withName: "image", fileName: filename, mimeType: "image/jpg")
//                    MultipartFormData.append(lng.data(using: String.Encoding.utf8)!, withName: "lng")
//                    MultipartFormData.append(lat.data(using: String.Encoding.utf8)!, withName: "lat")
//                },
//                to: url,
//                encodingCompletion: { result in
//                    print(result)
//                    self.resignKeyboardNotification()
//                    self.navigationController?.popViewController(animated: true)
//                }
//            )


        }
        else{
            Alert(title: "Oops", msg: "有資料還沒填哦～")
        }
        
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
