import FeatherOpenAPI

extension Variant.Schemas {
    struct Processors: ArraySchemaRepresentable {
        var openAPIIdentifier: String { "MediaVariantProcessorListField" }
        var items: (any SchemaRepresentable)? {
            Variant.Processor.List.ItemSchema().reference()
        }
    }
}
