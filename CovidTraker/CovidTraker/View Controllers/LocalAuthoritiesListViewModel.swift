//
//  LocalAuthoritiesListViewModel.swift
//  CovidTraker
//
//  Created by Richard Stockdale on 07/10/2020.
//

import Foundation

class LocalAuthoritiesListViewModel {
    
    private var dataModels: [LocalAuthorityModel]?
    
    init() {
        dataModels = DataLoader.loadBundledData()
    }
    
    func sortedAndFilteredDataModels(selectedIndex: Int, searchTerm: String?) -> [LocalAuthorityModel] {
        guard let models = selectedIndex == 0 ? alphaSortedDataModels : rankSortedDataModels else {
            return [LocalAuthorityModel]()
        }
        
        guard let searchTerm = searchTerm else {
            return models
        }
        
        if searchTerm.isEmpty {
            return models
        }
        
        return searchModels(models: models, term: searchTerm)
    }
    
    private func searchModels(models: [LocalAuthorityModel], term: String) -> [LocalAuthorityModel] {
        var filtered = [LocalAuthorityModel]()
        for model in models {
            if model.localAuthorityName.contains(term) {
                filtered.append(model)
            }
        }
        
        return filtered
    }
    
    private var alphaSortedDataModels: [LocalAuthorityModel]? {
        guard let models = dataModels else {
            return nil
        }
        
        return models.sorted(by: { (first, second) -> Bool in
            return first.localAuthorityName < second.localAuthorityName
        })
    }
    
    private var rankSortedDataModels: [LocalAuthorityModel]? {
        guard let models = dataModels else {
            return nil
        }
        
        return models.sorted(by: { (first, second) -> Bool in
            return first.newPositiveCases.last! > second.newPositiveCases.last!
        })
    }
    
    func getRankFor(model: LocalAuthorityModel) -> Int? {
        guard let arr = rankSortedDataModels else {
            return nil
        }
        
        let name = model.localAuthorityName
        for (i, m) in arr.enumerated() {
            if name == m.localAuthorityName {
                return i + 1
            }
        }
        
        return nil
    }
}
