import FeatherOpenAPI

extension Subscriber.Query {
    enum Schemas {}
}

extension Subscriber.Query.Schemas {
    struct Membership: ObjectSchemaRepresentable {
        var openAPIIdentifier: String {
            "NewsletterSubscriberQueryMembershipSchema"
        }

        var propertyMap: SchemaMap {
            [
                "campaignKey": Newsletter.Schemas.Key().reference(),
                "campaignName": Newsletter.Schemas.Name().reference(),
                "status": Subscriber.Schemas.Status().reference(),
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
                "email": Newsletter.Schemas.Email().reference(),
                "name": Newsletter.Schemas.Name().reference(),
                "memberships": MembershipList().reference(),
            ]
        }
    }
}
