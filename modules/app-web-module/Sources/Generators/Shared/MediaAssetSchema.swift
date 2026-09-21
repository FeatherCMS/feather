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
    var example: String? = "/media/assets/example.png"
}

struct MediaAssetExtensionField: StringSchemaRepresentable {
    var example: String? = "png"
}

struct MediaAssetPixelSizeField: SchemaRepresentable {
    var required: Bool = true

    func openAPISchema() -> JSONSchema {
        .integer(format: .int64, required: required, nullable: true)
    }
}

struct MediaAssetVariantSchema: ObjectSchemaRepresentable {
    var propertyMap: SchemaMap {
        [
            "key": MediaAssetKeyField().reference(),
            "url": MediaAssetURLField().reference(),
        ]
    }
}

struct MediaAssetVariantListSchema: ArraySchemaRepresentable {
    var items: SchemaRepresentable? { MediaAssetVariantSchema().reference() }
}

public struct MediaAssetSchema: ObjectSchemaRepresentable {
    public var propertyMap: SchemaMap {
        [
            "assetId": MediaAssetIdField().reference(),
            "originalURL": MediaAssetURLField().reference(),
            "defaultURL": MediaAssetURLField().reference(),
            "variants": MediaAssetVariantListSchema().reference(),
        ]
    }

    public init() {}
}
