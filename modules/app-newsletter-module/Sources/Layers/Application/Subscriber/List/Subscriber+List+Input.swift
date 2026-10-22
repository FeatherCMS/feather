import FeatherApplication
import NewsletterModule

extension Subscriber.List {
    public struct Input: DTO {
        enum CampaignIdentifier: Sendable {
            case id(String)
            case key(String)
        }

        let campaignIdentifier: CampaignIdentifier

        public init(campaignKey: String) {
            self.campaignIdentifier = .key(campaignKey)
        }

        public init(newsletterId: String) {
            self.campaignIdentifier = .id(newsletterId)
        }
    }
}
