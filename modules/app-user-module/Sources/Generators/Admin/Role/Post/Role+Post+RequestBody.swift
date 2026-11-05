import FeatherOpenAPI

extension Role.Post {
    struct RequestBody: RequestBodyRepresentable {
        var openAPIIdentifier: String { "UserRoleRequestBody" }
        var contentMap: ContentMap {
            [.json: Content(Schema().reference())]
        }
    }
}
