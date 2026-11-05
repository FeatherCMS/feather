public import FeatherApplication
public import NewsletterDomain
public import NewsletterModule

extension Subscriber.Add {
    public struct Input: DTO {
        public let campaignKey: String
        public let email: String
        public let firstName: String
        public let lastName: String
        public let status: Subscriber.Model.Status

        public init(
            campaignKey: String,
            email: String,
            firstName: String = "",
            lastName: String = "",
            status: Subscriber.Model.Status = .subscribed
        ) {
            self.campaignKey = campaignKey
            self.email = email
            self.firstName = firstName
            self.lastName = lastName
            self.status = status
        }
    }
}
