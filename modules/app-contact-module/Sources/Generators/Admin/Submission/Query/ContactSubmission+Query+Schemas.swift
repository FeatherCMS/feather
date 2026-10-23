import FeatherOpenAPI

extension ContactSubmission.Query {
    enum Schemas {}
}

extension ContactSubmission.Query.Schemas {
    struct Item: ObjectSchemaRepresentable {
        var openAPIIdentifier: String { "ContactSubmissionQueryItemSchema" }
        var propertyMap: SchemaMap {
            [
                "id": ContactIdField(),
                "formKey": ContactFormKeyField(),
                "formName": ContactNameField(),
                "status": ContactStatusField(),
                "createdAt": ContactTimestampField(),
                "email": ContactEmailField().reference(required: false),
            ]
        }
    }
}
