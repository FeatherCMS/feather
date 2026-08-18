import FeatherOpenAPI
import OpenAPIKit30

struct WebMenuItemMoveSchema: ObjectSchemaRepresentable {
    var propertyMap: SchemaMap {
        [
            "beforeItemId": WebMenuItemIdField()
        ]
    }
}
