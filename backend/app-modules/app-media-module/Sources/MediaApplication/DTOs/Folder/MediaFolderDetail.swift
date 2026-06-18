import Application
import struct Foundation.Date

public struct MediaFolderDetail: DTO {
    public let id: String
    public let parentId: String?
    public let name: String
    public let path: String
    public let assetCount: Int
    public let totalSizeBytes: Int64
    public let createdAt: Date
    public let updatedAt: Date

    public init(
        id: String,
        parentId: String?,
        name: String,
        path: String,
        assetCount: Int,
        totalSizeBytes: Int64,
        createdAt: Date,
        updatedAt: Date
    ) {
        self.id = id
        self.parentId = parentId
        self.name = name
        self.path = path
        self.assetCount = assetCount
        self.totalSizeBytes = totalSizeBytes
        self.createdAt = createdAt
        self.updatedAt = updatedAt
    }
}
