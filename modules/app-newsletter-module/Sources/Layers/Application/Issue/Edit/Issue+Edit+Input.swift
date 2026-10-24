public import FeatherApplication
public import FeatherDomain
public import NewsletterModule

public import struct Foundation.Date

extension Issue.Edit {
    public struct Input: DTO {
        public let campaignKey: String
        public let id: String
        public let subject: FieldChange<String>
        public let content: FieldChange<String>
        public let scheduledDate: OptionalFieldChange<Date>

        public init(
            campaignKey: String,
            id: String,
            subject: FieldChange<String>,
            content: FieldChange<String>,
            scheduledDate: OptionalFieldChange<Date>
        ) {
            self.campaignKey = campaignKey
            self.id = id
            self.subject = subject
            self.content = content
            self.scheduledDate = scheduledDate
        }
    }
}
