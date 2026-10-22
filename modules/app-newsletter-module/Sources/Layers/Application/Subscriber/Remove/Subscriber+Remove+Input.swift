import FeatherApplication
import NewsletterModule

extension Subscriber.Remove {
    public struct Input: DTO {
        public let campaignKey: String
        public let emails: [String]

        public init(campaignKey: String, emails: [String]) {
            self.campaignKey = campaignKey
            self.emails = emails
        }
    }
}
