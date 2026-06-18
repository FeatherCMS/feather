//
//  File.swift
//  backend
//
//  Created by Tibor Bödecs on 2026. 04. 19..
//

import SystemDomain

extension Variable.Error: ErrorTraceRepresentable {
    public var underlyingErrors: [any Error] { [] }

    public func trace() -> ErrorTrace {
        return .init(
            type: type(of: self),
            logMessage: String(describing: self),
            children: underlyingTraces()
        )
    }
}
