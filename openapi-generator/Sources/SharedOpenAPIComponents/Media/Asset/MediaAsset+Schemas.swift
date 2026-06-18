import FeatherOpenAPI
import OpenAPIKit30

public struct MediaAssetIdField: StringSchemaRepresentable {
    public var example: String? = "media_asset_1"

    public init() {}
}

public struct MediaAssetURLField: StringSchemaRepresentable {
    public var example: String? = "/media/assets/example.png"

    public init() {}
}

public struct MediaAssetTypeField: StringSchemaRepresentable {
    public var example: String? = "png"

    public init() {}
}

public struct MediaAssetPixelSizeField: SchemaRepresentable {
    public var required: Bool = true

    public func openAPISchema() -> JSONSchema {
        .integer(
            format: .int64,
            required: required,
            nullable: true,
            deprecated: deprecated,
            title: title,
            description: description
        )
    }
}

public struct MediaAssetVariantListSchema: ArraySchemaRepresentable {
    public var items: SchemaRepresentable? {
        MediaAssetVariantSchema().reference()
    }

    public init() {}
}

public struct MediaAssetVariantSchema: ObjectSchemaRepresentable {
    public var propertyMap: SchemaMap {
        [
            "id": MediaAssetIdField().reference(),
            "url": MediaAssetURLField().reference(),
            "type": MediaAssetTypeField().reference(),
            "width": MediaAssetPixelSizeField(required: false),
            "height": MediaAssetPixelSizeField(required: false),
        ]
    }

    public init() {}
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
