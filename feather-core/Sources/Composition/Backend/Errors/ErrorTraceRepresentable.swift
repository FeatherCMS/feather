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

extension ErrorTraceRepresentable {

    public func underlyingTraces() -> [ErrorTrace] {
        var traces: [ErrorTrace] = []
        for error in underlyingErrors {
            if let traceable = error as? any ErrorTraceRepresentable {
                traces.append(traceable.trace())
            }
            else {
                traces.append(
                    .init(
                        type: type(of: error),
                        logMessage: String(describing: error),
                        children: []
                    )
                )
            }
        }
        return traces
    }

    public func lookup<T>(
        _ type: T.Type
    ) -> T? {
        for error in underlyingErrors {
            if let match = error as? T {
                return match
            }
            if let traceable = error as? any ErrorTraceRepresentable,
                let match = traceable.lookup(type)
            {
                return match
            }
        }
        return nil
    }

    public func lookup<T, V>(
        _ transform: (T) -> V?
    ) -> V? {
        lookup(T.self).flatMap(transform)
    }
}
