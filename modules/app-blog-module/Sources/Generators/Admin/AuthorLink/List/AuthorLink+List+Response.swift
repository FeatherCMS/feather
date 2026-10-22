import FeatherOpenAPI

extension AuthorLink.List {
    struct Response: JSONResponseRepresentable {
        var description: String = "Blog author link list response"
        var schema = Schema().reference()
    }

    struct Schema: ArraySchemaRepresentable {
        var items: (any SchemaRepresentable)? {
            ItemSchema().reference()
        }
    }

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
