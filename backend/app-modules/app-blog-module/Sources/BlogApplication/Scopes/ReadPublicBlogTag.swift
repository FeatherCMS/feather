import Application
import BlogDomain
import WebApplication

public struct ReadPublicBlogTag: Scope {
    public let tag: any TagQueries
    public let post: any PostQueries
    public let metadata: any MetadataQueries

    public init(
        tag: any TagQueries,
        post: any PostQueries,
        metadata: any MetadataQueries
    ) {
        self.tag = tag
        self.post = post
        self.metadata = metadata
    }
}
