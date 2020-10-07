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
        
        if let lastRate = model.newPositiveCases.last {
            let str = String.init(format: "%.1f", lastRate)
            rateLabel.text = str
        }
        else {
            rateLabel.text = "?"
        }
        
        // Change
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
        
        // Special Measures
        
        localAuthLabel.textColor = .label
        if model.isUnderSpecialMeasures {
            localAuthLabel.textColor = .systemRed
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
