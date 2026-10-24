public import FeatherOpenAPI

struct MenuQueryItemSchema: ObjectSchemaRepresentable {
    var propertyMap: SchemaMap {
        [
            "id": MenuIdField().reference(),
            "key": MenuKeyField().reference(),
            "name": MenuNameField().reference(),
            "createdAt": MenuCreatedAtField().reference(),
            "updatedAt": MenuUpdatedAtField().reference(),
        ]
    }
}
