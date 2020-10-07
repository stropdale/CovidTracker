//
//  SummaryModelTableViewCell.swift
//  CovidTraker
//
//  Created by Richard Stockdale on 07/10/2020.
//

import UIKit

class SummaryModelTableViewCell: UITableViewCell {

    @IBOutlet weak var localAuthLabel: UILabel!
    @IBOutlet weak var rateLabel: UILabel!
    @IBOutlet weak var directionArrow: UIImageView!
    
    func populate(model: LocalAuthorityModel) {
        localAuthLabel.text = model.localAuthorityName
        if let lastRate = model.rate.last {
            rateLabel.text = "\(lastRate)"
        }
        else {
            rateLabel.text = "?"
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
