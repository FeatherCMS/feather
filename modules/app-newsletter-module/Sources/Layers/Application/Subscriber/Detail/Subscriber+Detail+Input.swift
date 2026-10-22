import FeatherApplication
import NewsletterModule

extension Subscriber.Detail {
    public struct Input: DTO {
        public let campaignKey: String
        public let email: String

        public init(campaignKey: String, email: String) {
            self.campaignKey = campaignKey
            self.email = email
        }
    }
}
