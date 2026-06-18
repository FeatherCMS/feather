import FeatherOpenAPI
import OpenAPIKit30

struct BlogTagIdField: StringSchemaRepresentable {
    var example: String? = "wp_home"
}

struct BlogTagContentField: StringSchemaRepresentable {
    var example: String? = "<h1>Homepage</h1>"
}

struct BlogTagExcerptField: StringSchemaRepresentable {
    var example: String? = "Short tag summary."
}

struct BlogTagTitleField: StringSchemaRepresentable {
    var example: String? = "Swift"
}

struct BlogTagImageAssetIdField: StringSchemaRepresentable {
    var example: String? = "media_asset_1"
}

struct BlogTagCreatedAtField: DoubleSchemaRepresentable {
    var example: Double? { 1_760_000_000 }
}

struct BlogTagUpdatedAtField: DoubleSchemaRepresentable {
    var example: Double? { 1_760_000_000 }
}

struct BlogTagCreateSchema: ObjectSchemaRepresentable {
    var propertyMap: SchemaMap {
        [
            "title": BlogTagTitleField(),
            "excerpt": BlogTagExcerptField(),
            "content": BlogTagContentField(),
            "imageAssetId": BlogTagImageAssetIdField()
                .reference(required: false),
            "metadata": WebMetadataCreateSchema().reference(),
        ]
    }
}

struct BlogTagPatchSchema: ObjectSchemaRepresentable {
    var propertyMap: SchemaMap {
        [
            "title": BlogTagTitleField().reference(required: false),
            "excerpt": BlogTagExcerptField().reference(required: false),
            "content": BlogTagContentField().reference(required: false),
            "imageAssetId": BlogTagImageAssetIdField()
                .reference(required: false),
            "metadata": WebMetadataPatchSchema().reference(required: false),
        ]
    }
}

struct BlogTagDetailSchema: ObjectSchemaRepresentable {
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

struct BlogTagListItemSchema: ObjectSchemaRepresentable {
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

struct BlogTagListSchema: ArraySchemaRepresentable {
    var items: SchemaRepresentable? { BlogTagListItemSchema().reference() }
}
