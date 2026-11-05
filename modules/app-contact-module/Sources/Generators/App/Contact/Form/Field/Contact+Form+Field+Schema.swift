import FeatherOpenAPI

extension Contact.Form.Field {
    struct Schema: ObjectSchemaRepresentable {
        var openAPIIdentifier: String { "AppFormFieldSchema" }
        var propertyMap: SchemaMap {
            [
                "id": Contact.Schemas.ID(),
                "key": Contact.Schemas.ID(),
                "type": Contact.Schemas.ID(),
                "label": Name(),
                "allowedValues": AllowedValues().reference(required: false),
                "isRequired": Required(),
                "position": Position(),
            ]
        }
    }
}
