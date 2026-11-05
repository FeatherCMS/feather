public import FeatherModuleKit

extension Public.Content.Event {
    public struct Context<T: Sendable>: ExecutionContext {
        public let baseMetadata: FeatherModuleKit.PublicContent.Metadata.Base
        public let runtime: T

        public init(
            baseMetadata: FeatherModuleKit.PublicContent.Metadata.Base,
            runtime: T
        ) {
            self.baseMetadata = baseMetadata
            self.runtime = runtime
        }
    }
}
