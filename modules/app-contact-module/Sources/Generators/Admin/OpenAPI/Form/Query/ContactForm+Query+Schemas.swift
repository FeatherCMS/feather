import FeatherOpenAPI

extension ContactForm.Query {
    enum Schemas {}
}

extension ContactForm.Query.Schemas {
    struct Item: ObjectSchemaRepresentable {
        var openAPIIdentifier: String { "ContactFormQueryItemSchema" }
        var propertyMap: SchemaMap {
            [
                "id": ContactIdField(),
                "key": ContactFormKeyField(),
                "name": ContactNameField(),
            ]
        }
    }
}
