import Application
import BlogDomain
import WebDomain
import SystemApplication

public struct WriteAuthorMetadata: Scope {
    public let author: any AuthorRepository
    public let metadata: any MetadataRepository
    public let variable: any VariableQueries

    public init(
        author: any AuthorRepository,
        metadata: any MetadataRepository,
        variable: any VariableQueries
    ) {
        self.author = author
        self.metadata = metadata
        self.variable = variable
    }
}
