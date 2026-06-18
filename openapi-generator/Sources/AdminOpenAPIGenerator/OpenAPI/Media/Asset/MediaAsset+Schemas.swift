import FeatherOpenAPI
import OpenAPIKit30
import SharedOpenAPIComponents

struct MediaAssetIdField: StringSchemaRepresentable {
    var example: String? = "media_asset_1"
}

struct MediaAssetStorageKeyField: StringSchemaRepresentable {
    var example: String? = "media/assets/asset-1"
}

struct MediaAssetBaseNameField: StringSchemaRepresentable {
    var example: String? = "asset-1"
}

struct MediaAssetTypeField: StringSchemaRepresentable {
    var example: String? = "jpeg"
}

struct MediaAssetFileNameField: StringSchemaRepresentable {
    var example: String? = "cover-image.jpg"
}

struct MediaAssetStatusField: StringSchemaRepresentable {
    var example: String? = "ready"
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
            "type": MediaAssetTypeField(),
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

struct MediaAssetDetailSchema: ObjectSchemaRepresentable {
    var propertyMap: SchemaMap {
        [
            "id": MediaAssetIdField().reference(),
            "folderId": MediaFolderNullableIdField(),
            "storageKey": MediaAssetStorageKeyField(),
            "baseName": MediaAssetBaseNameField(),
            "type": MediaAssetTypeField(),
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
            "storageKey": MediaAssetStorageKeyField(),
            "baseName": MediaAssetBaseNameField(),
            "type": MediaAssetTypeField(),
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
            "type": MediaAssetVariantTypeField(),
            "storageKey": MediaAssetStorageKeyField(),
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
