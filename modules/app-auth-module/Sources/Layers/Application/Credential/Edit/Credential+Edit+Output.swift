public import AuthModule
public import FeatherApplication

public import struct Foundation.Date

extension Credential.Edit {
    public struct Output: DTO, Sendable {
        public let id: String
        public let userId: String
        public let email: String
        public let createdAt: Date
        public let updatedAt: Date

        public init(
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
}
