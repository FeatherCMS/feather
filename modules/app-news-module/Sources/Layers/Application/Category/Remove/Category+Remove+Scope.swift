public import FeatherModuleKit
public import NewsDomain
public import NewsModule
public import WebDomain
public import WebModule

extension Category.Remove {
    public struct Scope: FeatherModuleKit.Scope {
        public let article: any Article.Repository.Interface
        public let category: any Category.Repository.Interface
        public let metadata: any WebModule.Metadata.Repository.Interface

        public init(
            article: any Article.Repository.Interface,
            category: any Category.Repository.Interface,
            metadata: any WebModule.Metadata.Repository.Interface
        ) {
            self.article = article
            self.category = category
            self.metadata = metadata
        }
    }
}
