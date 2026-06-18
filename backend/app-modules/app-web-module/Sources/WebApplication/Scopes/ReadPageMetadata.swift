import Application
import WebApplication
import WebDomain

public struct ReadPageMetadata: Scope {
    public let page: any PageQueries
    public let metadata: any MetadataQueries

    public init(
        page: any PageQueries,
        metadata: any MetadataQueries
    ) {
        self.page = page
        self.metadata = metadata
    }
}
