//
//  ViewController.swift
//  CovidTraker
//
//  Created by Richard Stockdale on 06/10/2020.
//

import UIKit

class LocalAuthoritiesListViewController: UIViewController {

    let vm = LocalAuthoritiesListViewModel()
    
    @IBOutlet weak var segmentedController: UISegmentedControl!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    var selectedLocalAuthDetailsViewController: LocalAuthDetailsViewController?
    
    @IBAction func segmentedControlChanged(_ sender: Any) {
        tableView.reloadData()
    }
    
    var models: [LocalAuthorityModel] {
        let models = vm.sortedAndFilteredDataModels(selectedIndex: segmentedController.selectedSegmentIndex,
                                                          searchTerm: searchBar.text)
        
        return models
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.keyboardDismissMode = .onDrag
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let nc = segue.destination as? UINavigationController {
            if let vc = nc.viewControllers.first as? LocalAuthDetailsViewController {
                selectedLocalAuthDetailsViewController = vc
            }
        }
        else {
            selectedLocalAuthDetailsViewController = nil
        }
    }
}

// Search
extension LocalAuthoritiesListViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        tableView.reloadData()
    }
}

extension LocalAuthoritiesListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 72
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let model = models[indexPath.row]
        selectedLocalAuthDetailsViewController?.localAuthModel = model
    }
}

extension LocalAuthoritiesListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return models.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! SummaryModelTableViewCell
        let model = models[indexPath.row]
        cell.populate(model: model, rank: vm.getRankFor(model: model))
        
        return cell
    }
}


