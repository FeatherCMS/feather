public import FeatherApplication
public import NewsletterDomain
public import NewsletterModule

public import struct Foundation.Date

extension Campaign.List {
    public struct Output: DTO {
        public let id: String
        public let key: String
        public let name: String
        public let fromEmail: String
        public let createdAt: Date
        public let updatedAt: Date

        public init(model: Campaign.Model) {
            id = model.id
            key = model.key
            name = model.name
            fromEmail = model.fromEmail
            createdAt = model.createdAt
            updatedAt = model.updatedAt
        }
    }
}
