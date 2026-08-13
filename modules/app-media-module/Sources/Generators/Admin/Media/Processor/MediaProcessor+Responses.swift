import FeatherOpenAPI

struct MediaProcessorDetailResponse: JSONResponseRepresentable {
    var description: String = "MediaProcessor response"
    var schema: some SchemaRepresentable {
        MediaProcessorDetailSchema().reference()
    }
}
