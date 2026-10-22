import FeatherOpenAPI

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

struct BlogPostUpdateMaskField: StringSchemaRepresentable {
    var example: String? = "title,imageAssetId"
}

struct BlogPostAuthorIdsField: ArraySchemaRepresentable {
    var items: (any SchemaRepresentable)? {
        BlogAuthorIdField().reference()
    }
}

struct BlogPostTagIdsField: ArraySchemaRepresentable {
    var items: (any SchemaRepresentable)? {
        BlogTagIdField().reference()
    }
}

struct BlogPostCreatedAtField: DoubleSchemaRepresentable {
    var example: Double? { 1_760_000_000 }
}

struct BlogPostUpdatedAtField: DoubleSchemaRepresentable {
    var example: Double? { 1_760_000_000 }
}
