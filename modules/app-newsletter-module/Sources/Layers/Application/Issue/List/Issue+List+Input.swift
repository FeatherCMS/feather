public import FeatherApplication
public import NewsletterModule

extension Issue.List {
    public struct Input: DTO {
        public let campaignKey: String

        public init(campaignKey: String) {
            self.campaignKey = campaignKey
        }
    }
}
