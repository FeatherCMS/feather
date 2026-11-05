import FeatherOpenAPI

extension Variant.Processor.Get {
    struct Response: JSONResponseRepresentable {
        var openAPIIdentifier: String {
            "MediaVariantProcessorDetailResponse"
        }
        var description: String = "Media variant processor response"
        var schema: some SchemaRepresentable {
            Schema().reference()
        }
    }
}
