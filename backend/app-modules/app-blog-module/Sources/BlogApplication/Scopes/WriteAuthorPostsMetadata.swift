import Application
import BlogDomain
import WebDomain

public struct WriteAuthorPostsMetadata: Scope {
    public let post: any PostRepository
    public let author: any AuthorRepository
    public let metadata: any MetadataRepository

    public init(
        post: any PostRepository,
        author: any AuthorRepository,
        metadata: any MetadataRepository
    ) {
        self.post = post
        self.author = author
        self.metadata = metadata
    }
}
