import FeatherOpenAPI

extension Contact.Field.Query {
    enum Schemas {}
}

extension Contact.Field.Query.Schemas {
    struct Item: ObjectSchemaRepresentable {
        var openAPIIdentifier: String { "ContactFieldQueryItemSchema" }
        var propertyMap: SchemaMap {
            [
                "id": Contact.Schemas.ID(),
                "key": Contact.Field.Schemas.Key(),
                "type": Contact.Field.Schemas.FieldType(),
                "label": Contact.Field.Schemas.Label(),
                "isRequired": Contact.Field.Schemas.Required(),
            ]
        }
    }
}
