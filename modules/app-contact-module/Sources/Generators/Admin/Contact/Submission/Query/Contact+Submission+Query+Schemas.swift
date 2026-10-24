import FeatherOpenAPI

extension Contact.Submission.Query {
    enum Schemas {}
}

extension Contact.Submission.Query.Schemas {
    struct Item: ObjectSchemaRepresentable {
        var openAPIIdentifier: String { "ContactSubmissionQueryItemSchema" }
        var propertyMap: SchemaMap {
            [
                "id": Contact.Schemas.ID(),
                "formKey": Contact.Schemas.FormKey(),
                "formName": Contact.Schemas.Name(),
                "status": Contact.Submission.Schemas.Status(),
                "createdAt": Contact.Schemas.Timestamp(),
                "email": Contact.Schemas.Email().reference(required: false),
            ]
        }
    }
}
