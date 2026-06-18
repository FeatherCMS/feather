import Application
import struct Foundation.Date

public struct InvitationDetail: DTO {
    public let id: String
    public let email: String
    public let token: String
    public let expiresAt: Date
    public let createdAt: Date
    public let updatedAt: Date

    package init(
        id: String,
        email: String,
        token: String,
        expiresAt: Date,
        createdAt: Date,
        updatedAt: Date
    ) {
        self.id = id
        self.email = email
        self.token = token
        self.expiresAt = expiresAt
        self.createdAt = createdAt
        self.updatedAt = updatedAt
    }
}
