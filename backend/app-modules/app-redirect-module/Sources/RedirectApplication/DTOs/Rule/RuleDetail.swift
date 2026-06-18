import struct Foundation.Date
import Application

public struct RuleDetail: DTO {
    public let id: String
    public let source: String
    public let destination: String
    public let statusCode: Int
    public let notes: String
    public let createdAt: Date
    public let updatedAt: Date

    package init(
        id: String,
        source: String,
        destination: String,
        statusCode: Int,
        notes: String,
        createdAt: Date,
        updatedAt: Date
    ) {
        self.id = id
        self.source = source
        self.destination = destination
        self.statusCode = statusCode
        self.notes = notes
        self.createdAt = createdAt
        self.updatedAt = updatedAt
    }
}
