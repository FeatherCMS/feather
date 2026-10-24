import FeatherOpenAPI

extension Contact.Field.Put {
    struct Schema: ObjectSchemaRepresentable {
        var openAPIIdentifier: String { "FormFieldPatchSchema" }
        var propertyMap: SchemaMap {
            [
                "key": Contact.Field.Schemas.Key().reference(required: false),
                "type": Contact.Field.Schemas.FieldType()
                    .reference(required: false),
                "label": Contact.Field.Schemas.Label()
                    .reference(required: false),
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
        var openAPIIdentifier: String { "FormFieldPatchRequestBody" }
        var schema = Schema().reference()
    }
}
