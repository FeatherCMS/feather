import FeatherApplication
import NewsletterModule

extension Issue.Detail {
    public struct Input: DTO {
        public let campaignKey: String
        public let id: String

        public init(campaignKey: String, id: String) {
            self.campaignKey = campaignKey
            self.id = id
        }
    }
}
