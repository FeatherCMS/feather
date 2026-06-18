import Application
import WebApplication

public struct PublicBlogAuthorSummary: DTO {
    public let id: String
    public let name: String
    public let excerpt: String
    public let content: String
    public let imageAssetId: String?
    public let imageURL: String
    public let media: PublicContentMedia?
    public let metadata: MetadataDetail

    public init(
        id: String,
        name: String,
        excerpt: String,
        content: String,
        imageAssetId: String?,
        imageURL: String,
        media: PublicContentMedia?,
        metadata: MetadataDetail
    ) {
        self.id = id
        self.name = name
        self.excerpt = excerpt
        self.content = content
        self.imageAssetId = imageAssetId
        self.imageURL = imageURL
        self.media = media
        self.metadata = metadata
    }
}
