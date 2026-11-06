import FeatherOpenAPI

extension Issue.Query {
    enum Schemas {}
}

extension Issue.Query.Schemas {
    struct Item: ObjectSchemaRepresentable {
        var openAPIIdentifier: String { "NewsletterIssueQueryItemSchema" }

        var propertyMap: SchemaMap {
            [
                "id": Newsletter.Schemas.ID().reference(),
                "subject": Issue.Schemas.Subject().reference(),
                "status": Issue.Schemas.Status().reference(),
                "scheduledAt": Newsletter.Schemas.Timestamp()
                    .reference(required: false),
                "createdAt": Newsletter.Schemas.Timestamp().reference(),
            ]
        }
    }
}
