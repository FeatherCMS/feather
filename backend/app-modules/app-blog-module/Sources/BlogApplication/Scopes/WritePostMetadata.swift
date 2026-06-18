import Application
import BlogDomain
import WebDomain
import SystemApplication

public struct WritePostMetadata: Scope {
    public let post: any PostRepository
    public let metadata: any MetadataRepository
    public let variable: any VariableQueries

    public init(
        post: any PostRepository,
        metadata: any MetadataRepository,
        variable: any VariableQueries
    ) {
        self.post = post
        self.metadata = metadata
        self.variable = variable
    }
}
