//
//  File.swift
//  backend
//
//  Created by Tibor Bödecs on 2026. 04. 19..
//

import FeatherDatabasePostgres

extension DatabaseTransactionErrorPostgres: ErrorTraceRepresentable {

    private var logMessage: String {
        if beginError != nil { return "Begin" }
        if closureError != nil { return "Closure" }
        if commitError != nil { return "Commit" }
        if rollbackError != nil { return "Rollback" }
        return "Unknown"
    }

    public var underlyingErrors: [any Error] {
        if let beginError { return [beginError] }
        if let closureError { return [closureError] }
        if let commitError { return [commitError] }
        if let rollbackError { return [rollbackError] }
        return []
    }

    public func trace() -> ErrorTrace {
        .init(
            type: Self.self,
            logMessage: logMessage,
            children: underlyingTraces()
        )
    }
}
