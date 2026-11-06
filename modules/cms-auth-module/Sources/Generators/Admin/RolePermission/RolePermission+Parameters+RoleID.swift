import FeatherOpenAPI

extension RolePermission.Parameters {
    struct RoleID: PathParameterRepresentable {
        var openAPIIdentifier: String { "AuthRolePermissionRoleIdParameter" }
        var name: String { "userRoleId" }
        var description: String? { "User role id" }
        var schema: any OpenAPISchemaRepresentable {
            RolePermission.Schemas.RoleID().reference()
        }
    }
}
