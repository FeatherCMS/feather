import FeatherOpenAPI

extension Metadata.Resolve {
    struct RequestBody: RequestBodyRepresentable {
        var openAPIIdentifier: String { "MetadataResolveRequestBody" }
        var contentMap: ContentMap {
            [.json: Content(RequestSchema().reference())]
        }
    }
}
