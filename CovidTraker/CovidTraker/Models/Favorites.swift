//
//  Favorites.swift
//  CovidTraker
//
//  Created by Richard Stockdale on 11/10/2020.
//

import Foundation

class Favorites {
    
    private static let favKey = "FavKey"
    private static var allLAs: [LocalAuthorityModel]?
    
    static var favoritesNames: [String] {
        get {
            if let favorites = UserDefaults.standard.array(forKey: favKey) as? [String] {
                return favorites
            }
            
            return [String]()
        }
    }
    
    static func hasFavorite(favorite: String) -> Bool {
        return favoritesNames.contains(favorite)
    }
    
    static func addFavorite(favorite: String) {
        guard var favorites = UserDefaults.standard.array(forKey: favKey) as? [String] else {
            var arr = [String]()
            arr.append(favorite)
            UserDefaults.standard.setValue(arr, forKey: favKey)
            
            return
        }
        
        favorites.append(favorite)
        UserDefaults.standard.setValue(favorites, forKey: favKey)
    }
    
    static func removeFavorite(favorite: String) {
        guard var favorites = UserDefaults.standard.array(forKey: favKey) as? [String] else {
            return
        }
        
        var found: Int?
        for (i, f) in favorites.enumerated() {
            if f == favorite {
                found = i
                break
            }
        }
        
        if let found = found {
            favorites.remove(at: found)
            UserDefaults.standard.setValue(favorites, forKey: favKey)
        }
    }
    
    static var favorites: [LocalAuthorityModel] {
        get {
            var results = [LocalAuthorityModel]()
            
            guard let arr = DataLoader.loadBundledData() else {
                return results
            }
            
            for item in arr {
                if favoritesNames.contains(item.localAuthorityName) {
                    results.append(item)
                }
            }
            
            return results.sorted(by: { (first, second) -> Bool in
                return first.localAuthorityName < second.localAuthorityName
            })
        }
    }
}
