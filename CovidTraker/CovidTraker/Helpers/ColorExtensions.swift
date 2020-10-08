//
//  ColorExtensions.swift
//  CovidTraker
//
//  Created by Richard Stockdale on 08/10/2020.
//

import Foundation
import UIKit

extension UIColor {
    static var appGreen: UIColor {
        if let c = UIColor.init(named: "AppGreen") {
            return c
        }
        
        return UIColor.green
        
    }
    
}
