//
//  DateFormatter+Formats.swift
//  Feather
//
//  Created by Tibor Bodecs on 2019. 12. 30..
//

import Foundation

extension DateFormatter {

    private func configure() {
        calendar = Calendar(identifier: .iso8601)
        locale = Locale(identifier: "en_US_POSIX")
    }

    static let asset: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "y-MM-dd_HH-mm-ss"
        formatter.configure()
        return formatter
    }()

    static let dateTime: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "y/MM/dd HH:mm"
        formatter.configure()
        return formatter
    }()
}
