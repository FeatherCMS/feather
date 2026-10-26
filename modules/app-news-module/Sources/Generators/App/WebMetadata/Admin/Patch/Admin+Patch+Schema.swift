public import FeatherOpenAPI

extension WebMetadata.Admin.Patch {
    public struct Schema: ObjectSchemaRepresentable {
        public var openAPIIdentifier: String { "WebMetadataPatchSchema" }
        public var propertyMap: SchemaMap {
            WebMetadata.Admin.Create.Schema().propertyMap
        }

        public init() {}
    }
}
