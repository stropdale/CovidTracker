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
    
    /// Array of floats. Position 0 is week 30
    var cumulativePositiveCases: [Float]
    
    var mostRecentWeekCumulativeCases: Float? {
        if cumulativePositiveCases.count == 0 {
            return nil
        }
        
        return cumulativePositiveCases.last
    }
    
    var previousWeekCumulativeCases: Float? {
        if cumulativePositiveCases.count < 2 {
            return nil
        }
        
        return cumulativePositiveCases[newPositiveCases.count - 2]
    }

    init(json: [String : Any]) {
        localAuthorityName = json[localAuthorityNameKey] as! String
        specialMeasuresLink = json[specialMeasuresLinkKey] as! String
        
        cumulativePositiveCases = [Float]()
        
        var keyVal = 30
        var finished = false
        
        while finished == false {
            let key = "w\(keyVal)"
            
            if let val = json[key] {
                if let f = val as? NSNumber {
                    cumulativePositiveCases.append(f.floatValue)
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

/// New positive cases by week
extension LocalAuthorityModel {
    var newPositiveCases: [Float] {
        get {
            var arr = [Float]()
            
            var change: Float = 0.0
            for cases in cumulativePositiveCases {
                let diff = cases - change
                arr.append(diff)
                change = cases
            }
            
            return arr
        }
    }
    
    var mostRecentWeekPositiveCases: Float? {
        if newPositiveCases.count == 0 {
            return nil
        }
        
        return newPositiveCases.last
    }
    
    var previousWeekPositiveCases: Float? {
        if newPositiveCases.count < 2 {
            return nil
        }
        
        return newPositiveCases[newPositiveCases.count - 2]
    }
    
    var change: Change {
        get {
            if newPositiveCases.isEmpty || newPositiveCases.count == 1 {
                return .noChange
            }
            
            let w1 = newPositiveCases[newPositiveCases.count - 2]
            let w2 = newPositiveCases.last!
            
            if w1 == w2 {
                return .noChange
            }
            
            return w1 > w2 ? .down : .up
        }
    }
}
