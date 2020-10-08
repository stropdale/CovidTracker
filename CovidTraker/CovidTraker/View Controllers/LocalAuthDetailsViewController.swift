//
//  LocalAuthDetailsViewController.swift
//  CovidTraker
//
//  Created by Richard Stockdale on 07/10/2020.
//

import UIKit
import SafariServices

class LocalAuthDetailsViewController: UIViewController {
    
    let upImage = UIImage(systemName: "arrow.up")?.withRenderingMode(.alwaysTemplate)
    let downImage = UIImage(systemName: "arrow.down")?.withRenderingMode(.alwaysTemplate)
    let noChangeImage = UIImage(systemName: "equal")?.withRenderingMode(.alwaysTemplate)
    
    @IBOutlet weak var cumulativeCasesStatsLabel: UILabel!
    @IBOutlet weak var cumulativeCasesDescLabel: UILabel!
    
    @IBOutlet weak var newCasesStatsLabel: UILabel!
    @IBOutlet weak var newCasesDescLabel: UILabel!
    
    @IBOutlet weak var directionArrow: UIImageView!
    @IBOutlet weak var directionDescLabel: UILabel!
    
    @IBOutlet weak var changeDirectionLabel: UILabel!
    @IBOutlet weak var inLockDown: UILabel!
    
    var localAuthModel: LocalAuthorityModel?
    
    private func populate() {
        guard let model = localAuthModel else {
            return
        }
        
        title = model.localAuthorityName

        setLockdownState()
        setNewCases()
        setCumilativeCases()
        setDirection()
    }
    
    private func setNewCases() {
        guard let model = localAuthModel else {
            return
        }
        
        guard let lastRate = model.mostRecentWeekPositiveCases else {
            return
        }
        
        let cumulativeStr = String(format: "%.1f", lastRate)
        newCasesStatsLabel.text = cumulativeStr
        
        // Description
        
        //TODO: Week ending date
        let dateStr = DateHelpers.endDateStrForArrayPosition(position: model.newPositiveCases.count - 1)
        newCasesDescLabel.text = "new cases of COVID-19 reported per 100k in the week ending \(dateStr)."
    }
    
    private func setDirection() {
        guard let model = localAuthModel else {
            return
        }
        
        // Stat
        
        // TODO: Number of cases change
        let thisWeek = model.mostRecentWeekPositiveCases
        let lastWeek = model.previousWeekPositiveCases
        
        switch model.change {
        case .up:
            directionArrow.image = upImage
            directionArrow.tintColor = .red
            
            if let tw = thisWeek, let lw = lastWeek {
                let diff = String(format: "%.1f", tw - lw)
                changeDirectionLabel.text = "Which is \(diff) (per 100k) more cases than were reported in the previous week. Meaning there have been..."
            }
            else {
                changeDirectionLabel.text = "Which is more cases than were reported in the previous week. Meaning there have been..."
            }
            
            
        case .down:
            directionArrow.image = downImage
            directionArrow.tintColor = .appGreen
    
            if let tw = thisWeek, let lw = lastWeek {
                let diff = String(format: "%.1f", lw - tw)
                changeDirectionLabel.text = "Which is \(diff) (per 100k) fewer cases than were reported in the previous week. Meaning there have been..."
            }
            else {
                changeDirectionLabel.text = "Which is fewer cases than were reported in the previous week. Meaning there have been..."
            }
            
        case .noChange:
            directionArrow.image = upImage
            directionArrow.tintColor = .gray
            changeDirectionLabel.text = "which is the same number as the previous week. Meaning there have been..."
        }
    }
    
    private func setCumilativeCases() {
        guard let model = localAuthModel else {
            return
        }
        
        // Stat
        guard let lastRate = model.mostRecentWeekCumulativeCases else {
            return
        }
        
        let cumulativeStr = String(format: "%.1f", lastRate)
        cumulativeCasesStatsLabel.text = cumulativeStr
        
        // Description
        let dateStr = DateHelpers.endDateStrForArrayPosition(position: model.newPositiveCases.count - 1)
        cumulativeCasesDescLabel.text = "new cases of COVID-19 reported per 100k in the week ending \(dateStr), since the 29th of June"
    }
    
    private func setLockdownState() {
        guard let model = localAuthModel else {
            return
        }
        
        if model.isUnderSpecialMeasures {
            inLockDown.text = "\(model.localAuthorityName) is currently under special measures.\nTap here to learn more."
            inLockDown.textColor = .red
            
        }
        else {
            inLockDown.text = "\(model.localAuthorityName) is not currently under special measures."
            inLockDown.textColor = .appGreen
        }
    }
    
    @IBAction func showSpecialMeasures(_ sender: Any) {
        guard let model = localAuthModel else {
            return
        }
        
        if !model.isUnderSpecialMeasures {
            return
        }
        
        if let url = URL(string: model.specialMeasuresLink) {
            let vc = SFSafariViewController.init(url: url)
            vc.delegate = self

            present(vc, animated: true)
        }
    }
    
    @IBAction func doneTapped(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.prefersLargeTitles = true
        populate()
    }
    
}

extension LocalAuthDetailsViewController: SFSafariViewControllerDelegate {
    // Nothing yet
}
