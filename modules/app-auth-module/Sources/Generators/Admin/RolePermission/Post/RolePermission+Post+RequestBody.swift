import FeatherOpenAPI
import OpenAPIKit30

extension RolePermission.Post {

    struct AuthRolePermissionRequestBody: RequestBodyRepresentable {
        var openAPIIdentifier: String { "AuthRolePermissionRequestBody" }
        var contentMap: ContentMap {
            [
                .json: Content(
                    RolePermission.Schemas.AuthRolePermissionCreateSchema()
                        .reference()
                )
            ]
        }
    }
}
