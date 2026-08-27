import FeatherApplication
import FeatherContracts

import struct Foundation.Date

public struct CredentialDetail: DTO {
    public let id: String
    public let userId: String
    public let email: String
    public let createdAt: Date
    public let updatedAt: Date

    package init(
        id: String,
        userId: String,
        email: String,
        createdAt: Date,
        updatedAt: Date
    ) {
        self.id = id
        self.userId = userId
        self.email = email
        self.createdAt = createdAt
        self.updatedAt = updatedAt
    }
}
