//
//  LocalAuthorityModel.swift
//  CovidTraker
//
//  Created by Richard Stockdale on 06/10/2020.
//

import Foundation

struct LocalAuthorityModel {
    
    private let localAuthorityNameKey = "localAuthorityName"
    private let specialMeasuresLinkKey = "specialMeasuresLink"
    
    /// Name of the local Authority
    let localAuthorityName: String
    
    /// Is there a special measures link. If empty the area is not in specidal measures
    let specialMeasuresLink: String
    
    var isUnderSpecialMeasures: Bool {
        get {
            return !specialMeasuresLink.isEmpty
        }
    }
    
    /// Array of floats. Position 0 is week 30
    var rate: [Float]
    
    init(json: [String : Any]) {
        localAuthorityName = json[localAuthorityNameKey] as! String
        specialMeasuresLink = json[specialMeasuresLinkKey] as! String
        
        rate = [Float]()
        
        var keyVal = 30
        var finished = false
        
        while finished == false {
            let key = "w\(keyVal)"
            
            if let val = json[key] as? Float {
                rate.append(val)
            }
            else {
                finished = true
            }
            
            keyVal += 1
        }
    }
}
