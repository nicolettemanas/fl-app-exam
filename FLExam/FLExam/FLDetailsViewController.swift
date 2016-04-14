//
//  FLDetailsViewController.swift
//  FLExam
//
//  Created by Jean Nicolette Manas on 14/04/2016.
//
//

import UIKit

class FLDetailsViewController: UIViewController {

    var detailsView : FLDetailsView?
    var show : Show?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.detailsView = NSBundle.mainBundle().loadNibNamed("FLDetailsView", owner: nil, options: nil).first as? FLDetailsView
        self.view = self.detailsView
        self.title = self.show?.showTitle
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        self.detailsView?.showTitle.text = self.show?.showTitle
        self.detailsView?.airingTime.text = self.show?.airingTime
        if let _image = UIImage(named:(self.show?.showRating.uppercaseString)!) {
            self.detailsView?.showRating.image = _image
        }else {
            self.detailsView?.showRating.image = UIImage(named:"NR")
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
