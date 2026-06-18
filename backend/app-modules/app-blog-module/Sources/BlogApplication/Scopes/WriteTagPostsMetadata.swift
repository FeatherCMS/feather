import Application
import BlogDomain
import WebDomain

public struct WriteTagPostsMetadata: Scope {
    public let post: any PostRepository
    public let tag: any TagRepository
    public let metadata: any MetadataRepository

    public init(
        post: any PostRepository,
        tag: any TagRepository,
        metadata: any MetadataRepository
    ) {
        self.post = post
        self.tag = tag
        self.metadata = metadata
    }
}
