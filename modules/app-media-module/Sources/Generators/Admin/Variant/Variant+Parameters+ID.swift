import FeatherOpenAPI

extension Variant {
    enum Parameters {}
}

extension Variant.Parameters {
    struct ID: PathParameterRepresentable {
        var openAPIIdentifier: String { "MediaVariantIdParameter" }
        var name: String { "mediaVariantId" }
        var description: String? { "Media variant id" }
        var schema: any OpenAPISchemaRepresentable {
            Variant.Schemas.ID().reference()
        }
    }
}
