//
//  AboutUsTableViewController.swift
//  LetsGo
//
//  Created by KSU on 2020/5/7.
//  Copyright © 2020 KSU. All rights reserved.
//

import UIKit
import SafariServices

class AboutUsTableViewController: UITableViewController {

    var sectionTitles = [NSLocalizedString("Leave Feedback", comment: "Leave Feedback"), NSLocalizedString("Follow Us", comment: "Follow Us")]
    var sectionContent = [[NSLocalizedString("Rate us on App Store", comment: "Rate us on App Store"), NSLocalizedString("Tell us your feedback", comment: "Tell us your feedback")],
                          [NSLocalizedString("Facebook", comment: "Facebook")]]
    var links = ["https://www.facebook.com/%E5%87%BA%E9%96%80%E5%90%A7-Lets-Go-IOS-APP-100588878334886/"]

    override func viewDidLoad() {
        super.viewDidLoad()

        // remove empty list on table
        tableView.tableFooterView = UIView(frame: CGRect.zero)
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return sectionTitles.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return sectionContent[section].count
    }

    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sectionTitles[section]
    }


    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AboutUsCell", for: indexPath)

        // Configure the cell...
        cell.textLabel?.text = sectionContent[indexPath.section][indexPath.row]

        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        switch indexPath.section {
        // Leave us feedback section
        case 0:
            if indexPath.row == 0 {
                let urlString: NSString = "https://itunes.apple.com/us/app/台南新樂園/id1307993782?l=zh&ls=1&mt=8"
                if let url = URL(string: urlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!) {
                    UIApplication.shared.open(url)
                }
            } else if indexPath.row == 1 { // tell us your feedback
                performSegue(withIdentifier: "ShowWebView", sender: self) // manual segue
            }

        // Follow us section: FaceBook
        case 1:
            if let url = URL(string: links[indexPath.row]) {
                let safariController = SFSafariViewController(url: url)
                present(safariController, animated: true, completion: nil)
            }

        default:
            break
        }

        tableView.deselectRow(at: indexPath, animated: false)
    }


    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

