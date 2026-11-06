import FeatherOpenAPI

extension Metadata.Post {
    struct RequestBody: RequestBodyRepresentable {
        var openAPIIdentifier: String { "MetadataRequestBody" }
        var contentMap: ContentMap {
            [.json: Content(Schema().reference())]
        }
    }
}
