public import FeatherOpenAPI
public import OpenAPIKit30

extension Media.Asset {
    public enum Schemas {}
}

extension Media.Asset.Schemas {
    public struct ID: StringSchemaRepresentable {
        public var openAPIIdentifier: String { "MediaAssetIdField" }
        public var example: String? = "media_asset_1"

        public init() {}
    }

    public struct Key: StringSchemaRepresentable {
        public var openAPIIdentifier: String { "MediaAssetKeyField" }
        public var example: String? = "preview"

        public init() {}
    }

    public struct URL: StringSchemaRepresentable {
        public var openAPIIdentifier: String { "MediaAssetURLField" }
        public var example: String? =
            "/public/12/34/56789/originals/example.png"

        public init() {}
    }

    public struct FileExtension: StringSchemaRepresentable {
        public var openAPIIdentifier: String { "MediaAssetExtensionField" }
        public var example: String? = "png"

        public init() {}
    }

    public struct PixelSize: SchemaRepresentable {
        public var openAPIIdentifier: String { "MediaAssetPixelSizeField" }
        public var required: Bool = true

        public init() {}

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

    public struct VariantList: ArraySchemaRepresentable {
        public var openAPIIdentifier: String { "MediaAssetVariantListSchema" }
        public var items: (any SchemaRepresentable)? {
            Variant().reference()
        }

        public init() {}
    }

    public struct Variant: ObjectSchemaRepresentable {
        public var openAPIIdentifier: String { "MediaAssetVariantSchema" }
        public var propertyMap: SchemaMap {
            [
                "key": Key().reference(),
                "url": URL().reference(),
            ]
        }

        public init() {}
    }

    public struct Schema: ObjectSchemaRepresentable {
        public var openAPIIdentifier: String { "MediaAssetSchema" }
        public var propertyMap: SchemaMap {
            [
                "assetId": ID().reference(),
                "originalURL": URL().reference(),
                "defaultURL": URL().reference(),
                "variants": VariantList().reference(),
            ]
        }

        public init() {}
    }
}
