public import FeatherModuleKit
import NewsModule
public import WebApplication
public import WebModule

extension Public.Category.List {
    public struct Scope: FeatherModuleKit.Scope {
        public let category: any Query.Interface
        public let metadataDetails:
            any WebModule.Metadata.Resolve.Detail.Query.Interface

        public init(
            category: any Query.Interface,
            metadataDetails: any WebModule.Metadata.Resolve.Detail.Query.Interface
        ) {
            self.category = category
            self.metadataDetails = metadataDetails
        }
    }
}
