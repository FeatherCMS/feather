import Application
import WebApplication

public struct PublicBlogTagSummary: DTO {
    public let id: String
    public let title: String
    public let excerpt: String
    public let imageAssetId: String?
    public let imageURL: String
    public let media: PublicContentMedia?
    public let metadata: MetadataDetail

    public init(
        id: String,
        title: String,
        excerpt: String,
        imageAssetId: String?,
        imageURL: String,
        media: PublicContentMedia?,
        metadata: MetadataDetail
    ) {
        self.id = id
        self.title = title
        self.excerpt = excerpt
        self.imageAssetId = imageAssetId
        self.imageURL = imageURL
        self.media = media
        self.metadata = metadata
    }
}
