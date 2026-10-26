public import FeatherApplication
public import NewsletterModule

extension Subscriber.Unsubscribe {
    public struct Input: DTO {
        public let campaignKey: String
        public let token: String

        public init(campaignKey: String, token: String) {
            self.campaignKey = campaignKey
            self.token = token
        }
    }
}
