//
//  ViewController.swift
//  CovidTraker
//
//  Created by Richard Stockdale on 06/10/2020.
//

import UIKit

class LocalAuthoritiesListViewController: UIViewController, LifeCycle {
    let vm = LocalAuthoritiesListViewModel()
    
    @IBOutlet weak var segmentedController: UISegmentedControl!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    private var isSearching: Bool {
        get {
            return !(searchBar.text?.isEmpty ?? false)
        }
    }
    
    var selectedLocalAuthDetailsViewController: LocalAuthDetailsViewController?
    
    @IBAction func segmentedControlChanged(_ sender: Any) {
        tableView.reloadData()
    }
    
    var models: [LocalAuthorityModel] {
        let models = vm.sortedAndFilteredDataModels(selectedIndex: segmentedController.selectedSegmentIndex,
                                                          searchTerm: searchBar.text)
        
        return models
    }
    
    var favs = Favorites.favorites
    
    func hostedViewDidClose() {
        favs = Favorites.favorites
        tableView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.keyboardDismissMode = .onDrag
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        favs = Favorites.favorites
        tableView.reloadData()
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let nc = segue.destination as? UINavigationController {
            if let vc = nc.viewControllers.first as? LocalAuthDetailsViewController {
                vc.delegate = self
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
        return 80
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        if indexPath.section == 0 && !favs.isEmpty {
            let model = favs[indexPath.row]
            selectedLocalAuthDetailsViewController?.localAuthModel = model
        }
        
        let model = models[indexPath.row]
        selectedLocalAuthDetailsViewController?.localAuthModel = model
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if favs.isEmpty {
            return nil
        }
        
        if section == 0 && !isSearching {
            return "Favorites"
        }
        else {
            return "Local Authorities"
        }
    }
}

extension LocalAuthoritiesListViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        if favs.isEmpty || isSearching {
            return 1
        }
        
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 && !favs.isEmpty && !isSearching {
            return favs.count
        }
        
        return models.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! SummaryModelTableViewCell
        if indexPath.section == 0 && !favs.isEmpty && !isSearching {
            let model = favs[indexPath.row]
            cell.populate(model: model, rank: vm.getRankFor(model: model))
        }
        else {
            let model = models[indexPath.row]
            cell.populate(model: model, rank: vm.getRankFor(model: model))
        }
        
        return cell
    }
}


