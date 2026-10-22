import FeatherApplication
import NewsletterModule

public import struct Foundation.Date

extension Issue.Send {
    public struct Input: DTO {
        public let issueId: String
        public let newsletterId: String
        public let subject: String
        public let content: String
        public let scheduledDate: Date?

        public init(
            issueId: String,
            newsletterId: String,
            subject: String,
            content: String,
            scheduledDate: Date?
        ) {
            self.issueId = issueId
            self.newsletterId = newsletterId
            self.subject = subject
            self.content = content
            self.scheduledDate = scheduledDate
        }
    }
}
