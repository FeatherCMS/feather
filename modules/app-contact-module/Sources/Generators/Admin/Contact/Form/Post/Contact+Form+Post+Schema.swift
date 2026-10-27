import FeatherOpenAPI

extension Contact.Form.Post {
    struct Schema: ObjectSchemaRepresentable {
        var openAPIIdentifier: String { "ContactFormCreateSchema" }
        var propertyMap: SchemaMap {
            [
                "key": Contact.Schemas.FormKey(),
                "name": Contact.Schemas.Name(),
                "successMessage": Contact.Schemas.Content().reference(),
                "failureMessage": Contact.Schemas.Content().reference(),
                "submitLabel": Contact.Schemas.Content().reference(),
                "redirectUrl": Contact.Schemas.Content()
                    .reference(required: false),
                "fieldIds": Contact.Field.Schemas.IDs()
                    .reference(required: false),
                "mails": Contact.Form.Email.Inputs()
                    .reference(required: false),
            ]
        }
    }

    struct RequestBody: JSONRequestBodyRepresentable {
        var openAPIIdentifier: String { "ContactFormCreateRequestBody" }
        var schema = Schema().reference()
    }
}
