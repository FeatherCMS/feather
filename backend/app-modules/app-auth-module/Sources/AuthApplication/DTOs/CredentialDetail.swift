import Application

import struct Foundation.Date

public struct CredentialDetail: DTO {
    public let id: String
    public let accountID: String
    public let email: String
    public let createdAt: Date
    public let updatedAt: Date

    package init(
        id: String,
        accountID: String,
        email: String,
        createdAt: Date,
        updatedAt: Date
    ) {
        self.id = id
        self.accountID = accountID
        self.email = email
        self.createdAt = createdAt
        self.updatedAt = updatedAt
    }
}
