import FeatherOpenAPI

extension Variant.Patch {
    struct RequestBody: JSONRequestBodyRepresentable {
        var openAPIIdentifier: String { "MediaVariantPatchRequestBody" }
        var schema: some SchemaRepresentable {
            Schema().reference()
        }
    }
}
