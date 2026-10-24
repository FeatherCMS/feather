import FeatherOpenAPI

extension Tag.List {
    struct Response: JSONResponseRepresentable {
        var description: String = "Blog tag list response"
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
                "id": BlogTagIdField().reference(),
                "title": BlogTagTitleField().reference(),
                "excerpt": BlogTagExcerptField().reference(),
                "imageAssetId": BlogTagImageAssetIdField()
                    .reference(required: false),
                "createdAt": BlogTagCreatedAtField().reference(),
                "updatedAt": BlogTagUpdatedAtField().reference(),
            ]
        }
    }
}
