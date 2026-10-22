public import FeatherModuleKit
public import WebDomain

extension Page.Edit {
    public struct Scope: FeatherModuleKit.Scope {
        public let page: any Page.Repository.Interface
        public let metadata: any Metadata.Repository.Interface

        public init(
            page: any Page.Repository.Interface,
            metadata: any Metadata.Repository.Interface
        ) {
            self.page = page
            self.metadata = metadata
        }
    }
}
