import FeatherOpenAPI
import OpenAPIKit30

struct BlogAuthorIdField: StringSchemaRepresentable {
    var example: String? = "wm_header"
}

struct BlogAuthorNameField: StringSchemaRepresentable {
    var example: String? = "Header menu"
}

struct BlogAuthorContentField: StringSchemaRepresentable {
    var example: String? = "Author biography."
}

struct BlogAuthorExcerptField: StringSchemaRepresentable {
    var example: String? = "Short author summary."
}

struct BlogAuthorProfileImageAssetIdField: StringSchemaRepresentable {
    var example: String? = "media_asset_1"
}

struct BlogAuthorCreatedAtField: DoubleSchemaRepresentable {
    var example: Double? { 1_760_000_000 }
}

struct BlogAuthorUpdatedAtField: DoubleSchemaRepresentable {
    var example: Double? { 1_760_000_000 }
}

struct BlogAuthorCreateSchema: ObjectSchemaRepresentable {
    var propertyMap: SchemaMap {
        [
            "name": BlogAuthorNameField(),
            "excerpt": BlogAuthorExcerptField().reference(required: false),
            "content": BlogAuthorContentField().reference(required: false),
            "profileImageAssetId": BlogAuthorProfileImageAssetIdField()
                .reference(required: false),
            "metadata": WebMetadataCreateSchema().reference(),
        ]
    }
}

struct BlogAuthorPatchSchema: ObjectSchemaRepresentable {
    var propertyMap: SchemaMap {
        [
            "name": BlogAuthorNameField().reference(required: false),
            "excerpt": BlogAuthorExcerptField().reference(required: false),
            "content": BlogAuthorContentField().reference(required: false),
            "profileImageAssetId": BlogAuthorProfileImageAssetIdField()
                .reference(required: false),
            "metadata": WebMetadataPatchSchema().reference(required: false),
        ]
    }
}

struct BlogAuthorDetailSchema: ObjectSchemaRepresentable {
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

struct BlogAuthorListItemSchema: ObjectSchemaRepresentable {
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

struct BlogAuthorListSchema: ArraySchemaRepresentable {
    var items: SchemaRepresentable? { BlogAuthorListItemSchema().reference() }
}
