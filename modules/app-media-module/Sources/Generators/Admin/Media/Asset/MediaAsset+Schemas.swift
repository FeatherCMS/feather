import FeatherOpenAPI
import FeatherOpenAPIGenerator
import OpenAPIKit30

struct MediaAssetIdField: StringSchemaRepresentable {
    var example: String? = "media_asset_1"
}

struct MediaAssetURLField: StringSchemaRepresentable {
    var example: String? = "/media/assets/media_asset_1/cover-image.jpg"
}

struct MediaAssetTypeField: StringSchemaRepresentable {
    var example: String? = "jpeg"
}

struct MediaAssetContentTypeField: StringSchemaRepresentable {
    var example: String? = "image/jpeg"
}

struct MediaAssetSlugField: StringSchemaRepresentable {
    var example: String? = "cover-image"
}

struct MediaAssetSlugPathField: StringSchemaRepresentable {
    var example: String? = "posts/cover-image"
}

struct MediaAssetFileNameField: StringSchemaRepresentable {
    var example: String? = "cover-image.jpg"
}

struct MediaAssetStatusField: StringSchemaRepresentable {
    var example: String? = "ready"
}

struct MediaAssetSearchItemKindField: StringSchemaRepresentable {
    var enumValues: [String]? = ["file", "folder"]
}

struct MediaAssetDataField: StringSchemaRepresentable {
    var example: String? = "AQID"
}

struct MediaAssetTimestampField: DoubleSchemaRepresentable {
    var example: Double? = 1_717_171_717
}

struct MediaAssetSizeBytesField: SchemaRepresentable {
    func openAPISchema() -> JSONSchema {
        .integer(
            format: .int64,
            required: required,
            nullable: nullable,
            deprecated: deprecated,
            title: title,
            description: description
        )
    }
}

struct MediaAssetNullableTextField: SchemaRepresentable {
    var required: Bool = true

    func openAPISchema() -> JSONSchema {
        .string(
            required: required,
            nullable: true,
            deprecated: deprecated,
            title: title,
            description: description
        )
    }
}

struct MediaAssetVariantIdField: StringSchemaRepresentable {
    var example: String? = "variant_thumb"
}

struct MediaAssetVariantNameField: StringSchemaRepresentable {
    var example: String? = "thumb"
}

struct MediaAssetVariantTypeField: StringSchemaRepresentable {
    var example: String? = "processor"
}

struct MediaAssetVariantItemsField: ArraySchemaRepresentable {
    var items: SchemaRepresentable? {
        MediaAssetVariantListItemSchema().reference()
    }
}

struct MediaAssetCreateSchema: ObjectSchemaRepresentable {
    var propertyMap: SchemaMap {
        [
            "parentId": MediaFolderNullableIdField(),
            "fileName": MediaAssetFileNameField(),
            "extension": MediaAssetTypeField(),
            "title": MediaAssetNullableTextField(required: false),
            "altText": MediaAssetNullableTextField(required: false),
            "data": MediaAssetDataField(),
        ]
    }
}

struct MediaAssetFiltersSchema: ObjectSchemaRepresentable {
    var propertyMap: SchemaMap {
        [
            "search": MediaAssetNullableTextField(required: false),
            "parentId": MediaFolderNullableIdField(),
        ]
    }
}

struct MediaAssetPatchSchema: ObjectSchemaRepresentable {
    var propertyMap: SchemaMap {
        [
            "title": MediaAssetNullableTextField(required: false),
            "altText": MediaAssetNullableTextField(required: false),
        ]
    }
}

struct MediaAssetResolveIDsField: ArraySchemaRepresentable {
    var items: SchemaRepresentable? { MediaAssetIdField() }
}

struct MediaAssetResolveRequestSchema: ObjectSchemaRepresentable {
    var propertyMap: SchemaMap {
        [
            "ids": MediaAssetResolveIDsField(),
            "variants": MediaAssetResolveVariantsField()
                .reference(required: false),
        ]
    }
}

