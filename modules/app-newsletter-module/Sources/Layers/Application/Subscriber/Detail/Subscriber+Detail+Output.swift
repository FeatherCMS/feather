public import FeatherApplication
public import NewsletterDomain
public import NewsletterModule

public import struct Foundation.Date

extension Subscriber.Detail {
    public struct Output: DTO {
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

        public init(
            newsletterId: String,
            email: String,
            status: Subscriber.Model.Status,
            subscriptionDate: Date,
            unsubscriptionDate: Date?,
            firstName: String,
            lastName: String,
            confirmedAt: Date?,
            source: String?,
            lastSentAt: Date?,
            createdAt: Date,
            updatedAt: Date
        ) {
            self.newsletterId = newsletterId
            self.email = email
            self.status = status
            self.subscriptionDate = subscriptionDate
            self.unsubscriptionDate = unsubscriptionDate
            self.firstName = firstName
            self.lastName = lastName
            self.confirmedAt = confirmedAt
            self.source = source
            self.lastSentAt = lastSentAt
            self.createdAt = createdAt
            self.updatedAt = updatedAt
        }
    }
}

extension Subscriber.Model {
    var asDetail: Subscriber.Detail.Output {
        .init(
            newsletterId: newsletterId,
            email: email,
            status: status,
            subscriptionDate: subscriptionDate,
            unsubscriptionDate: unsubscriptionDate,
            firstName: firstName,
            lastName: lastName,
            confirmedAt: confirmedAt,
            source: source,
            lastSentAt: lastSentAt,
            createdAt: createdAt,
            updatedAt: updatedAt
        )
    }
}
