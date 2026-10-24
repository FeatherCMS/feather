public import FeatherApplication
public import NewsletterModule

extension Delivery.List {
    public struct Input: DTO {
        public let campaignKey: String
        public let issueId: String

        public init(campaignKey: String, issueId: String) {
            self.campaignKey = campaignKey
            self.issueId = issueId
        }
    }
}
