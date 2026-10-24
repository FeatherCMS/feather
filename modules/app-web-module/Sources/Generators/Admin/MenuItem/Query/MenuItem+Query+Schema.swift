public import FeatherOpenAPI

struct MenuItemQueryItemSchema: ObjectSchemaRepresentable {
    var propertyMap: SchemaMap {
        [
            "id": MenuItemIdField().reference(),
            "menuId": MenuIdField().reference(),
            "label": MenuItemLabelField().reference(),
            "url": MenuItemURLField().reference(),
            "priority": MenuItemPriorityField().reference(),
            "isBlank": MenuItemIsBlankField().reference(),
            "permission": MenuItemPermissionField().reference(),
            "authentication": MenuItemAuthenticationField().reference(),
            "createdAt": MenuItemCreatedAtField().reference(),
            "updatedAt": MenuItemUpdatedAtField().reference(),
        ]
    }
}
