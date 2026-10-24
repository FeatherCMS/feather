public import FeatherOpenAPI

extension Media.Asset.Schemas {
    public struct PixelSize: SchemaRepresentable {
        public var openAPIIdentifier: String { "MediaAssetPixelSizeField" }
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

        public init() {}
    }
}
