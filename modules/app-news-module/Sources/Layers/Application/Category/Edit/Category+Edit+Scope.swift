public import FeatherModuleKit
public import NewsDomain
public import NewsModule
public import WebDomain
public import WebModule

extension Category.Edit {
    public struct Scope: FeatherModuleKit.Scope {
        public let category: any Category.Repository.Interface
        public let metadata: any WebModule.Metadata.Repository.Interface

        public init(
            category: any Category.Repository.Interface,
            metadata: any WebModule.Metadata.Repository.Interface
        ) {
            self.category = category
            self.metadata = metadata
        }
    }
}
