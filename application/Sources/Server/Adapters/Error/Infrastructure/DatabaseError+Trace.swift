//
//  File.swift
//  backend
//
//  Created by Tibor Bödecs on 2026. 04. 19..
//

import FeatherDatabase

extension DatabaseError: ErrorTraceRepresentable {

    public var underlyingErrors: [any Error] {
        switch self {
        case .connection(let error):
            [error]
        case .transaction(let error):
            [error]
        case .query(let error):
            [error]
        }
    }

    public func trace() -> ErrorTrace {
        switch self {
        case .connection(_):
            return .init(
                type: Self.self,
                logMessage: "Connection",
                children: underlyingTraces()
            )
        case .transaction(_):
            return .init(
                type: Self.self,
                logMessage: "Transaction",
                children: underlyingTraces()
            )
        case .query(_):
            return .init(
                type: Self.self,
                logMessage: "Query",
                children: underlyingTraces()
            )
        }
    }
}
