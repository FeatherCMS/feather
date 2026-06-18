import FeatherOpenAPI
import OpenAPIKit30

struct UserRolePermissionRequestBody: RequestBodyRepresentable {
    var contentMap: ContentMap {
        [
            .json: Content(UserRolePermissionCreateSchema().reference())
        ]
    }
}
