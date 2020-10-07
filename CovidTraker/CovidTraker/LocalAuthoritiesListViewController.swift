//
//  ViewController.swift
//  CovidTraker
//
//  Created by Richard Stockdale on 06/10/2020.
//

import UIKit

class LocalAuthoritiesListViewController: UIViewController {

    
    @IBOutlet weak var segmentedController: UISegmentedControl!
    @IBOutlet weak var tableView: UITableView!
    
    var dataModels: [LocalAuthorityModel]?
    
    var sortedDataModels: [LocalAuthorityModel]? {
        get {
            guard let models = dataModels else {
                return nil
            }
            
            if segmentedController.selectedSegmentIndex == 0 { // abc
                return models.sorted(by: { (first, second) -> Bool in
                    return first.localAuthorityName > second.localAuthorityName
                })
            }
            else { // rate
                return models.sorted(by: { (first, second) -> Bool in
                    return first.rate.last! > second.rate.last!
                })
            }
        }
    }
    
    @IBAction func segmentedControlChanged(_ sender: Any) {
        tableView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        dataModels = DataLoader.loadBundledData()
    }
}

extension LocalAuthoritiesListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 72
    }
}

extension LocalAuthoritiesListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let models = dataModels else {
            return 0
        }
        
        return models.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! SummaryModelTableViewCell
        let model = sortedDataModels![indexPath.row]
        cell.populate(model: model)
        
        return cell
    }
}


