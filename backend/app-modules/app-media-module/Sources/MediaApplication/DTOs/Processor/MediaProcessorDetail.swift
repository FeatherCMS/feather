import Application
import struct Foundation.Date

public struct MediaProcessorDetail: DTO {
    public let id: String
    public let name: String
    public let matchExtensions: String
    public let commandTemplate: String
    public let isRequired: Bool
    public let isActive: Bool
    public let createdAt: Date
    public let updatedAt: Date

    public init(
        id: String,
        name: String,
        matchExtensions: String,
        commandTemplate: String,
        isRequired: Bool,
        isActive: Bool,
        createdAt: Date,
        updatedAt: Date
    ) {
        self.id = id
        self.name = name
        self.matchExtensions = matchExtensions
        self.commandTemplate = commandTemplate
        self.isRequired = isRequired
        self.isActive = isActive
        self.createdAt = createdAt
        self.updatedAt = updatedAt
    }
}
