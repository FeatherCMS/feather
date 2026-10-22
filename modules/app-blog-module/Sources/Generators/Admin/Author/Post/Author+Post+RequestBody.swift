import FeatherOpenAPI

extension Author.Post {
    struct RequestBody: RequestBodyRepresentable {
        var contentMap: ContentMap {
            [.json: Content(Schema().reference())]
        }
    }

    struct Schema: ObjectSchemaRepresentable {
        var propertyMap: SchemaMap {
            [
                "name": BlogAuthorNameField(),
                "excerpt": BlogAuthorExcerptField().reference(required: false),
                "content": BlogAuthorContentField().reference(required: false),
                "profileImageAssetId": BlogAuthorProfileImageAssetIdField()
                    .reference(required: false),
            ]
        }
    }
}
