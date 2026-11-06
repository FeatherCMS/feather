public import FeatherApplication
public import NewsletterDomain
public import NewsletterModule

public import struct Foundation.Date

extension Delivery.List {
    public struct Item: DTO {
        public let issueId: String
        public let newsletterId: String
        public let subscriberEmail: String
        public let status: Delivery.Model.Status
        public let sentDate: Date?
        public let failureReason: String?
        public let createdAt: Date
        public let updatedAt: Date

        public init(model: Delivery.Model) {
            issueId = model.issueId
            newsletterId = model.newsletterId
            subscriberEmail = model.subscriberEmail
            status = model.status
            sentDate = model.sentDate
            failureReason = model.failureReason
            createdAt = model.createdAt
            updatedAt = model.updatedAt
        }
    }
}
