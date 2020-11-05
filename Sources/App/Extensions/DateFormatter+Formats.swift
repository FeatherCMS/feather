//
//  DateFormatter+Formats.swift
//  FeatherCMS
//
//  Created by Tibor Bodecs on 2019. 12. 30..
//

import Foundation

extension DateFormatter {

    private func configure() {
        calendar = Calendar(identifier: .iso8601)
        locale = Locale(identifier: "en_US_POSIX")
    }

    static let iso8601Full: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "y-MM-dd'T'HH:mm:ss.SSSZ"
        formatter.configure()
        return formatter
    }()

    static let asset: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "y-MM-dd_HH-mm-ss"
        formatter.configure()
        return formatter
    }()

    static let ymd: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "y/MM/dd"
        formatter.configure()
        return formatter
    }()

    static let day: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE"
        formatter.configure()
        return formatter
    }()
}
