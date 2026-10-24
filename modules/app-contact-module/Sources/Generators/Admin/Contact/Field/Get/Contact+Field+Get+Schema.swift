import FeatherOpenAPI

extension Contact.Field.Get {
    struct Schema: ObjectSchemaRepresentable {
        var openAPIIdentifier: String { "FormFieldSchema" }
        var propertyMap: SchemaMap {
            [
                "id": Contact.Schemas.ID(),
                "key": Contact.Field.Schemas.Key(),
                "type": Contact.Field.Schemas.FieldType(),
                "label": Contact.Field.Schemas.Label(),
                "allowedValues": Contact.Field.Schemas.AllowedValues()
                    .reference(required: false),
                "isRequired": Contact.Field.Schemas.Required(),
                "position": Contact.Field.Schemas.Position(),
                "createdAt": Contact.Schemas.Timestamp(),
                "updatedAt": Contact.Schemas.Timestamp(),
            ]
        }
    }

    struct Response: JSONResponseRepresentable {
        var openAPIIdentifier: String { "FormFieldResponse" }
        var description: String = "Contact form field response"
        var schema = Schema().reference()
    }
}
