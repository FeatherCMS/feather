public import FeatherModuleKit
public import WebDomain
public import WebModule

extension Page.Remove {
    public struct Scope: FeatherModuleKit.Scope {
        public let page: any Page.Repository.Interface
        public let metadata: any Metadata.Repository.Interface
        public let settings: any Settings.Repository.Interface

        public init(
            page: any Page.Repository.Interface,
            metadata: any Metadata.Repository.Interface,
            settings: any Settings.Repository.Interface
        ) {
            self.page = page
            self.metadata = metadata
            self.settings = settings
        }
    }
}
