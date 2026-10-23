public import FeatherApplication
public import NewsletterModule

extension Subscriber.Subscribe {
    public struct Input: DTO {
        public let campaignKey: String
        public let email: String
        public let firstName: String
        public let lastName: String
        public let unsubscribeToken: String?
        public let source: String?

        public init(
            campaignKey: String,
            email: String,
            firstName: String = "",
            lastName: String = "",
            unsubscribeToken: String? = nil,
            source: String? = nil
        ) {
            self.campaignKey = campaignKey
            self.email = email
            self.firstName = firstName
            self.lastName = lastName
            self.unsubscribeToken = unsubscribeToken
            self.source = source
        }
    }
}
