import FeatherOpenAPI

extension ContactField.Query {
    enum Schemas {}
}

extension ContactField.Query.Schemas {
    struct Item: ObjectSchemaRepresentable {
        var openAPIIdentifier: String { "ContactFieldQueryItemSchema" }
        var propertyMap: SchemaMap {
            [
                "id": ContactIdField(),
                "key": ContactKeyField(),
                "type": ContactTypeField(),
                "label": ContactLabelField(),
                "isRequired": ContactRequiredField(),
            ]
        }
    }
}
