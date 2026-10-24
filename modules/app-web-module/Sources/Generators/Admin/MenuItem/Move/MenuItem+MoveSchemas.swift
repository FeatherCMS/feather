public import FeatherOpenAPI

struct MenuItemMoveSchema: ObjectSchemaRepresentable {
    var propertyMap: SchemaMap {
        [
            "beforeItemId": MenuItemIdField()
        ]
    }
}
