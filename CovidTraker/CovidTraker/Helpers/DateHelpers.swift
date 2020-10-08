//
//  DateHelpers.swift
//  CovidTraker
//
//  Created by Richard Stockdale on 08/10/2020.
//

import Foundation

class DateHelpers {
    static func startDateForArrayPosition(position: Int) -> Date {
        let week30Start = "2020-07-20T00:00:00+0000"

        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX") // set locale to reliable US_POSIX
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        let date = dateFormatter.date(from:week30Start)!
        
        let modifiedDate = Calendar.current.date(byAdding: .day , value: position * 7, to: date)
        
        return modifiedDate!
    }
    
    static func endDateForArrayPosition(position: Int) -> Date {
        let week30End = "2020-07-26T00:00:00+0000"

        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX") // set locale to reliable US_POSIX
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        let date = dateFormatter.date(from:week30End)!
        
        let modifiedDate = Calendar.current.date(byAdding: .day , value: position * 7, to: date)
        
        return modifiedDate!

    }
    
    static func startDateStrForArrayPosition(position: Int) -> String {
        let date = startDateForArrayPosition(position: position)
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .none
        
        return dateFormatter.string(from: date)
    }
    
    static func endDateStrForArrayPosition(position: Int) -> String {
        let date = endDateForArrayPosition(position: position)
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .none
        
        return dateFormatter.string(from: date)
    }
}