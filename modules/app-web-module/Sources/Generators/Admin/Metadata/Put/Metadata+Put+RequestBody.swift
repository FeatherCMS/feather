import FeatherOpenAPI

extension Metadata.Put {
    struct RequestBody: RequestBodyRepresentable {
        var openAPIIdentifier: String { "MetadataUpdateRequestBody" }
        var contentMap: ContentMap {
            [.json: Content(Metadata.Post.Schema().reference())]
        }
    }
}
