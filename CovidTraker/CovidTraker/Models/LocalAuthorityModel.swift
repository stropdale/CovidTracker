//
//  LocalAuthorityModel.swift
//  CovidTraker
//
//  Created by Richard Stockdale on 06/10/2020.
//

import Foundation

struct LocalAuthorityModel {
    
    enum Change {
        case up
        case down
        case noChange
    }
    
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
    
    var change: Change {
        get {
            if rate.isEmpty || rate.count == 1 {
                return .noChange
            }
            
            let w1 = rate[rate.count - 2]
            let w2 = rate.last!
            
            if w1 == w2 {
                return .noChange
            }
            
            return w1 > w2 ? .down : .up
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
            
            if let val = json[key] {
                if let f = val as? NSNumber {
                    rate.append(f.floatValue)
                }
                else {
                    let t = type(of: val)
                    print("Could not convert \(key) with a value of \(val) to float. Type is \(t)")
                    finished = true
                    
                    fatalError()
                }
            }
            else {
                finished = true
            }
            
            keyVal += 1
        }
    }
}
