import Application
import BlogDomain
import WebApplication

public struct ReadAuthorMetadata: Scope {
    public let author: any AuthorQueries
    public let metadata: any MetadataQueries

    public init(
        author: any AuthorQueries,
        metadata: any MetadataQueries
    ) {
        self.author = author
        self.metadata = metadata
    }
}
