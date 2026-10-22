public import FeatherModuleKit

/// Context for frontend-owned web presentation event providers.
extension WebModule {
    public enum Event {}
}

extension WebModule.Event {
    public struct Context: ExecutionContext {
        public init() {}
    }
}
