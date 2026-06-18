import WebDomain
import Application

public struct ReadMetadata: Scope {
    public let metadata: any MetadataQueries

    public init(metadata: any MetadataQueries) {
        self.metadata = metadata
    }
}
