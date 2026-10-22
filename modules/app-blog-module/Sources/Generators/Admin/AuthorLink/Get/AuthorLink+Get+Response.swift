import FeatherOpenAPI

extension AuthorLink.Get {
    struct Response: JSONResponseRepresentable {
        var description: String = "Blog author link response"
        var schema = Schema().reference()
    }

    struct Schema: ObjectSchemaRepresentable {
        var propertyMap: SchemaMap {
            [
                "id": BlogAuthorLinkIdField(),
                "menuId": BlogAuthorIdField(),
                "label": BlogAuthorLinkLabelField(),
                "url": BlogAuthorLinkURLField(),
                "priority": BlogAuthorLinkPriorityField(),
                "isBlank": BlogAuthorLinkIsBlankField(),
                "permission": BlogAuthorLinkPermissionField(),
                "notes": BlogAuthorLinkNotesField(),
                "createdAt": BlogAuthorLinkCreatedAtField(),
                "updatedAt": BlogAuthorLinkUpdatedAtField(),
            ]
        }
    }
}
