import FeatherOpenAPI

extension Email.Post {
    struct RequestBody: RequestBodyRepresentable {
        var openAPIIdentifier: String { "AuthEmailPostRequestBody" }
        var contentMap: ContentMap {
            [.json: Content(Schema().reference())]
        }
    }
}
