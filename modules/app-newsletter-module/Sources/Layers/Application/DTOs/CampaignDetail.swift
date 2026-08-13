import FeatherApplication
import FeatherContracts

import struct Foundation.Date

public struct CampaignDetail: DTO {
    public let id: String
    public let name: String
    public let fromEmail: String
    public let createdAt: Date
    public let updatedAt: Date

    package init(
        id: String,
        name: String,
        fromEmail: String,
        createdAt: Date,
        updatedAt: Date
    ) {
        self.id = id
        self.name = name
        self.fromEmail = fromEmail
        self.createdAt = createdAt
        self.updatedAt = updatedAt
    }
}
