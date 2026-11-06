import FeatherOpenAPI

extension Variant.Processor.Patch {
    struct RequestBody: JSONRequestBodyRepresentable {
        var openAPIIdentifier: String {
            "MediaVariantProcessorPatchRequestBody"
        }
        var schema: some SchemaRepresentable {
            Schema().reference()
        }
    }
}
