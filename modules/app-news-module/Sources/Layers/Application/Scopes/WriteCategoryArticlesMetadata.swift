import FeatherApplication
import FeatherContracts
import NewsDomain
import WebDomain

public struct WriteCategoryArticlesMetadata: Scope {
    public let article: any ArticleRepository
    public let category: any CategoryRepository
    public let metadata: any MetadataRepository

    public init(
        article: any ArticleRepository,
        category: any CategoryRepository,
        metadata: any MetadataRepository
    ) {
        self.article = article
        self.category = category
        self.metadata = metadata
    }
}
