public import FeatherApplication

public import struct Foundation.Date

public struct MediaAssetDetail: DTO {
    public let id: String
    public let folderId: String?
    public let name: String
    public let slug: String
    public let slugPath: String
    public let url: String
    public let `extension`: String
    public let contentType: String
    public let sizeBytes: Int64
    public let status: String
    public let title: String?
    public let altText: String?
    public let createdAt: Date
    public let updatedAt: Date

    public init(
        id: String,
        folderId: String?,
        name: String,
        slug: String,
        slugPath: String,
        url: String,
        `extension`: String,
        contentType: String,
        sizeBytes: Int64,
        status: String,
        title: String?,
        altText: String?,
        createdAt: Date,
        updatedAt: Date
    ) {
        self.id = id
        self.folderId = folderId
        self.name = name
        self.slug = slug
        self.slugPath = slugPath
        self.url = url
        self.extension = `extension`
        self.contentType = contentType
        self.sizeBytes = sizeBytes
        self.status = status
        self.title = title
        self.altText = altText
        self.createdAt = createdAt
        self.updatedAt = updatedAt
    }
}
