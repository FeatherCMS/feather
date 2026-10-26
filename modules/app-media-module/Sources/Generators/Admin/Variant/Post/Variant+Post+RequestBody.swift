import FeatherOpenAPI

extension Variant.Post {
    struct RequestBody: JSONRequestBodyRepresentable {
        var openAPIIdentifier: String { "MediaVariantCreateRequestBody" }
        var schema: some SchemaRepresentable {
            Schema().reference()
        }
    }
}
