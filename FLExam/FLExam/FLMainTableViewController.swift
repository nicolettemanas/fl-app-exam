//
//  ViewController.swift
//  FLExam
//
//  Created by Jean Nicolette Manas on 14/04/2016.
//
//

import UIKit
import Alamofire

struct Show{
    var showTitle : String
    var airingTime : String
    var showRating : String
    var showStation : String
}

class FLMainTableViewController: UITableViewController {
    
    var shows = [String: [Show]]()
    var cellId = "flTableCell"
    var urlRequest = "https://www.whatsbeef.net/wabz/guide.php?start="
    var loadedPage = -1
    var selectedShow : Show?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.registerNib(UINib(nibName: "FLTableCell", bundle: nil), forCellReuseIdentifier: cellId)
        self.loadFooter()
        self.loadMoreData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - App flow methods
    
    func loadFooter() {
        let indicator = UIActivityIndicatorView(frame: CGRectMake(tableView.frame.size.width/2-30, 0, 60, 50))
        indicator.color = UIColor.grayColor()
        let footerView = UIView(frame: CGRectMake(0, 0, tableView.frame.size.width, 50))
        footerView.backgroundColor = UIColor.groupTableViewBackgroundColor()
        footerView.addSubview(indicator)
        indicator.startAnimating()
        
        self.tableView.tableFooterView = footerView
    }
    
    func loadMoreData() {
        loadedPage += 1
        print("loading page \(loadedPage)...")
        let URL = NSURL(string: urlRequest + "\(loadedPage)")!
        let mutableURLRequest = NSMutableURLRequest(URL: URL)
        mutableURLRequest.HTTPMethod = "GET"
        mutableURLRequest.timeoutInterval = 30
        Alamofire.request(mutableURLRequest)
            .responseJSON { response in
                if let _response = response.result.value {
                    self.parseData( _response as! [String : AnyObject])
                }else {
                    print("Failed retrieving page \(self.loadedPage)")
                    self.loadedPage -= 1
                }
        }
    }
    
    func parseData(response : [String : AnyObject]) {
        let _shows = response["results"] as! [[String : AnyObject]]
        for show in _shows{
            
            let newShow = Show(showTitle: show["name"] as! String,
                               airingTime: "\(show["start_time"]!) - \(show["end_time"]!)",
                               showRating: show["rating"] as! String,
                               showStation: show["channel"] as! String)
            
            if self.shows["\(loadedPage)"] == nil {
                self.shows["\(loadedPage)"] = [Show]()
            }
            
            self.shows["\(loadedPage)"]?.append(newShow)
            
        }
        
        self.tableView.reloadData()
    }

    // MARK: - UITableViewDelegate and UITableViewDataSource methods
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier(cellId, forIndexPath: indexPath) as! FLTableViewCell
        
        cell.showTitle.text = self.shows["\(indexPath.section)"]![indexPath.row].showTitle
        cell.airingTime.text = self.shows["\(indexPath.section)"]![indexPath.row].airingTime

        if let _image = UIImage(named:(self.shows["\(indexPath.section)"]![indexPath.row].showRating).uppercaseString) {
            cell.showRating.image = _image
        }else {
            cell.showRating.image = UIImage(named:"NR")
        }
        
        cell.stationImage.image = UIImage(named: (self.shows["\(indexPath.section)"]![indexPath.row].showStation).uppercaseString)
        
        if self.shows.count - 1 == indexPath.section &&
            self.shows["\(indexPath.section)"]?.count == indexPath.row + 1 &&
            indexPath.section == loadedPage {
            self.loadMoreData()
        }
        
        return cell
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return shows.count
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return shows["\(section)"]!.count
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 78
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return "TONIGHT"
        }
        
        let currentDate = NSDate()
        let headerDate = currentDate.dateByAddingTimeInterval(60.0*60.0*24.0*Double(section))
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "MMM dd, YYYY"
        return "\(dateFormatter.stringFromDate(headerDate))"
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.selectedShow = self.shows["\(indexPath.section)"]![indexPath.row]
        self.performSegueWithIdentifier("SHOW_DETAILS", sender: nil)
    }
    
    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 60
    }
    
    // MARK : - Navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "SHOW_DETAILS"{
            let destVC = segue.destinationViewController as! FLDetailsViewController
            destVC.show = self.selectedShow
        }
    }
}

