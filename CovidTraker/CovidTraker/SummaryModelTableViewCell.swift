//
//  SummaryModelTableViewCell.swift
//  CovidTraker
//
//  Created by Richard Stockdale on 07/10/2020.
//

import UIKit

class SummaryModelTableViewCell: UITableViewCell {
    
    let upImage = UIImage(systemName: "arrow.up")?.withRenderingMode(.alwaysTemplate)
    let downImage = UIImage(systemName: "arrow.down")?.withRenderingMode(.alwaysTemplate)
    let noChangeImage = UIImage(systemName: "equal")?.withRenderingMode(.alwaysTemplate)

    @IBOutlet weak var localAuthLabel: UILabel!
    @IBOutlet weak var rateLabel: UILabel!
    @IBOutlet weak var directionArrow: UIImageView!
    
    func populate(model: LocalAuthorityModel, rank: Int?) {
        if let rank = rank {
            localAuthLabel.text = "\(model.localAuthorityName) (\(rank))"
        }
        else {
            localAuthLabel.text = model.localAuthorityName
        }
        
        if let lastRate = model.rate.last {
            rateLabel.text = "\(lastRate)"
        }
        else {
            rateLabel.text = "?"
        }
        
        switch model.change {
        case .up:
            directionArrow.image = upImage
            directionArrow.tintColor = .red
        case .down:
            directionArrow.image = downImage
            directionArrow.tintColor = .green
        case .noChange:
            directionArrow.image = upImage
            directionArrow.tintColor = .gray
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
