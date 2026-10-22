public import FeatherModuleKit
public import NewsModule
public import NewsDomain
public import WebDomain

public struct WriteCategoryArticlesMetadata: Scope {
    public let article: any Article.Repository.Interface
    public let category: any Category.Repository.Interface
    public let metadata: any Metadata.Repository.Interface

    public init(
        article: any Article.Repository.Interface,
        category: any Category.Repository.Interface,
        metadata: any Metadata.Repository.Interface
    ) {
        self.article = article
        self.category = category
        self.metadata = metadata
    }
}
