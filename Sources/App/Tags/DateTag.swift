//
//  DateFormatterTag.swift
//  FeatherCMS
//
//  Created by Tibor Bodecs on 2020. 06. 18..
//

import Vapor
import Leaf

fileprivate extension DateFormatter {

    static let leaf: DateFormatter = {
        var formatter = DateFormatter()
        formatter.calendar = Calendar(identifier: .iso8601)
        formatter.locale = Locale(identifier: "en_US_POSIX")
        return formatter
    }()
}

struct DateFormatterTag: LeafTag {

    static let name = "dateFormatter"

    func render(_ ctx: LeafContext) throws -> LeafData {
        
        guard let time = ctx.parameters.first?.double else {
            throw "invalid \(Self.name) parameters"
        }
        var format = "y-MM-dd'T'HH:mm:ssZ"
        if ctx.parameters.count > 1, let customFormat = ctx.parameters[1].string {
            format = customFormat
        }
        DateFormatter.leaf.dateFormat = format
        return .string(DateFormatter.leaf.string(from: .init(timeIntervalSince1970: time)))
    }
}
