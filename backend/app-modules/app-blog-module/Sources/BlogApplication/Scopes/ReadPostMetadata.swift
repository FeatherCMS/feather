import Application
import BlogDomain
import WebApplication

public struct ReadPostMetadata: Scope {
    public let post: any PostQueries
    public let metadata: any MetadataQueries

    public init(
        post: any PostQueries,
        metadata: any MetadataQueries
    ) {
        self.post = post
        self.metadata = metadata
    }
}
