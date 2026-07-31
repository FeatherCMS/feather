import Application
import NewsletterDomain
import struct Foundation.Date

public struct NewsletterIssueDetail: DTO {
    public let id: String
    public let newsletterId: String
    public let subject: String
    public let previewText: String
    public let content: String
    public let status: NewsletterCampaignIssue.Status
    public let scheduledDate: Date?
    public let sentDate: Date?
    public let createdAt: Date
    public let updatedAt: Date

    package init(
        id: String,
        newsletterId: String,
        subject: String,
        previewText: String,
        content: String,
        status: NewsletterCampaignIssue.Status,
        scheduledDate: Date?,
        sentDate: Date?,
        createdAt: Date,
        updatedAt: Date
    ) {
        self.id = id
        self.newsletterId = newsletterId
        self.subject = subject
        self.previewText = previewText
        self.content = content
        self.status = status
        self.scheduledDate = scheduledDate
        self.sentDate = sentDate
        self.createdAt = createdAt
        self.updatedAt = updatedAt
    }
}
