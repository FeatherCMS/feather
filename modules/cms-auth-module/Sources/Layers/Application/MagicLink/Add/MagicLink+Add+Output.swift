public import AuthModule
public import FeatherApplication

public import struct Foundation.Date

extension MagicLink.Add {
    public struct Output: DTO, Sendable {
        public let id: String
        public let authEmailId: String
        public let token: String
        public let expiresAt: Date
        public let isPersistent: Bool
        public let isUsed: Bool
        public let createdAt: Date
        public let updatedAt: Date

        package init(
            id: String,
            authEmailId: String,
            token: String,
            expiresAt: Date,
            isPersistent: Bool,
            isUsed: Bool,
            createdAt: Date,
            updatedAt: Date
        ) {
            self.id = id
            self.authEmailId = authEmailId
            self.token = token
            self.expiresAt = expiresAt
            self.isPersistent = isPersistent
            self.isUsed = isUsed
            self.createdAt = createdAt
            self.updatedAt = updatedAt
        }
    }
}
