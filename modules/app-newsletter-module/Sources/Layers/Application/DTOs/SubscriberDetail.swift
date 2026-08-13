import FeatherApplication
import FeatherContracts
import NewsletterDomain

import struct Foundation.Date

public struct SubscriberDetail: DTO {
    public let newsletterId: String
    public let email: String
    public let status: Subscriber.Status
    public let subscriptionDate: Date
    public let unsubscriptionDate: Date?
    public let firstName: String
    public let lastName: String
    public let confirmedAt: Date?
    public let source: String?
    public let lastSentAt: Date?
    public let createdAt: Date
    public let updatedAt: Date

    package init(
        newsletterId: String,
        email: String,
        status: Subscriber.Status,
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
