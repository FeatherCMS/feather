public import FeatherOpenAPI

extension Media.Asset.Schemas {
    public struct URL: StringSchemaRepresentable {
        public var openAPIIdentifier: String { "MediaAssetURLField" }
        public var example: String? =
            "/public/12/34/56789/originals/example.png"
        public init() {}
    }
}
