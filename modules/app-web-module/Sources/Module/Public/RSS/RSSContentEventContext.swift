public import FeatherModuleKit

public struct RSSContentEventContext<T: Sendable>: ExecutionContext {
    public let runtime: T

    public init(runtime: T) {
        self.runtime = runtime
    }
}
