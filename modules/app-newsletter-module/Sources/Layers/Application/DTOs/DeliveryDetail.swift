import FeatherApplication
import FeatherContracts
import NewsletterDomain

import struct Foundation.Date

public struct DeliveryDetail: DTO {
    public let issueId: String
    public let newsletterId: String
    public let subscriberEmail: String
    public let status: Delivery.Status
    public let sentDate: Date?
    public let failureReason: String?
    public let createdAt: Date
    public let updatedAt: Date

    package init(_ value: Delivery) {
        issueId = value.issueId
        newsletterId = value.newsletterId
        subscriberEmail = value.subscriberEmail
        status = value.status
        sentDate = value.sentDate
        failureReason = value.failureReason
        createdAt = value.createdAt
        updatedAt = value.updatedAt
    }
}
