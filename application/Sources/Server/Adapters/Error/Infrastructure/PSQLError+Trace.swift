//
//  File.swift
//  backend
//
//  Created by Tibor Bödecs on 2026. 04. 19..
//

public import PostgresNIO

extension PSQLError: ErrorTraceRepresentable {

    public var underlyingErrors: [any Error] {
        [underlying].compactMap { $0 }
    }

    public func trace() -> ErrorTrace {
        let logMessage = query?.sql ?? String(reflecting: self)

        return .init(
            type: type(of: self),
            logMessage: logMessage,
            children: underlyingTraces()
        )
    }
}
