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

extension DecodingError: ErrorTraceRepresentable {

    public var underlyingErrors: [any Error] {
        switch self {
        case let .typeMismatch(_, context):
            [context.underlyingError].compactMap { $0 }
        case let .valueNotFound(_, context):
            [context.underlyingError].compactMap { $0 }
        case let .keyNotFound(_, context):
            [context.underlyingError].compactMap { $0 }
        case let .dataCorrupted(context):
            [context.underlyingError].compactMap { $0 }
        @unknown default:
            []
        }
    }

    public func trace() -> ErrorTrace {
        switch self {
        case let .typeMismatch(type, _):
            .init(
                type: Self.self,
                logMessage: "Type mismatch (\(type))",
                children: underlyingTraces()
            )
        case let .valueNotFound(type, _):
            .init(
                type: Self.self,
                logMessage: "Value not found (\(type))",
                children: underlyingTraces()
            )
        case let .keyNotFound(key, _):
            .init(
                type: Self.self,
                logMessage: "Key not found (\(key.stringValue))",
                children: underlyingTraces()
            )
        case .dataCorrupted(_):
            .init(
                type: Self.self,
                logMessage: "Data corrupted",
                children: underlyingTraces()
            )
        @unknown default:
            .init(
                type: Self.self,
                logMessage: "Unknown decoding error",
                children: underlyingTraces()
            )
        }
    }
}
