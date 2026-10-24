public import NewsletterDomain
public import NewsletterModule

extension Subscriber.Search {
    public struct Output: Sendable {
        public struct Membership: Sendable {
            public let campaignKey: String
            public let campaignName: String
            public let status: Subscriber.Model.Status

            package init(
                campaignKey: String,
                campaignName: String,
                status: Subscriber.Model.Status
            ) {
                self.campaignKey = campaignKey
                self.campaignName = campaignName
                self.status = status
            }
        }

        public struct Item: Sendable {
            public let email: String
            public let name: String
            public let memberships: [Membership]

            package init(
                email: String,
                name: String,
                memberships: [Membership]
            ) {
                self.email = email
                self.name = name
                self.memberships = memberships
            }
        }

        public let items: [Item]
        public let total: Int

        package init(items: [Item], total: Int) {
            self.items = items
            self.total = total
        }
    }
}
