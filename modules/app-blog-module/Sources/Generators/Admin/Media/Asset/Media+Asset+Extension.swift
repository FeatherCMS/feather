public import FeatherOpenAPI

extension Media.Asset.Schemas {
    public struct FileExtension: StringSchemaRepresentable {
        public var openAPIIdentifier: String { "MediaAssetExtensionField" }
        public var example: String? = "png"
        public init() {}
    }
}
