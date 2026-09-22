import FeatherOpenAPI
import FeatherOpenAPIGenerator
import OpenAPIKit30

struct MediaAssetIdField: StringSchemaRepresentable {
    var example: String? = "media_asset_1"
}

struct MediaAssetKeyField: StringSchemaRepresentable {
    var example: String? = "preview"
}

struct MediaAssetURLField: StringSchemaRepresentable {
    var example: String? = "/media/assets/media_asset_1/cover-image.jpg"
}

struct MediaAssetTypeField: StringSchemaRepresentable {
    var example: String? = "jpeg"
}

struct MediaAssetResolveIDsField: ArraySchemaRepresentable {
    var items: SchemaRepresentable? { MediaAssetIdField() }
}

struct MediaAssetResolveVariantsField: ArraySchemaRepresentable {
    var items: SchemaRepresentable? { MediaAssetKeyField() }
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

struct MediaAssetResolveVariantSchema: ObjectSchemaRepresentable {
    var propertyMap: SchemaMap {
        [
            "key": MediaAssetKeyField().reference(),
            "url": MediaAssetURLField(),
        ]
    }
}

struct MediaAssetResolveVariantListField: ArraySchemaRepresentable {
    var items: SchemaRepresentable? {
        MediaAssetResolveVariantSchema().reference()
    }
}

struct MediaAssetResolveItemSchema: ObjectSchemaRepresentable {
    var propertyMap: SchemaMap {
        [
            "id": MediaAssetIdField().reference(),
            "url": MediaAssetURLField(),
            "variants": MediaAssetResolveVariantListField(),
        ]
    }
}

struct MediaAssetResolveSchema: ArraySchemaRepresentable {
    var items: SchemaRepresentable? {
        MediaAssetResolveItemSchema().reference()
    }
}
