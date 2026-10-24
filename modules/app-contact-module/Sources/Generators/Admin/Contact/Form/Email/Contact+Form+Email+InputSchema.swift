import FeatherOpenAPI

extension Contact.Form.Email {
    struct InputSchema: ObjectSchemaRepresentable {
        var openAPIIdentifier: String { "SubmissionMailInputSchema" }
        var propertyMap: SchemaMap {
            [
                "mailFrom": Contact.Schemas.Email(),
                "mailTo": Contact.Schemas.Email(),
                "subject": Contact.Schemas.Subject(),
                "additionalHeaders": AdditionalHeaders()
                    .reference(required: false),
                "messageBody": Contact.Schemas.Content(),
            ]
        }
    }
}
