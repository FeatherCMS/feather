public import FeatherModuleKit

extension Public.Content.Event {
    public struct Context<T: Sendable>: ExecutionContext {
        public let baseMetadata: FeatherModuleKit.PublicContent.Metadata.Base
        public let runtime: T
        public let siteSettings: Public.SiteSettings?

        public init(
            baseMetadata: FeatherModuleKit.PublicContent.Metadata.Base,
            runtime: T,
            siteSettings: Public.SiteSettings? = nil
        ) {
            self.baseMetadata = baseMetadata
            self.runtime = runtime
            self.siteSettings = siteSettings
        }
    }
}
