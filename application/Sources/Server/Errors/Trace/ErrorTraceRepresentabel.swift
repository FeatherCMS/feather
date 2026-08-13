//
//  File.swift
//  backend
//
//  Created by Tibor Bödecs on 2026. 04. 19..
//

public protocol ErrorTraceRepresentable {
    var underlyingErrors: [any Error] { get }

    func trace() -> ErrorTrace
    func underlyingTraces() -> [ErrorTrace]

    func lookup<T>(
        _ type: T.Type
    ) -> T?
    func lookup<T, V>(
        _ transform: (T) -> V?
    ) -> V?
}

public extension ErrorTraceRepresentable {

    func underlyingTraces() -> [ErrorTrace] {
        var traces: [ErrorTrace] = []
        for underlyingError in underlyingErrors {
            if let error = underlyingError as? ErrorTraceRepresentable {
                traces.append(error.trace())
            }
            else {
                traces.append(
                    .init(
                        type: type(of: underlyingError),
                        logMessage: String(describing: underlyingError),
                        children: []
                    )
                )
            }
        }
        return traces
    }

    func lookup<T>(
        _ type: T.Type
    ) -> T? {
        for error in underlyingErrors {
            if let match = error as? T {
                return match
            }
            if let nested = error as? ErrorTraceRepresentable,
                let match = nested.lookup(type)
            {
                return match
            }
        }
        return nil
    }

    func lookup<T, V>(
        _ transform: (T) -> V?
    ) -> V? {
        lookup(T.self).flatMap(transform)
    }
}
