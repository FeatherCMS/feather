import FeatherOpenAPI
import OpenAPIKit30

struct BlogPostIdField: StringSchemaRepresentable {
    var example: String? = "wp_home"
}

struct BlogPostContentField: StringSchemaRepresentable {
    var example: String? = "<h1>Homepage</h1>"
}

struct BlogPostExcerptField: StringSchemaRepresentable {
    var example: String? = "Short post summary."
}

struct BlogPostTitleField: StringSchemaRepresentable {
    var example: String? = "Hello world"
}

struct BlogPostImageAssetIdField: StringSchemaRepresentable {
    var example: String? = "media_asset_1"
}

struct BlogPostAuthorIdsField: ArraySchemaRepresentable {
    var items: SchemaRepresentable? {
        BlogAuthorIdField().reference()
    }
}

struct BlogPostTagIdsField: ArraySchemaRepresentable {
    var items: SchemaRepresentable? {
        BlogTagIdField().reference()
    }
}

struct BlogPostCreatedAtField: DoubleSchemaRepresentable {
    var example: Double? { 1_760_000_000 }
}

struct BlogPostUpdatedAtField: DoubleSchemaRepresentable {
    var example: Double? { 1_760_000_000 }
}

struct BlogPostCreateSchema: ObjectSchemaRepresentable {
    var propertyMap: SchemaMap {
        [
            "title": BlogPostTitleField(),
            "excerpt": BlogPostExcerptField(),
            "content": BlogPostContentField(),
            "imageAssetId": BlogPostImageAssetIdField()
                .reference(required: false),
            "authorIds": BlogPostAuthorIdsField().reference(required: false),
            "tagIds": BlogPostTagIdsField().reference(required: false),
            "metadata": WebMetadataCreateSchema().reference(),
        ]
    }
}

struct BlogPostPatchSchema: ObjectSchemaRepresentable {
    var propertyMap: SchemaMap {
        [
            "title": BlogPostTitleField().reference(required: false),
            "excerpt": BlogPostExcerptField().reference(required: false),
            "content": BlogPostContentField().reference(required: false),
            "imageAssetId": BlogPostImageAssetIdField()
                .reference(required: false),
            "authorIds": BlogPostAuthorIdsField().reference(required: false),
            "tagIds": BlogPostTagIdsField().reference(required: false),
            "metadata": WebMetadataPatchSchema().reference(required: false),
        ]
    }
}

struct BlogPostDetailSchema: ObjectSchemaRepresentable {
    var propertyMap: SchemaMap {
        [
            "id": BlogPostIdField(),
            "title": BlogPostTitleField(),
            "excerpt": BlogPostExcerptField(),
            "content": BlogPostContentField(),
            "imageAssetId": BlogPostImageAssetIdField()
                .reference(required: false),
            "authorIds": BlogPostAuthorIdsField().reference(),
            "tagIds": BlogPostTagIdsField().reference(),
            "metadata": WebMetadataDetailSchema().reference(),
            "createdAt": BlogPostCreatedAtField(),
            "updatedAt": BlogPostUpdatedAtField(),
        ]
    }
}

struct BlogPostListItemSchema: ObjectSchemaRepresentable {
    var propertyMap: SchemaMap {
        [
            "id": BlogPostIdField().reference(),
            "title": BlogPostTitleField().reference(),
            "excerpt": BlogPostExcerptField().reference(),
            "imageAssetId": BlogPostImageAssetIdField()
                .reference(required: false),
            "createdAt": BlogPostCreatedAtField().reference(),
            "updatedAt": BlogPostUpdatedAtField().reference(),
        ]
    }
}

struct BlogPostListSchema: ArraySchemaRepresentable {
    var items: SchemaRepresentable? { BlogPostListItemSchema().reference() }
}
