import FeatherOpenAPI

extension Variant.Processor.Parameters {
    struct UpdateMask: QueryParameterRepresentable {
        var openAPIIdentifier: String {
            "MediaVariantProcessorUpdateMaskParameter"
        }
        var name: String { "updateMask" }
        var required: Bool { true }
        var description: String? { "Comma-separated fields to update." }
        var schema: any OpenAPISchemaRepresentable {
            Variant.Processor.Schemas.UpdateMask().reference()
        }
    }
}
