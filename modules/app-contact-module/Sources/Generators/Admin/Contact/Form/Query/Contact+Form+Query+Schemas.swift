import FeatherOpenAPI

extension Contact.Form.Query {
    enum Schemas {}
}

extension Contact.Form.Query.Schemas {
    struct Item: ObjectSchemaRepresentable {
        var openAPIIdentifier: String { "ContactFormQueryItemSchema" }
        var propertyMap: SchemaMap {
            [
                "id": Contact.Schemas.ID(),
                "key": Contact.Schemas.FormKey(),
                "name": Contact.Schemas.Name(),
            ]
        }
    }
}
