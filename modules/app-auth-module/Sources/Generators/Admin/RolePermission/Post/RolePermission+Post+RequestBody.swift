import FeatherOpenAPI
import OpenAPIKit30

extension RolePermission.Post {

    struct RequestBody: RequestBodyRepresentable {
        var openAPIIdentifier: String { "AuthRolePermissionRequestBody" }
        var contentMap: ContentMap {
            [
                .json: Content(
                    RolePermission.Post.Schema()
                        .reference()
                )
            ]
        }
    }
}
