import FeatherOpenAPI

extension Contact.Form.Submission {
    struct ResponseSchema: ObjectSchemaRepresentable {
        var openAPIIdentifier: String {
            "AppContactFormSubmissionResponseSchema"
        }
        var propertyMap: SchemaMap {
            [
                "redirectUrl": Contact.Schemas.Content()
                    .reference(required: false)
            ]
        }
    }
}
