import FeatherOpenAPI

extension Variant.Parameters {
    struct UpdateMask: QueryParameterRepresentable {
        var openAPIIdentifier: String { "MediaVariantUpdateMaskParameter" }
        var name: String { "updateMask" }
        var required: Bool { true }
        var description: String? { "Comma-separated fields to update." }
        var schema: any OpenAPISchemaRepresentable {
            Variant.Schemas.UpdateMask().reference()
        }
    }
}
