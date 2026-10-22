import FeatherApplication
import NewsletterModule

extension Issue.Remove {
    public struct Input: DTO {
        public let campaignKey: String
        public let ids: [String]

        public init(campaignKey: String, ids: [String]) {
            self.campaignKey = campaignKey
            self.ids = ids
        }
    }
}
