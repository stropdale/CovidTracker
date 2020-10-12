//
//  LocalAuthDetailsViewController.swift
//  CovidTraker
//
//  Created by Richard Stockdale on 07/10/2020.
//

import UIKit
import SafariServices

protocol LifeCycle {
    func hostedViewDidClose()
}

class LocalAuthDetailsViewController: UIViewController {
    
    public var delegate: LifeCycle?
    
    private let upImage = UIImage(systemName: "arrow.up")?.withRenderingMode(.alwaysTemplate)
    private let downImage = UIImage(systemName: "arrow.down")?.withRenderingMode(.alwaysTemplate)
    private let noChangeImage = UIImage(systemName: "equal")?.withRenderingMode(.alwaysTemplate)
    
    private let favIcon = UIImage.init(systemName: "star.fill")
    private let notFavIcon = UIImage.init(systemName: "star")
    
    
    @IBOutlet private weak var favStar: UIBarButtonItem!
    
    @IBOutlet private weak var cumulativeCasesStatsLabel: UILabel!
    @IBOutlet private weak var cumulativeCasesDescLabel: UILabel!
    
    @IBOutlet private weak var newCasesStatsLabel: UILabel!
    @IBOutlet private weak var newCasesDescLabel: UILabel!
    
    @IBOutlet private weak var directionArrow: UIImageView!
    @IBOutlet private weak var directionDescLabel: UILabel!
    
    @IBOutlet private weak var changeDirectionLabel: UILabel!
    @IBOutlet private weak var inLockDown: UILabel!
    
    @IBOutlet private weak var newCasesChart: AllTimeChart!
    @IBOutlet private weak var newCasesChartLabel: UILabel!
    
    @IBOutlet private weak var cumulativeCasesChart: AllTimeChart!
    @IBOutlet private weak var cumulativeCasesChartLabel: UILabel!
    
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
        
        setUpNewCasesChart()
        setUpCumulativeCasesChart()
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
        cumulativeCasesDescLabel.text = "new cases of COVID-19 reported per 100k in the week ending \(dateStr), since the 29th June."
    }
    
    private func setLockdownState() {
        guard let model = localAuthModel else {
            return
        }
        
        if model.isUnderSpecialMeasures {
            inLockDown.text = "\(model.localAuthorityName) currently has additional local restrictions.\nTap here to learn more."
            inLockDown.textColor = .red
            
        }
        else {
            inLockDown.text = "\(model.localAuthorityName) is not currently under special measures."
            inLockDown.textColor = .appGreen
        }
    }
    
    @IBAction func tappedFav(_ sender: UIBarButtonItem) {
        if sender.image == favIcon { // Unfav
            sender.image = notFavIcon
            
            if let name = localAuthModel?.localAuthorityName {
                Favorites.removeFavorite(favorite: name)
            }
        }
        else { // Fav
            sender.image = favIcon
            if let name = localAuthModel?.localAuthorityName {
                Favorites.addFavorite(favorite: name)
            }
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
        showFavState()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        delegate?.hostedViewDidClose()
    }
    
    private func showFavState() {
        guard let name = localAuthModel?.localAuthorityName else {
            return
        }
        
        if Favorites.hasFavorite(favorite: name) {
            favStar.image = favIcon
        }
        else {
            favStar.image = notFavIcon
        }
    }
}

// MARK: - All time charts
extension LocalAuthDetailsViewController {
    private func setUpNewCasesChart() {
        guard let model = localAuthModel else {
            return
        }
        
        if let str = startEndString() {
            newCasesChartLabel.text = str
        }
        else {
            newCasesChartLabel.text = "Positive cases per 100k"
        }
        
        var dataPoints = [ChartDataPoint]()
        for (i, f) in model.newPositiveCases.enumerated() {
            // Ignore the first figure
            if i == 0 {
                continue
            }
            
            let date = DateHelpers.endDateForArrayPosition(position: i)
            dataPoints.append(ChartDataPoint.init(date: date, value: f))
        }
        
        newCasesChart.dataSet(dataSet: dataPoints)
    }
    
    private func setUpCumulativeCasesChart() {
        guard let model = localAuthModel else {
            return
        }
        
        if let str = startEndString() {
            cumulativeCasesChartLabel.text = str
        }
        else {
            cumulativeCasesChartLabel.text = "Positive cases per 100k"
        }
        
        var dataPoints = [ChartDataPoint]()
        for (i, f) in model.cumulativePositiveCases.enumerated() {
            let date = DateHelpers.endDateForArrayPosition(position: i)
            dataPoints.append(ChartDataPoint.init(date: date, value: f))
        }
        
        cumulativeCasesChart.dataSet(dataSet: dataPoints)
    }
    
    private func startEndString() -> String? {
        guard let model = localAuthModel else {
            return ""
        }
        
        let start = DateHelpers.startDateStrForArrayPosition(position: 0)
        let end = DateHelpers.endDateStrForArrayPosition(position: model.cumulativePositiveCases.count - 1)
        
        let str = "Positive cases per 100k from \(start) to \(end)"
        
        return str
    }
}

extension LocalAuthDetailsViewController: SFSafariViewControllerDelegate {
    // Nothing yet
}
