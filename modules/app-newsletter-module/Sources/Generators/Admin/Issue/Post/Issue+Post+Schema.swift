import FeatherOpenAPI

extension Issue.Post {
    struct Schema: ObjectSchemaRepresentable {
        var openAPIIdentifier: String { "NewsletterIssueCreateSchema" }
        var propertyMap: SchemaMap {
            [
                "subject": Issue.Schemas.Subject(),
                "content": Newsletter.Schemas.Content(),
                "scheduledAt": Newsletter.Schemas.Timestamp().reference(required: false),
            ]
        }
    }
}
