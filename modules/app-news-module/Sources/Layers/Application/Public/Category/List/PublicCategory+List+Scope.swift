public import FeatherModuleKit
public import NewsModule
public import WebApplication
public import WebModule

extension PublicNewsCategory.List {
    public struct Scope: FeatherModuleKit.Scope {
        public let category: any Category.List.Query.Interface
        public let metadata: any WebModule.Metadata.Resolve.Query.Interface
        public let metadataDetails:
            any WebModule.Metadata.Resolve.Detail.Query.Interface

        public init(
            category: any Category.List.Query.Interface,
            metadata: any WebModule.Metadata.Resolve.Query.Interface,
            metadataDetails: any WebModule.Metadata.Resolve.Detail.Query.Interface
        ) {
            self.category = category
            self.metadata = metadata
            self.metadataDetails = metadataDetails
        }
    }
}
