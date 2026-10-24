import FeatherOpenAPI

extension NewsletterIssue.Query {
    enum Schemas {}
}

extension NewsletterIssue.Query.Schemas {
    struct Item: ObjectSchemaRepresentable {
        var openAPIIdentifier: String { "NewsletterIssueQueryItemSchema" }

        var propertyMap: SchemaMap {
            [
                "id": NewsletterIdField().reference(),
                "subject": NewsletterSubjectField().reference(),
                "status": NewsletterIssueStatusField().reference(),
                "scheduledAt": NewsletterTimestampField()
                    .reference(required: false),
                "createdAt": NewsletterTimestampField().reference(),
            ]
        }
    }
}
