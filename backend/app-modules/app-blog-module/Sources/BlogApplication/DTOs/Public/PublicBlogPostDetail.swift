import Application
import WebApplication

public struct PublicBlogPostDetail: DTO {
    public let id: String
    public let title: String
    public let excerpt: String
    public let content: String
    public let imageAssetId: String?
    public let imageURL: String
    public let media: PublicContentMedia?
    public let metadata: MetadataDetail
    public let authors: [PublicBlogAuthorSummary]
    public let tags: [PublicBlogTagSummary]

    public init(
        id: String,
        title: String,
        excerpt: String,
        content: String,
        imageAssetId: String?,
        imageURL: String,
        media: PublicContentMedia?,
        metadata: MetadataDetail,
        authors: [PublicBlogAuthorSummary],
        tags: [PublicBlogTagSummary]
    ) {
        self.id = id
        self.title = title
        self.excerpt = excerpt
        self.content = content
        self.imageAssetId = imageAssetId
        self.imageURL = imageURL
        self.media = media
        self.metadata = metadata
        self.authors = authors
        self.tags = tags
    }
}
