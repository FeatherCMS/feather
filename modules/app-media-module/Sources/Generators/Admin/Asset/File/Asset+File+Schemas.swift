import FeatherOpenAPI
import FeatherOpenAPIGenerator

struct MediaAssetIdField: StringSchemaRepresentable {
    var example: String? = "media_asset_1"
}

struct MediaAssetKeyField: StringSchemaRepresentable {
    var example: String? = "preview"
}

struct MediaAssetURLField: StringSchemaRepresentable {
    var example: String? = "/public/12/34/56789/originals/cover-image.jpg"
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

struct MediaAssetHeaderValueField: StringSchemaRepresentable {}

struct MediaAssetTimestampField: DoubleSchemaRepresentable {
    var example: Double? = 1_717_171_717
}

struct MediaAssetSizeBytesField: Int64SchemaRepresentable {}

struct MediaAssetNullableTextField: StringSchemaRepresentable {
    var required: Bool = true
    var nullable: Bool? = true
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
    var items: (any SchemaRepresentable)? {
        MediaAssetVariantListItemSchema().reference()
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

struct MediaAssetUpdateMaskField: StringSchemaRepresentable {
    var example: String? = "title,altText"
}

struct MediaAssetResolveIDsField: ArraySchemaRepresentable {
    var items: (any SchemaRepresentable)? { MediaAssetIdField() }
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
    var items: (any SchemaRepresentable)? { MediaAssetVariantNameField() }
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
            "key": MediaAssetKeyField().reference(),
            "name": MediaAssetVariantNameField(),
            "url": MediaAssetURLField(),
            "extension": MediaAssetTypeField(),
        ]
    }
}

struct MediaAssetResolveVariantListField: ArraySchemaRepresentable {
    var items: (any SchemaRepresentable)? {
        MediaAssetResolveVariantSchema().reference()
    }
}

struct MediaAssetResolveSchema: ArraySchemaRepresentable {
    var items: (any SchemaRepresentable)? {
        MediaAssetResolveItemSchema().reference()
    }
}
