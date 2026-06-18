import WebDomain
import Application

public struct WriteMetadata: Scope {
    public let metadata: any MetadataRepository

    public init(metadata: any MetadataRepository) {
        self.metadata = metadata
    }
}
