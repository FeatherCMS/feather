import FeatherOpenAPI

extension Author.List {
    struct Response: JSONResponseRepresentable {
        var description: String = "Blog author list response"
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
