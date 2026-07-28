import Domain
import struct Foundation.Date

public struct NewsletterCampaignDelivery: Model {

    public enum Status: String, Sendable, CaseIterable {
        case pending
        case sent
        case failed
        case bounced
    }

    public struct New: Sendable {
        public let issueId: String
        public let newsletterId: String
        public let subscriberEmail: String
        public let status: Status
        public let sentDate: Date?
        public let failureReason: String?

        public init(
            issueId: String,
            newsletterId: String,
            subscriberEmail: String,
            status: Status,
            sentDate: Date?,
            failureReason: String?
        ) {
            self.issueId = issueId
            self.newsletterId = newsletterId
            self.subscriberEmail = subscriberEmail
            self.status = status
            self.sentDate = sentDate
            self.failureReason = failureReason
        }
    }

    public let issueId: String
    public let newsletterId: String
    public let subscriberEmail: String
    public var status: Status
    public var sentDate: Date?
    public var failureReason: String?
    public let createdAt: Date
    public let updatedAt: Date

    package init(
        issueId: String,
        newsletterId: String,
        subscriberEmail: String,
        status: Status,
        sentDate: Date?,
        failureReason: String?,
        createdAt: Date,
        updatedAt: Date
    ) {
        self.issueId = issueId
        self.newsletterId = newsletterId
        self.subscriberEmail = subscriberEmail
        self.status = status
        self.sentDate = sentDate
        self.failureReason = failureReason
        self.createdAt = createdAt
        self.updatedAt = updatedAt
    }
}
