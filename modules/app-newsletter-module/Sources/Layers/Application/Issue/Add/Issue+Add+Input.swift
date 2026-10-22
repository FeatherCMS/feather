import FeatherApplication
import NewsletterModule

extension Issue.Add {
    public struct Input: DTO {
        public let campaignKey: String
        public let subject: String
        public let previewText: String
        public let content: String

        public init(
            campaignKey: String,
            subject: String,
            previewText: String = "",
            content: String
        ) {
            self.campaignKey = campaignKey
            self.subject = subject
            self.previewText = previewText
            self.content = content
        }
    }
}
