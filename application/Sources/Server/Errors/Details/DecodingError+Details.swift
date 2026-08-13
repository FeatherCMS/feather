//
//  File.swift
//  backend
//
//  Created by Tibor Bödecs on 2026. 04. 19..
//

#if canImport(FoundationEssentials)
import FoundationEssentials
#else
import Foundation
#endif

fileprivate extension CodingKey {

    var rawValue: String {
        if let intValue {
            return String(intValue)
        }
        return stringValue
    }
}

extension DecodingError.Context {

    var jsonPath: String {
        var pathItems = ["$"]
        pathItems.append(contentsOf: codingPath.map(\.rawValue))
        return pathItems.joined(separator: ".")
    }
}

extension DecodingError {

    public var message: String {
        "Data decoding error."
    }

    public var reason: String {
        switch self {
        case let .dataCorrupted(context):
            "Data corrupted for key path \(context.jsonPath)."
        case let .keyNotFound(key, context):
            "Key not found \(key.rawValue) for key path \(context.jsonPath)."
        case let .typeMismatch(type, context):
            "Type mismatch, expected \(type) for key path \(context.jsonPath)."
        case let .valueNotFound(type, context):
            "Value not found \(type) for key path \(context.jsonPath)."
        @unknown default:
            "\(self)"
        }
    }
}
