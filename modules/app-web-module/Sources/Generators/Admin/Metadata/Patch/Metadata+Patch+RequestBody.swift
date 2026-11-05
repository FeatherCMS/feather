import FeatherOpenAPI

extension Metadata.Patch {
    struct RequestBody: RequestBodyRepresentable {
        var openAPIIdentifier: String { "MetadataPatchRequestBody" }
        var contentMap: ContentMap {
            [.json: Content(Schema().reference())]
        }
    }
}
