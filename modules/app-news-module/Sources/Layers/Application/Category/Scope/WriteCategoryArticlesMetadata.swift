public import FeatherModuleKit
public import NewsDomain
public import WebDomain

public struct WriteCategoryArticlesMetadata: Scope {
    public let article: any ArticleRepository
    public let category: any CategoryRepository
    public let metadata: any Metadata.Repository.Interface

    public init(
        article: any ArticleRepository,
        category: any CategoryRepository,
        metadata: any Metadata.Repository.Interface
    ) {
        self.article = article
        self.category = category
        self.metadata = metadata
    }
}
