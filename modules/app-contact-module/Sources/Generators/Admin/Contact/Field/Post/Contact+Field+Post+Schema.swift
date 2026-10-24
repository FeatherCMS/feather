import FeatherOpenAPI

extension Contact.Field.Post {
    struct Schema: ObjectSchemaRepresentable {
        var openAPIIdentifier: String { "FormFieldCreateSchema" }
        var propertyMap: SchemaMap {
            [
                "key": Contact.Field.Schemas.Key(),
                "type": Contact.Field.Schemas.FieldType(),
                "label": Contact.Field.Schemas.Label(),
                "allowedValues": Contact.Field.Schemas.AllowedValues()
                    .reference(required: false),
                "isRequired": Contact.Field.Schemas.Required()
                    .reference(required: false),
                "position": Contact.Field.Schemas.Position()
                    .reference(required: false),
            ]
        }
    }

    struct RequestBody: JSONRequestBodyRepresentable {
        var openAPIIdentifier: String { "FormFieldCreateRequestBody" }
        var schema = Schema().reference()
    }
}
