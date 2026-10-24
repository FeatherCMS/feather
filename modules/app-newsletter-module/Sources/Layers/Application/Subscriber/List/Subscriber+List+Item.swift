public import NewsletterDomain
public import NewsletterModule

public import struct Foundation.Date

extension Subscriber.List {
    public struct Item: Sendable {
        public let newsletterId: String
        public let email: String
        public let status: Subscriber.Model.Status
        public let subscriptionDate: Date
        public let unsubscriptionDate: Date?
        public let firstName: String
        public let lastName: String
        public let confirmedAt: Date?
        public let source: String?
        public let lastSentAt: Date?
        public let createdAt: Date
        public let updatedAt: Date

        public init(model: Subscriber.Model) {
            newsletterId = model.newsletterId
            email = model.email
            status = model.status
            subscriptionDate = model.subscriptionDate
            unsubscriptionDate = model.unsubscriptionDate
            firstName = model.firstName
            lastName = model.lastName
            confirmedAt = model.confirmedAt
            source = model.source
            lastSentAt = model.lastSentAt
            createdAt = model.createdAt
            updatedAt = model.updatedAt
        }
    }
}
