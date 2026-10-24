public import FeatherOpenAPI
import WebOpenAPIGeneratorSupport

struct PageIdField: StringSchemaRepresentable {
    var example: String? = "wp_home"
}

struct PageContentField: StringSchemaRepresentable {
    var example: String? = "<h1>Homepage</h1>"
}

struct PageExcerptField: StringSchemaRepresentable {
    var example: String? = "Short page summary."
}

struct PageTitleField: StringSchemaRepresentable {
    var example: String? = "Homepage"
}

struct PageImageAssetIdField: StringSchemaRepresentable {
    var example: String? = "media_asset_1"
}

struct PageCreatedAtField: DoubleSchemaRepresentable {
    var example: Double? { 1_760_000_000 }
}

struct PageUpdatedAtField: DoubleSchemaRepresentable {
    var example: Double? { 1_760_000_000 }
}

struct PageCreateSchema: ObjectSchemaRepresentable {
    var propertyMap: SchemaMap {
        [
            "title": PageTitleField(),
            "excerpt": PageExcerptField(),
            "content": PageContentField(),
            "imageAssetId": PageImageAssetIdField()
                .reference(required: false),
        ]
    }
}

struct PagePatchSchema: ObjectSchemaRepresentable {
    var propertyMap: SchemaMap {
        [
            "title": PageTitleField().reference(required: false),
            "excerpt": PageExcerptField().reference(required: false),
            "content": PageContentField().reference(required: false),
            "imageAssetId": PageImageAssetIdField()
                .reference(required: false),
        ]
    }
}

struct PageDetailSchema: ObjectSchemaRepresentable {
    var propertyMap: SchemaMap {
        [
            "id": PageIdField(),
            "title": PageTitleField(),
            "excerpt": PageExcerptField(),
            "content": PageContentField(),
            "imageAssetId": PageImageAssetIdField()
                .reference(required: false),
            "metadata": MetadataDetailSchema().reference(),
            "createdAt": PageCreatedAtField(),
            "updatedAt": PageUpdatedAtField(),
        ]
    }
}

struct PageListItemSchema: ObjectSchemaRepresentable {
    var propertyMap: SchemaMap {
        [
            "id": PageIdField().reference(),
            "title": PageTitleField().reference(),
            "excerpt": PageExcerptField().reference(),
            "imageAssetId": PageImageAssetIdField()
                .reference(required: false),
            "createdAt": PageCreatedAtField().reference(),
            "updatedAt": PageUpdatedAtField().reference(),
        ]
    }
}

struct PageListSchema: ArraySchemaRepresentable {
    var items: (any SchemaRepresentable)? {
        PageListItemSchema().reference()
    }
}
