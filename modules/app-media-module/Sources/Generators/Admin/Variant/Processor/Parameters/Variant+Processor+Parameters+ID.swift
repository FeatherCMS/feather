import FeatherOpenAPI

extension Variant.Processor {
    enum Parameters {}
}

extension Variant.Processor.Parameters {
    struct ID: PathParameterRepresentable {
        var openAPIIdentifier: String { "MediaVariantProcessorIdParameter" }
        var name: String { "mediaVariantProcessorId" }
        var description: String? { "Media variant processor id" }
        var schema: any OpenAPISchemaRepresentable {
            Variant.Schemas.ID().reference()
        }
    }
}
