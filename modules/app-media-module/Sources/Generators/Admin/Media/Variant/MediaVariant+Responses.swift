import FeatherOpenAPI

struct MediaVariantDetailResponse: JSONResponseRepresentable {
    var description: String = "Media variant response"
    var schema: some SchemaRepresentable {
        MediaVariantDetailSchema().reference()
    }
}

struct MediaVariantProcessorDetailResponse: JSONResponseRepresentable {
    var description: String = "Media variant processor response"
    var schema: some SchemaRepresentable {
        MediaVariantProcessorDetailSchema().reference()
    }
}
