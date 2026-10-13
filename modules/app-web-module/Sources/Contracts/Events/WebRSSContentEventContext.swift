public import FeatherContracts

public struct WebRSSContentEventContext<T: Sendable>: ExecutionContext {
    public let runtime: T

    public init(runtime: T) {
        self.runtime = runtime
    }
}