struct MediaAssetResolveVariantsField: ArraySchemaRepresentable {
    var items: SchemaRepresentable? { MediaAssetVariantNameField() }
}

struct MediaAssetDetailSchema: ObjectSchemaRepresentable {
    var propertyMap: SchemaMap {
        [
            "id": MediaAssetIdField().reference(),
            "folderId": MediaFolderNullableIdField(),
            "name": MediaAssetFileNameField(),
            "slug": MediaAssetSlugField(),
            "slugPath": MediaAssetSlugPathField(),
            "url": MediaAssetURLField(),
            "extension": MediaAssetTypeField(),
            "contentType": MediaAssetContentTypeField(),
            "sizeBytes": MediaAssetSizeBytesField(),
            "status": MediaAssetStatusField(),
            "title": MediaAssetNullableTextField(required: false),
            "altText": MediaAssetNullableTextField(required: false),
            "createdAt": MediaAssetTimestampField(),
            "updatedAt": MediaAssetTimestampField(),
        ]
    }
}

struct MediaAssetListItemSchema: ObjectSchemaRepresentable {
    var propertyMap: SchemaMap {
        [
            "id": MediaAssetIdField().reference(),
            "folderId": MediaFolderNullableIdField(),
            "name": MediaAssetFileNameField(),
            "slug": MediaAssetSlugField(),
            "slugPath": MediaAssetSlugPathField(),
            "url": MediaAssetURLField(),
            "extension": MediaAssetTypeField(),
            "contentType": MediaAssetContentTypeField(),
            "sizeBytes": MediaAssetSizeBytesField(),
            "status": MediaAssetStatusField(),
            "title": MediaAssetNullableTextField(required: false),
            "altText": MediaAssetNullableTextField(required: false),
            "createdAt": MediaAssetTimestampField(),
            "updatedAt": MediaAssetTimestampField(),
        ]
    }
}

struct MediaAssetNodeSearchItemSchema: ObjectSchemaRepresentable {
    var propertyMap: SchemaMap {
        [
            "kind": MediaAssetSearchItemKindField(),
            "file": MediaAssetListItemSchema().reference(required: false),
            "folder": MediaFolderListItemSchema().reference(required: false),
        ]
    }
}

struct MediaAssetVariantListItemSchema: ObjectSchemaRepresentable {
    var propertyMap: SchemaMap {
        [
            "variantId": MediaAssetVariantIdField(),
            "name": MediaAssetVariantNameField(),
            "extension": MediaAssetTypeField(),
            "url": MediaAssetURLField(),
        ]
    }
}

struct MediaAssetVariantListSchema: ObjectSchemaRepresentable {
    var propertyMap: SchemaMap {
        [
            "items": MediaAssetVariantItemsField().reference()
        ]
    }
}

struct MediaAssetResolveItemSchema: ObjectSchemaRepresentable {
    var propertyMap: SchemaMap {
        [
            "id": MediaAssetIdField().reference(),
            "url": MediaAssetURLField(),
            "extension": MediaAssetTypeField(),
            "title": MediaAssetNullableTextField(required: false),
            "altText": MediaAssetNullableTextField(required: false),
            "variants": MediaAssetResolveVariantListField(),
        ]
    }
}

struct MediaAssetResolveVariantSchema: ObjectSchemaRepresentable {
    var propertyMap: SchemaMap {
        [
            "name": MediaAssetVariantNameField(),
            "url": MediaAssetURLField(),
            "extension": MediaAssetTypeField(),
        ]
    }
}

struct MediaAssetResolveVariantListField: ArraySchemaRepresentable {
    var items: SchemaRepresentable? {
        MediaAssetResolveVariantSchema().reference()
    }
}

struct MediaAssetResolveSchema: ArraySchemaRepresentable {
    var items: SchemaRepresentable? {
        MediaAssetResolveItemSchema().reference()
    }
}
