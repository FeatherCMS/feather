import FeatherOpenAPI

extension Identity.Post {
    struct RequestBody: RequestBodyRepresentable {
        var openAPIIdentifier: String { "UserIdentityCreateRequestBody" }
        var contentMap: ContentMap {
            [.json: Content(Schema().reference())]
        }
    }
}
