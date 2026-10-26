import FeatherOpenAPI

extension Metadata.Resolve {
    struct Schema: ArraySchemaRepresentable {
        var openAPIIdentifier: String { "MetadataResolveSchema" }
        var items: (any SchemaRepresentable)? { ItemSchema().reference() }
    }
}
