//
//  NotesAppDataHelper.swift
//  Notes app
//
//  Created by Andrii Kryvytskyi on 14.11.2019.
//  Copyright © 2019 Andrii Kryvytskyi. All rights reserved.
//

import Foundation

class NotesAppDateHelper {
    
    static func convertDate(date: Date, dateFormat: String) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let myString = formatter.string(from: date)
        let yourDate = formatter.date(from: myString)
        formatter.dateFormat = dateFormat
        let myStringafd = formatter.string(from: yourDate!)
        return myStringafd
    }
}

extension Date {
    func toSeconds() -> Int64! {
        return Int64((self.timeIntervalSince1970).rounded())
    }
    
    init(seconds:Int64!) {
        self = Date(timeIntervalSince1970: TimeInterval(Double.init(seconds)))
    }
}
