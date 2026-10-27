import FeatherOpenAPI

extension Contact.Form.Get {
    struct Schema: ObjectSchemaRepresentable {
        var openAPIIdentifier: String { "AppContactFormSchema" }
        var propertyMap: SchemaMap {
            [
                "key": Contact.Schemas.ID(),
                "name": Contact.Form.Field.Name(),
                "successMessage": Contact.Schemas.Content(),
                "failureMessage": Contact.Schemas.Content(),
                "submitLabel": Contact.Schemas.Content(),
                "redirectUrl": Contact.Schemas.Content()
                    .reference(required: false),
                "items": Contact.Form.Field.Collection(),
            ]
        }
    }

}
