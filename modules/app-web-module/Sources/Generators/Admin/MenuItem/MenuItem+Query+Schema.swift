import FeatherOpenAPI

struct WebMenuItemQueryItemSchema: ObjectSchemaRepresentable {
    var propertyMap: SchemaMap {
        [
            "id": WebMenuItemIdField().reference(),
            "menuId": WebMenuIdField().reference(),
            "label": WebMenuItemLabelField().reference(),
            "url": WebMenuItemURLField().reference(),
            "priority": WebMenuItemPriorityField().reference(),
            "isBlank": WebMenuItemIsBlankField().reference(),
            "permission": WebMenuItemPermissionField().reference(),
            "authentication": WebMenuItemAuthenticationField().reference(),
            "createdAt": WebMenuItemCreatedAtField().reference(),
            "updatedAt": WebMenuItemUpdatedAtField().reference(),
        ]
    }
}
