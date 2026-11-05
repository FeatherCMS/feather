import FeatherOpenAPI

extension Issue.TestEmail {
    struct Schema: ObjectSchemaRepresentable {
        var openAPIIdentifier: String { "NewsletterIssueTestEmailSchema" }
        var propertyMap: SchemaMap {
            [
                "email": Newsletter.Schemas.Email(),
                "subject": Issue.Schemas.Subject(),
                "content": Newsletter.Schemas.Content(),
            ]
        }
    }
}
