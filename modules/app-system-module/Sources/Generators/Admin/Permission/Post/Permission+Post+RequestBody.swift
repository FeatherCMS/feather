import FeatherOpenAPI

extension Permission.Post {
    struct RequestBody: RequestBodyRepresentable {
        var openAPIIdentifier: String { "SystemPermissionRequestBody" }
        var contentMap: ContentMap {
            [.json: Content(Schema().reference())]
        }
    }
}
