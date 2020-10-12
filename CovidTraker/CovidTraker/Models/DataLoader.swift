//
//  DataLoader.swift
//  CovidTraker
//
//  Created by Richard Stockdale on 07/10/2020.
//

import Foundation


/// Loads the local data set
class DataLoader {
    static public func loadBundledData() -> [LocalAuthorityModel]? {
        return loadFile(fileName: "dataset")
    }
    
    static private func loadFile(fileName: String) -> [LocalAuthorityModel]? {
        if let path = Bundle.main.path(forResource: fileName, ofType: "json") {
            do {
                let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
                let jsonResult = try JSONSerialization.jsonObject(with: data, options: .mutableLeaves) as! [[String : Any]]
                
                return processData(json: jsonResult)
            }
            catch {
                return nil
            }
        }
        
        return nil
    }
    
    static func processData(json: [[String : Any ]]) -> [LocalAuthorityModel] {
        var dataModels = [LocalAuthorityModel]()
        
        for j in json {
            let model = LocalAuthorityModel.init(json: j)
            dataModels.append(model)
        }
        
        return dataModels
    }
}
