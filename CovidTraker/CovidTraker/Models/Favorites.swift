//
//  Favorites.swift
//  CovidTraker
//
//  Created by Richard Stockdale on 11/10/2020.
//

import Foundation

class Favorites {
    
    private static let favKey = "FavKey"
    
    static var favorites: [String] {
        get {
            if let favorites = UserDefaults.standard.array(forKey: favKey) as? [String] {
                return favorites
            }
            
            return [String]()
        }
    }
    
    static func hasFavorite(favorite: String) -> Bool {
        return favorites.contains(favorite)
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
}
