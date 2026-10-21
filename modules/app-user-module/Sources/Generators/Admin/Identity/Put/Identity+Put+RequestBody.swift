import FeatherOpenAPI

extension Identity.Put {
    struct RequestBody: RequestBodyRepresentable {
        var openAPIIdentifier: String { "UserIdentityUpdateRequestBody" }
        var contentMap: ContentMap {
            [.json: Content(Identity.Put.Schema().reference())]
        }
    }
}
