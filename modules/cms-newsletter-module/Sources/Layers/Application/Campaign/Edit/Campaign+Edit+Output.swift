public import FeatherApplication
public import NewsletterModule

public import struct Foundation.Date

extension Campaign.Edit {
    public struct Output: DTO {
        public let id: String
        public let key: String
        public let name: String
        public let fromEmail: String
        public let createdAt: Date
        public let updatedAt: Date

        public init(
            id: String,
            key: String,
            name: String,
            fromEmail: String,
            createdAt: Date,
            updatedAt: Date
        ) {
            self.id = id
            self.key = key
            self.name = name
            self.fromEmail = fromEmail
            self.createdAt = createdAt
            self.updatedAt = updatedAt
        }
    }
}
