import FeatherOpenAPI
import OpenAPIKit30

struct WebPageIdField: StringSchemaRepresentable {
    var example: String? = "wp_home"
}

struct WebPageContentField: StringSchemaRepresentable {
    var example: String? = "<h1>Homepage</h1>"
}

struct WebPageExcerptField: StringSchemaRepresentable {
    var example: String? = "Short page summary."
}

struct WebPageTitleField: StringSchemaRepresentable {
    var example: String? = "Homepage"
}

struct WebPageImageAssetIdField: StringSchemaRepresentable {
    var example: String? = "media_asset_1"
}

struct WebPageCreatedAtField: DoubleSchemaRepresentable {
    var example: Double? { 1_760_000_000 }
}

struct WebPageUpdatedAtField: DoubleSchemaRepresentable {
    var example: Double? { 1_760_000_000 }
}

struct WebPageCreateSchema: ObjectSchemaRepresentable {
    var propertyMap: SchemaMap {
        [
            "title": WebPageTitleField(),
            "excerpt": WebPageExcerptField(),
            "content": WebPageContentField(),
            "imageAssetId": WebPageImageAssetIdField()
                .reference(required: false),
            "metadata": WebMetadataCreateSchema().reference(),
        ]
    }
}

struct WebPagePatchSchema: ObjectSchemaRepresentable {
    var propertyMap: SchemaMap {
        [
            "title": WebPageTitleField().reference(required: false),
            "excerpt": WebPageExcerptField().reference(required: false),
            "content": WebPageContentField().reference(required: false),
            "imageAssetId": WebPageImageAssetIdField()
                .reference(required: false),
            "metadata": WebMetadataPatchSchema().reference(required: false),
        ]
    }
}

struct WebPageDetailSchema: ObjectSchemaRepresentable {
    var propertyMap: SchemaMap {
        [
            "id": WebPageIdField(),
            "title": WebPageTitleField(),
            "excerpt": WebPageExcerptField(),
            "content": WebPageContentField(),
            "imageAssetId": WebPageImageAssetIdField()
                .reference(required: false),
            "metadata": WebMetadataDetailSchema().reference(),
            "createdAt": WebPageCreatedAtField(),
            "updatedAt": WebPageUpdatedAtField(),
        ]
    }
}

struct WebPageListItemSchema: ObjectSchemaRepresentable {
    var propertyMap: SchemaMap {
        [
            "id": WebPageIdField().reference(),
            "title": WebPageTitleField().reference(),
            "excerpt": WebPageExcerptField().reference(),
            "imageAssetId": WebPageImageAssetIdField()
                .reference(required: false),
            "createdAt": WebPageCreatedAtField().reference(),
            "updatedAt": WebPageUpdatedAtField().reference(),
        ]
    }
}

struct WebPageListSchema: ArraySchemaRepresentable {
    var items: SchemaRepresentable? { WebPageListItemSchema().reference() }
}
