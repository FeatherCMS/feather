public import FeatherAdmin
public import FeatherModuleKit

extension Dashboard.Event {
    public struct Context: ExecutionContext {
        public let requestContext: AuthenticatedRequestContext
        public let from: Double
        public let to: Double

        public init(
            requestContext: AuthenticatedRequestContext,
            from: Double,
            to: Double
        ) {
            self.requestContext = requestContext
            self.from = from
            self.to = to
        }
    }
}
