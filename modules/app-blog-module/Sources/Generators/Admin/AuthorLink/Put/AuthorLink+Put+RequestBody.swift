import FeatherOpenAPI

extension AuthorLink.Put {
    struct RequestBody: RequestBodyRepresentable {
        var contentMap: ContentMap {
            [.json: Content(Schema().reference())]
        }
    }

    struct Schema: ObjectSchemaRepresentable {
        var propertyMap: SchemaMap {
            [
                "label": BlogAuthorLinkLabelField(),
                "url": BlogAuthorLinkURLField(),
                "priority": BlogAuthorLinkPriorityField(),
                "isBlank": BlogAuthorLinkIsBlankField(),
                "permission": BlogAuthorLinkPermissionField(),
                "notes": BlogAuthorLinkNotesField().reference(required: false),
            ]
        }
    }
}
