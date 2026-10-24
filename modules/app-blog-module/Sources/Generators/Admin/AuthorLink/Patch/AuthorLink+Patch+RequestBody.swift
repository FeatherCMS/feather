import FeatherOpenAPI

extension AuthorLink.Patch {
    struct RequestBody: RequestBodyRepresentable {
        var contentMap: ContentMap {
            [.json: Content(Schema().reference())]
        }
    }

    struct Schema: ObjectSchemaRepresentable {
        var propertyMap: SchemaMap {
            [
                "label": BlogAuthorLinkLabelField().reference(required: false),
                "url": BlogAuthorLinkURLField().reference(required: false),
                "priority": BlogAuthorLinkPriorityField()
                    .reference(required: false),
                "isBlank": BlogAuthorLinkIsBlankField()
                    .reference(required: false),
                "permission": BlogAuthorLinkPermissionField()
                    .reference(required: false),
                "notes": BlogAuthorLinkNotesField().reference(required: false),
            ]
        }
    }
}
