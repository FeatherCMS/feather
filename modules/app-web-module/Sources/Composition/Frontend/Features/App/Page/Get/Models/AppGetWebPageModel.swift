import FeatherAdmin
import OpenAPIRuntime

public struct AppGetWebPageModel: Sendable {
    public let title: String
    public let excerpt: String
    public let imageURL: String?
    public let content: String
    public let metadata: AppPublicMetadataModel

    public init(
        title: String,
        excerpt: String,
        imageURL: String?,
        content: String,
        metadata: AppPublicMetadataModel
    ) {
        self.title = title
        self.excerpt = excerpt
        self.imageURL = imageURL
        self.content = content
        self.metadata = metadata
    }
}
