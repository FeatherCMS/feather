public import BlogModule
public import FeatherModuleKit
public import WebApplication
public import WebDomain

extension Tag.Detail {
    public struct Scope: FeatherModuleKit.Scope {
        public let tag: any Tag.Query.Interface
        public let metadata: any Metadata.Query.Interface

        public init(
            tag: any Tag.Query.Interface,
            metadata: any Metadata.Query.Interface
        ) {
            self.tag = tag
            self.metadata = metadata
        }
    }
}
