import FeatherOpenAPI

extension Issue.Patch {
    struct Schema: ObjectSchemaRepresentable {
        var openAPIIdentifier: String { "NewsletterIssuePatchSchema" }
        var propertyMap: SchemaMap {
            [
                "subject": Issue.Schemas.Subject().reference(required: false),
                "content": Newsletter.Schemas.Content()
                    .reference(required: false),
                "scheduledAt": Newsletter.Schemas.NullableTimestamp()
                    .reference(required: false),
            ]
        }
    }
}
