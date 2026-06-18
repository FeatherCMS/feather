import struct Foundation.Date
import Application

public struct AuthorLinkDetail: DTO {
    public let id: String
    public let authorId: String
    public let label: String
    public let url: String
    public let priority: Int
    public let isBlank: Bool
    public let permission: String
    public let notes: String
    public let createdAt: Date
    public let updatedAt: Date

    package init(
        id: String,
        authorId: String,
        label: String,
        url: String,
        priority: Int,
        isBlank: Bool,
        permission: String,
        notes: String,
        createdAt: Date,
        updatedAt: Date
    ) {
        self.id = id
        self.authorId = authorId
        self.label = label
        self.url = url
        self.priority = priority
        self.isBlank = isBlank
        self.permission = permission
        self.notes = notes
        self.createdAt = createdAt
        self.updatedAt = updatedAt
    }
}
