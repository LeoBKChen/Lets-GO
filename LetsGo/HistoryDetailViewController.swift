//
//  HistoryDetailViewController.swift
//  LetsGo
//
//  Created by KSU on 2020/1/2.
//  Copyright © 2020 KSU. All rights reserved.
//

import UIKit
import Photos

class HistoryDetailViewController: UIViewController {
    
    
    @IBOutlet weak var photoImage: UIImageView!

    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var placeNameTextField: UITextField!
    @IBOutlet weak var dateTextField: UITextField!
    @IBOutlet weak var addressTextField: UITextField!
    @IBOutlet weak var commentTextView: UITextView!

    
    var photoID: String!
    var titleText: String!
    var placeName: String!
    var dateText: String!
    var addressText: String!
    var placeComment: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if(titleText.isEmpty == false){
            titleTextField.text = titleText
        }
        if(placeName.isEmpty == false){
            placeNameTextField.text = placeName
        }
        if(dateText.isEmpty == false){
            dateTextField.text = dateText
        }
        if(addressText.isEmpty == false){
            addressTextField.text = addressText
        }
        if(placeComment.isEmpty == false){
            commentTextView.text = placeComment
        }
        
        let assetResult = PHAsset.fetchAssets( withLocalIdentifiers: [photoID], options: nil)
        let asset = assetResult[0]
        let options = PHContentEditingInputRequestOptions()
        options.canHandleAdjustmentData = {(adjustmeta: PHAdjustmentData)
            -> Bool in
            return true
        }
        PHImageManager.default().requestImage(for: asset,
                                              targetSize: CGSize(width:500, height:300), contentMode: .aspectFit,
                                              options: nil, resultHandler: { (image, _:[AnyHashable : Any]?) in
                                                //                                                        print("获取缩略图成功：\(image)")
                                                self.photoImage.image = image
        })
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


    //func showShareOptions(_ sender: Any) {
    
    @IBAction func showShareOptions(_ sender: Any) {
//        if ConnectionCheck.isConnectedToNetwork() {
//            printLog(self, funcName: #function, logString: "The internect is connected!")
//        } else {
//            let alertMessage = "The internect is not available!"
//            printLog(self, funcName: #function, logString: alertMessage)
//            showAlert(NSLocalizedString("No Internet", comment: "No Internet"), message: NSLocalizedString("Please check the mobile data network or\n WiFi connection works normally", comment: "Check WiFi connection"))
//            return
//        }

        //textToSpeech(NSLocalizedString("Photos easily share！", comment: "Photos easily share"), preUtteranceDelay: nan(nil), postUtteranceDelay: 0.1)
        let imageToShare = self.photoImage.image
        let alertView = UIAlertController(title: "照片分享", message: titleText, preferredStyle: .actionSheet)
    
        //action: social media share
        let shareAction = UIAlertAction(title: "社群媒體", style: .default) {(action) -> Void in
            // stop speech
//            myVariables.speechSynthesizer.stopSpeaking(at: AVSpeechBoundary.immediate)
            // share to social media
            let defaultText = "跟你分享好玩景點：" + self.titleText
            let activityViewController = UIActivityViewController(activityItems: [defaultText, imageToShare!], applicationActivities: nil)
            
            if let popoverController = activityViewController.popoverPresentationController {
                popoverController.sourceView = self.view
                popoverController.sourceRect = CGRect(x: self.view.bounds.midX, y: self.view.bounds.midY, width: 0, height: 0)
                popoverController.permittedArrowDirections = []
            }
            
            self.present(activityViewController, animated: true, completion: nil)
        }
        //action: iCloud share
       
    
        // imageView of UIAlert box
        let margin:CGFloat = 8.0
        let imageViewInUIAlert = UIImageView(frame: CGRect(x: margin, y: 10, width: 53, height: 53))
        imageViewInUIAlert.image = imageToShare
    
        // cancel action
        let cancelAction = UIAlertAction(title: "取消", style: .cancel) {action -> Void in
            //myVariables.speechSynthesizer.stopSpeaking(at: AVSpeechBoundary.immediate)
        }
        alertView.view.addSubview(imageViewInUIAlert)
        alertView.view.autoresizesSubviews = true
        alertView.addAction(shareAction)
        alertView.addAction(cancelAction)
        
        // ref: https://medium.com/@nickmeehan/actionsheet-popover-on-ipad-in-swift-5768dfa82094
        if let popoverController = alertView.popoverPresentationController {
            popoverController.sourceView = self.view
            popoverController.sourceRect = CGRect(x: self.view.bounds.midX, y: self.view.bounds.midY, width: 0, height: 0)
            popoverController.permittedArrowDirections = []
        }
        
        present(alertView, animated: true, completion: nil)
    
    }
    

}
