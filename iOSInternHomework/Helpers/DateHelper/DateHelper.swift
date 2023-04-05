//
//  DateHelper.swift
//  iOSInternHomework
//
//  Created by Peter Chiou on 2023/4/5.
//

import Foundation

class DateHelper {
    static func getYYYYMMddFormant(dateFormat: String, dateString: String) -> String{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = dateFormat
        
        guard let date = dateFormatter.date(from: dateString) else { return "yyyy-MM-dd'T'HH:mm:ssZ" }
        dateFormatter.dateFormat = "yyyy/MM/dd"
        let formattedDateString = dateFormatter.string(from: date)
        return formattedDateString
    }
}
