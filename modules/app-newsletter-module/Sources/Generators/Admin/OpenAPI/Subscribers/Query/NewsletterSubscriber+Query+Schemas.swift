import FeatherOpenAPI

extension NewsletterSubscriber.Query {
    enum Schemas {}
}

extension NewsletterSubscriber.Query.Schemas {
    struct Membership: ObjectSchemaRepresentable {
        var openAPIIdentifier: String {
            "NewsletterSubscriberQueryMembershipSchema"
        }

        var propertyMap: SchemaMap {
            [
                "campaignKey": NewsletterKeyField().reference(),
                "campaignName": NewsletterNameField().reference(),
                "status": NewsletterSubscriberStatusField().reference(),
            ]
        }
    }

    struct MembershipList: ArraySchemaRepresentable {
        var openAPIIdentifier: String {
            "NewsletterSubscriberQueryMembershipListSchema"
        }

        var items: (any SchemaRepresentable)? {
            Membership().reference()
        }
    }

    struct Item: ObjectSchemaRepresentable {
        var openAPIIdentifier: String {
            "NewsletterSubscriberQueryItemSchema"
        }

        var propertyMap: SchemaMap {
            [
                "email": NewsletterEmailField().reference(),
                "name": NewsletterNameField().reference(),
                "memberships": MembershipList().reference(),
            ]
        }
    }
}
