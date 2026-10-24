import FeatherOpenAPI

extension Author.Query {
    struct ItemSchema: ObjectSchemaRepresentable {
        var propertyMap: SchemaMap {
            [
                "id": BlogAuthorIdField().reference(),
                "name": BlogAuthorNameField().reference(),
                "excerpt": BlogAuthorExcerptField().reference(),
                "profileImageAssetId": BlogAuthorProfileImageAssetIdField()
                    .reference(required: false),
                "createdAt": BlogAuthorCreatedAtField().reference(),
                "updatedAt": BlogAuthorUpdatedAtField().reference(),
            ]
        }
    }
}
