import FeatherOpenAPI
import OpenAPIKit30

extension Permission.Post {
    struct RequestBody: RequestBodyRepresentable {
        var openAPIIdentifier: String { "SystemPermissionRequestBody" }
        var contentMap: ContentMap {
            [.json: Content(Permission.Post.Schema().reference())]
        }
    }
}
