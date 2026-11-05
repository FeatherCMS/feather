import FeatherOpenAPI

extension Campaign.Query {
    enum Schemas {}
}

extension Campaign.Query.Schemas {
    struct SubscriberCount: IntSchemaRepresentable {
        var openAPIIdentifier: String {
            "NewsletterCampaignSubscriberCount"
        }
        var example: Int? { 42 }
    }

    struct SentIssueCount: IntSchemaRepresentable {
        var openAPIIdentifier: String {
            "NewsletterCampaignSentIssueCount"
        }
        var example: Int? { 3 }
    }

    struct Item: ObjectSchemaRepresentable {
        var openAPIIdentifier: String { "NewsletterCampaignQueryItemSchema" }

        var propertyMap: SchemaMap {
            [
                "id": Newsletter.Schemas.ID().reference(),
                "key": Newsletter.Schemas.Key().reference(),
                "name": Newsletter.Schemas.Name().reference(),
                "fromEmail": Newsletter.Schemas.Email().reference(),
                "subscriberCount": SubscriberCount().reference(),
                "sentIssueCount": SentIssueCount().reference(),
            ]
        }
    }
}
