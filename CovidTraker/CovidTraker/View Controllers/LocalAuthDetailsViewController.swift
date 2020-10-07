//
//  LocalAuthDetailsViewController.swift
//  CovidTraker
//
//  Created by Richard Stockdale on 07/10/2020.
//

import UIKit

class LocalAuthDetailsViewController: UIViewController {
    
    let upImage = UIImage(systemName: "arrow.up")?.withRenderingMode(.alwaysTemplate)
    let downImage = UIImage(systemName: "arrow.down")?.withRenderingMode(.alwaysTemplate)
    let noChangeImage = UIImage(systemName: "equal")?.withRenderingMode(.alwaysTemplate)
    
    @IBOutlet weak var cumulativeCasesLabel: UILabel!
    @IBOutlet weak var newCasesLabel: UILabel!
    @IBOutlet weak var directionArrow: UIImageView!
    @IBOutlet weak var changeDirectionLabel: UILabel!
    @IBOutlet weak var inLockDown: UILabel!
    
    var localAuthModel: LocalAuthorityModel?
    
    private func populate() {
        guard let model = localAuthModel else {
            return
        }
        
        title = model.localAuthorityName
        
        if let lastRate = model.cumulativePositiveCases.last {
            let cumulativeStr = String(format: "%.1f", lastRate)
            cumulativeCasesLabel.text = cumulativeStr
        }
        
        if let lastRate = model.newPositiveCases.last {
            let cumulativeStr = String(format: "%.1f", lastRate)
            newCasesLabel.text = cumulativeStr
        }
        
        // Change
        switch model.change {
        case .up:
            directionArrow.image = upImage
            directionArrow.tintColor = .red
            changeDirectionLabel.text = "There have been more positive results this week, compared to the previous week"
        case .down:
            directionArrow.image = downImage
            directionArrow.tintColor = .green
            changeDirectionLabel.text = "There have been fewer positive results this week, compared to the previous week"
        case .noChange:
            directionArrow.image = upImage
            directionArrow.tintColor = .gray
            changeDirectionLabel.text = "Same number of cases this week, compared to last week"
        }
        
        setLockdownState()
    }
    
    private func setLockdownState() {
        guard let model = localAuthModel else {
            return
        }
        
        if model.isUnderSpecialMeasures {
            inLockDown.text = "This area is currently under special measures.\nTap here to learn more."
            inLockDown.textColor = .red
            
        }
        else {
            inLockDown.text = "This area is not currently under special measures."
            inLockDown.textColor = .green
        }
    }
    
    @IBAction func showSpecialMeasures(_ sender: Any) {
        guard let model = localAuthModel else {
            return
        }
        
        if !model.isUnderSpecialMeasures {
            return
        }
        
        // TODO: Show web view
    }
    
    @IBAction func doneTapped(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        populate()
    }
    
}
