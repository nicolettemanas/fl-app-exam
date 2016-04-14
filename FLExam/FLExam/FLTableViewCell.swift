//
//  FLTableViewCell.swift
//  FLExam
//
//  Created by Jean Nicolette Manas on 14/04/2016.
//
//

import UIKit

class FLTableViewCell: UITableViewCell {

    @IBOutlet weak var stationImage: UIImageView!
    @IBOutlet weak var showTitle: UILabel!
    @IBOutlet weak var airingTime: UILabel!
    @IBOutlet weak var showRating: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
