import FeatherOpenAPI

extension Metadata.List {
    struct Schema: ArraySchemaRepresentable {
        var openAPIIdentifier: String { "MetadataListSchema" }
        var items: (any SchemaRepresentable)? { ItemSchema().reference() }
    }
}
