import FeatherOpenAPI
import OpenAPIKit30

struct AuthRolePermissionRequestBody: RequestBodyRepresentable {
    var contentMap: ContentMap {
        [
            .json: Content(AuthRolePermissionCreateSchema().reference())
        ]
    }
}
