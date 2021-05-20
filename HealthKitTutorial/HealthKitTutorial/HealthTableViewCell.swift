//
//  HealthTableViewCell.swift
//  HealthKitTutorial
//
//  Created by brian on 2021/05/20.
//

import UIKit

class HealthTableViewCell: UITableViewCell {

    @IBOutlet private weak var timeLabel: UILabel!
    @IBOutlet private weak var stepLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configure(_ time:String,_ step:String) {
        timeLabel.text = time
        stepLabel.text = step
    }

}
