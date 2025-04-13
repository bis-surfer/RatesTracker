//
//  String+DateFormatter.swift
//  ExRTracker
//
//  Created by Ilya Borisov on 12.04.2025.
//

import Foundation

extension String {
    var date: Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.timeZone = TimeZone(secondsFromGMT: 0)
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZZZZZ"   // 2025-04-12T20:21:25.772Z
        
        return dateFormatter.date(from: self)
    }
}
