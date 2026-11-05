public import FeatherModuleKit

extension Public.RSS.Event {
    public struct Context<T: Sendable>: ExecutionContext {
        public let runtime: T

        public init(runtime: T) {
            self.runtime = runtime
        }
    }
}
