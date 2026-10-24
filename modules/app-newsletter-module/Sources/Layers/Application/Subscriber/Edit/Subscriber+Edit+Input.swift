public import FeatherApplication
public import FeatherDomain
public import NewsletterDomain
public import NewsletterModule

extension Subscriber.Edit {
    public struct Input: DTO {
        public let campaignKey: String
        public let email: String
        public let firstName: FieldChange<String>
        public let lastName: FieldChange<String>
        public let status: FieldChange<Subscriber.Model.Status>

        public init(
            campaignKey: String,
            email: String,
            firstName: FieldChange<String>,
            lastName: FieldChange<String>,
            status: FieldChange<Subscriber.Model.Status>
        ) {
            self.campaignKey = campaignKey
            self.email = email
            self.firstName = firstName
            self.lastName = lastName
            self.status = status
        }
    }
}
