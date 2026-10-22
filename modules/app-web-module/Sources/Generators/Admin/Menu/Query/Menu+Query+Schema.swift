public import FeatherOpenAPI

struct WebMenuQueryItemSchema: ObjectSchemaRepresentable {
    var propertyMap: SchemaMap {
        [
            "id": WebMenuIdField().reference(),
            "key": WebMenuKeyField().reference(),
            "name": WebMenuNameField().reference(),
            "createdAt": WebMenuCreatedAtField().reference(),
            "updatedAt": WebMenuUpdatedAtField().reference(),
        ]
    }
}
