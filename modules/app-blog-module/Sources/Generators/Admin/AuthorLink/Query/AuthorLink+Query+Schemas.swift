import FeatherOpenAPI

extension AuthorLink.Query {
    struct ItemSchema: ObjectSchemaRepresentable {
        var propertyMap: SchemaMap {
            [
                "id": BlogAuthorLinkIdField().reference(),
                "menuId": BlogAuthorIdField().reference(),
                "label": BlogAuthorLinkLabelField().reference(),
                "url": BlogAuthorLinkURLField().reference(),
                "priority": BlogAuthorLinkPriorityField().reference(),
                "isBlank": BlogAuthorLinkIsBlankField().reference(),
                "permission": BlogAuthorLinkPermissionField().reference(),
                "createdAt": BlogAuthorLinkCreatedAtField().reference(),
                "updatedAt": BlogAuthorLinkUpdatedAtField().reference(),
            ]
        }
    }
}
