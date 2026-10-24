import FeatherOpenAPI

extension Contact.Form.Get {
    struct Schema: ObjectSchemaRepresentable {
        var openAPIIdentifier: String { "ContactFormSchema" }
        var propertyMap: SchemaMap {
            [
                "key": Contact.Schemas.FormKey(),
                "name": Contact.Schemas.Name(),
                "successMessage": Contact.Schemas.Content(),
                "failureMessage": Contact.Schemas.Content(),
                "redirectUrl": Contact.Schemas.Content()
                    .reference(required: false),
                "items": Contact.Field.Schemas.FormFields()
                    .reference(required: false),
                "mails": Contact.Form.Email.Mails()
                    .reference(required: false),
                "createdAt": Contact.Schemas.Timestamp(),
                "updatedAt": Contact.Schemas.Timestamp(),
            ]
        }
    }

    struct Response: JSONResponseRepresentable {
        var openAPIIdentifier: String { "ContactFormResponse" }
        var description: String = "Contact form response"
        var schema = Schema().reference()
    }
}
