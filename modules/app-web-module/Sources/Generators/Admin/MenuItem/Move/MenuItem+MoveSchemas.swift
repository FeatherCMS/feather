public import FeatherOpenAPI
import OpenAPIKit30

struct MenuItemMoveSchema: ObjectSchemaRepresentable {
    var propertyMap: SchemaMap {
        [
            "beforeItemId": MenuItemIdField()
        ]
    }
}
