//
//  Utils.swift
//  Leafy
//
//  Created by Jiyoung Park on 2022/10/06.
//

import Foundation

struct Utils {
    static var formatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "y. M. d"
        return formatter
    }
}
