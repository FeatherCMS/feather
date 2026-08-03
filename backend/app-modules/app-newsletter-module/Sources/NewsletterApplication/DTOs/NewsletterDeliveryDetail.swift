import Application
import NewsletterDomain
import struct Foundation.Date

public struct NewsletterDeliveryDetail: DTO {
    public let issueId: String
    public let newsletterId: String
    public let subscriberEmail: String
    public let status: NewsletterCampaignDelivery.Status
    public let sentDate: Date?
    public let failureReason: String?
    public let createdAt: Date
    public let updatedAt: Date

    package init(_ value: NewsletterCampaignDelivery) {
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
