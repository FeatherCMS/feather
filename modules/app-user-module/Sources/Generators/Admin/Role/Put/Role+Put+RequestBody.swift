import FeatherOpenAPI

extension Role.Put {
    struct RequestBody: RequestBodyRepresentable {
        var openAPIIdentifier: String { "UserRoleUpdateRequestBody" }
        var contentMap: ContentMap {
            [.json: Content(Role.Put.Schema().reference())]
        }
    }
}
