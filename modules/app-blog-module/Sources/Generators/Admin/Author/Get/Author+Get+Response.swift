import BlogSharedOpenAPIGenerator
import FeatherOpenAPI

extension Author.Get {
    struct Response: JSONResponseRepresentable {
        var description: String = "Blog author response"
        var schema = Schema().reference()
    }

    struct Schema: ObjectSchemaRepresentable {
        var propertyMap: SchemaMap {
            [
                "id": BlogAuthorIdField(),
                "name": BlogAuthorNameField(),
                "excerpt": BlogAuthorExcerptField(),
                "content": BlogAuthorContentField(),
                "profileImageAssetId": BlogAuthorProfileImageAssetIdField()
                    .reference(required: false),
                "metadata": WebMetadataDetailSchema().reference(),
                "createdAt": BlogAuthorCreatedAtField(),
                "updatedAt": BlogAuthorUpdatedAtField(),
            ]
        }
    }
}
