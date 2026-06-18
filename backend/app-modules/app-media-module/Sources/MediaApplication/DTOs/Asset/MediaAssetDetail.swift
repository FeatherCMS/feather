import Application
import struct Foundation.Date

public struct MediaAssetDetail: DTO {
    public let id: String
    public let folderId: String?
    public let storageKey: String
    public let baseName: String
    public let type: String
    public let sizeBytes: Int64
    public let status: String
    public let title: String?
    public let altText: String?
    public let createdAt: Date
    public let updatedAt: Date
    public let deletedAt: Date?

    public init(
        id: String,
        folderId: String?,
        storageKey: String,
        baseName: String,
        type: String,
        sizeBytes: Int64,
        status: String,
        title: String?,
        altText: String?,
        createdAt: Date,
        updatedAt: Date,
        deletedAt: Date?
    ) {
        self.id = id
        self.folderId = folderId
        self.storageKey = storageKey
        self.baseName = baseName
        self.type = type
        self.sizeBytes = sizeBytes
        self.status = status
        self.title = title
        self.altText = altText
        self.createdAt = createdAt
        self.updatedAt = updatedAt
        self.deletedAt = deletedAt
    }
}
