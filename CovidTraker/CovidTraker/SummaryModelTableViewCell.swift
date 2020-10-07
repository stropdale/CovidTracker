//
//  SummaryModelTableViewCell.swift
//  CovidTraker
//
//  Created by Richard Stockdale on 07/10/2020.
//

import UIKit

class SummaryModelTableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var labelLeadingContraint: NSLayoutConstraint!
    private let showImageConstraint: CGFloat = 40.0
    private let hideImageConstraint: CGFloat = 0.0
    
    let upImage = UIImage(systemName: "arrow.up")?.withRenderingMode(.alwaysTemplate)
    let downImage = UIImage(systemName: "arrow.down")?.withRenderingMode(.alwaysTemplate)
    let noChangeImage = UIImage(systemName: "equal")?.withRenderingMode(.alwaysTemplate)

    @IBOutlet weak var warningImage: UIImageView!
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
        if model.isUnderSpecialMeasures {
            labelLeadingContraint.constant = showImageConstraint
            warningImage.isHidden = false
        }
        else {
            labelLeadingContraint.constant = hideImageConstraint
            warningImage.isHidden = true
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
