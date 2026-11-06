import FeatherOpenAPI

extension Variant.Get {
    struct Response: JSONResponseRepresentable {
        var openAPIIdentifier: String { "MediaVariantDetailResponse" }
        var description: String = "Media variant response"
        var schema: some SchemaRepresentable {
            Schema().reference()
        }
    }
}
