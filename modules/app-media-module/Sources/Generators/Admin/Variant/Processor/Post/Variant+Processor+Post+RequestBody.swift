import FeatherOpenAPI

extension Variant.Processor.Post {
    struct RequestBody: JSONRequestBodyRepresentable {
        var openAPIIdentifier: String {
            "MediaVariantProcessorCreateRequestBody"
        }
        var schema: some SchemaRepresentable {
            Schema().reference()
        }
    }
}
