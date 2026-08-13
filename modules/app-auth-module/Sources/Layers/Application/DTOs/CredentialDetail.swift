import FeatherApplication
import FeatherContracts

import struct Foundation.Date

public struct CredentialDetail: DTO {
    public let id: String
    public let userId: String
    public let email: String
    public let isPersistent: Bool
    public let createdAt: Date
    public let updatedAt: Date

    package init(
        id: String,
        userId: String,
        email: String,
        isPersistent: Bool,
        createdAt: Date,
        updatedAt: Date
    ) {
        self.id = id
        self.userId = userId
        self.email = email
        self.isPersistent = isPersistent
        self.createdAt = createdAt
        self.updatedAt = updatedAt
    }
}
