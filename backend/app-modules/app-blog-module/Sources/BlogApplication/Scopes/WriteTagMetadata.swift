import Application
import BlogDomain
import WebDomain
import SystemApplication

public struct WriteTagMetadata: Scope {
    public let tag: any TagRepository
    public let metadata: any MetadataRepository
    public let variable: any VariableQueries

    public init(
        tag: any TagRepository,
        metadata: any MetadataRepository,
        variable: any VariableQueries
    ) {
        self.tag = tag
        self.metadata = metadata
        self.variable = variable
    }
}
