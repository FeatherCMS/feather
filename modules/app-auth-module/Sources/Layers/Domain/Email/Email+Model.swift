public import AuthModule
public import FeatherDomain

public import struct Foundation.Date

extension Email {

    public struct Model: FeatherDomain.Model {
        public let id: String
        public var identityId: String
        public var email: String
        public let createdAt: Date
        public var updatedAt: Date

        package init(
            id: String,
            identityId: String,
            email: String,
            createdAt: Date,
            updatedAt: Date
        ) {
            self.id = id
            self.identityId = identityId
            self.email = email
            self.createdAt = createdAt
            self.updatedAt = updatedAt
        }
    }

}

extension Email.Model {
    public mutating func update(
        identityId: FieldChange<String> = .unchanged,
        email: FieldChange<String> = .unchanged
    ) {
        self.identityId = identityId.apply(to: self.identityId)
        self.email = email.apply(to: self.email)
    }
}
