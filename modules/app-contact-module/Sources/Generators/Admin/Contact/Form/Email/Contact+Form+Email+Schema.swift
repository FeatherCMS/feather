import FeatherOpenAPI

extension Contact.Form.Email {
    struct Schema: ObjectSchemaRepresentable {
        var openAPIIdentifier: String { "SubmissionMailSchema" }
        var propertyMap: SchemaMap {
            [
                "id": Contact.Schemas.ID(),
                "mailFrom": Contact.Schemas.Email(),
                "mailTo": Contact.Schemas.Email(),
                "subject": Contact.Schemas.Subject(),
                "additionalHeaders": AdditionalHeaders(),
                "messageBody": Contact.Schemas.Content(),
                "createdAt": Contact.Schemas.Timestamp(),
                "updatedAt": Contact.Schemas.Timestamp(),
            ]
        }
    }
}
