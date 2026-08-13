//
//  File.swift
//  backend
//
//  Created by Tibor Bödecs on 2026. 04. 19..
//

import OpenAPIRuntime

extension ServerError: ErrorTraceRepresentable {

    public var underlyingErrors: [any Error] {
        [underlyingError]
    }

    public func trace() -> ErrorTrace {
        return .init(
            type: Self.self,
            logMessage: operationID,
            children: underlyingTraces()
        )
    }
}
