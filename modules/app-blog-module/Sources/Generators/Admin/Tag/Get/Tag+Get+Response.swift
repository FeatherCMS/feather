import BlogSchemaSupport
import FeatherOpenAPI

extension Tag.Get {
    struct Response: JSONResponseRepresentable {
        var description: String = "Blog tag response"
        var schema = Schema().reference()
    }

    struct Schema: ObjectSchemaRepresentable {
        var propertyMap: SchemaMap {
            [
                "id": BlogTagIdField(),
                "title": BlogTagTitleField(),
                "excerpt": BlogTagExcerptField(),
                "content": BlogTagContentField(),
                "imageAssetId": BlogTagImageAssetIdField()
                    .reference(required: false),
                "metadata": WebMetadataDetailSchema().reference(),
                "createdAt": BlogTagCreatedAtField(),
                "updatedAt": BlogTagUpdatedAtField(),
            ]
        }
    }
}
