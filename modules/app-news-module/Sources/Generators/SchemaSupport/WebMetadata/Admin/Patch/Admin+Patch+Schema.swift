public import FeatherOpenAPI
import OpenAPIKit30

public extension WebMetadata.Admin.Patch {
    struct Schema: ObjectSchemaRepresentable {
        public var openAPIIdentifier: String { "WebMetadataPatchSchema" }
        public var propertyMap: SchemaMap {
            WebMetadata.Admin.Create.Schema().propertyMap
        }

        public init() {}
    }
}
