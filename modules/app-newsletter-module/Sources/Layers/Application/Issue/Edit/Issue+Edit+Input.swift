public import FeatherApplication
public import NewsletterModule

public import struct Foundation.Date

extension Issue.Edit {
    public struct Input: DTO {
        public let campaignKey: String
        public let id: String
        public let subject: String
        public let content: String
        public let scheduledDate: Date?

        public init(
            campaignKey: String,
            id: String,
            subject: String,
            content: String,
            scheduledDate: Date?
        ) {
            self.campaignKey = campaignKey
            self.id = id
            self.subject = subject
            self.content = content
            self.scheduledDate = scheduledDate
        }
    }
}
