import FeatherOpenAPI

extension Issue.List {
    struct ItemSchema: ObjectSchemaRepresentable {
        var openAPIIdentifier: String { "NewsletterIssueListItemSchema" }
        var propertyMap: SchemaMap {
            [
                "id": Newsletter.Schemas.ID(),
                "campaignKey": Newsletter.Schemas.Key(),
                "subject": Issue.Schemas.Subject(),
                "content": Newsletter.Schemas.Content(),
                "status": Issue.Schemas.Status(),
                "scheduledAt": Newsletter.Schemas.Timestamp()
                    .reference(required: false),
                "sentAt": Newsletter.Schemas.Timestamp()
                    .reference(required: false),
                "createdAt": Newsletter.Schemas.Timestamp(),
                "updatedAt": Newsletter.Schemas.Timestamp(),
            ]
        }
    }

    struct Schema: ArraySchemaRepresentable {
        var openAPIIdentifier: String { "NewsletterIssueListSchema" }
        var items: (any SchemaRepresentable)? { ItemSchema().reference() }
    }
}
