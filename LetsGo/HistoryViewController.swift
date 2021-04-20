//
//  HistoryViewController.swift
//  LetsGo
//
//  Created by KSU on 2019/11/27.
//  Copyright © 2019 KSU. All rights reserved.
//

import UIKit
import Photos

class HistoryViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var myTableView: UITableView!
    var records = [SinglePlaceRecord]()
    var refreshControl: UIRefreshControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //開始下拉更新的功能
        refreshControl = UIRefreshControl()
        //修改顯示文字的顏色
        let attributes = [NSAttributedString.Key.foregroundColor: UIColor.yellow]
        //顯示文字內容
        refreshControl.attributedTitle = NSAttributedString(string: "正在更新", attributes: attributes)
        //設定元件顏色
        refreshControl.tintColor = UIColor.white
        //設定背景顏色
        refreshControl.backgroundColor = UIColor.blue
        //將元件加入TableView的視圖中
        myTableView.refreshControl = refreshControl
        
        refreshControl.addTarget(self, action: #selector(getData), for: UIControl.Event.valueChanged)
        
        if let records = SingleScheduleRecord.readFromeFile(){
            self.records = records
            print(records)
        }
        // Do any additional setup after loading the view.
    }
    
    @objc func getData(){
        if let records = SingleScheduleRecord.readFromeFile(){
            self.records = records
            print(records)
            myTableView.reloadData()
            refreshControl.endRefreshing()
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return records.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = "SinglePlaceCell"
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier,for :indexPath) as! HistoryPlacesTableViewCell
        
        cell.layer.masksToBounds = true
        
        cell.titleLabel?.text = records[indexPath.row].placeTitle
        cell.nameLabel?.text = records[indexPath.row].placeName
        cell.dateTextLabel?.text = records[indexPath.row].dateText
        let assetResult = PHAsset.fetchAssets( withLocalIdentifiers: [records[indexPath.row].photoID], options: nil)
        let asset = assetResult[0]
        let options = PHContentEditingInputRequestOptions()
        options.canHandleAdjustmentData = {(adjustmeta: PHAdjustmentData)
            -> Bool in
            return true
        }
        PHImageManager.default().requestImage(for: asset,
                                              targetSize: CGSize(width:100, height:100), contentMode: .aspectFit,
                                              options: nil, resultHandler: { (image, _:[AnyHashable : Any]?) in
                                                //                                                        print("获取缩略图成功：\(image)")
                                                cell.photoImageView.image = image
        })
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete{
            records.remove(at: indexPath.row)
            SingleScheduleRecord.savetoFile(records: records)
            myTableView.deleteRows(at: [indexPath], with: .fade)
            
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toHistoryDetail"{
            let destinationController = segue.destination as! HistoryDetailViewController
            let indexPath = self.myTableView.indexPathForSelectedRow
            
            destinationController.titleText = records[indexPath!.row].placeTitle
            destinationController.placeName = records[indexPath!.row].placeName
            destinationController.dateText = records[indexPath!.row].dateText
            destinationController.addressText = records[indexPath!.row].addressText
            destinationController.placeComment = records[indexPath!.row].comment
            destinationController.photoID =  records[indexPath!.row].photoID

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
