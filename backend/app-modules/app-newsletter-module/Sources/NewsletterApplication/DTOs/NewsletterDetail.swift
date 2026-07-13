import Application
import struct Foundation.Date

public struct NewsletterDetail: DTO {
    public let id: String
    public let name: String
    public let createdAt: Date
    public let updatedAt: Date

    package init(
        id: String,
        name: String,
        createdAt: Date,
        updatedAt: Date
    ) {
        self.id = id
        self.name = name
        self.createdAt = createdAt
        self.updatedAt = updatedAt
    }
}
