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

extension RolePermission.Parameters {

    struct PermissionID: PathParameterRepresentable {
        var openAPIIdentifier: String {
            "AuthRolePermissionPermissionIdParameter"
        }
        var name: String { "systemPermissionId" }
        var description: String? { "System permission id" }
        var schema: any OpenAPISchemaRepresentable {
            RolePermission.Schemas.PermissionID()
                .reference()
        }
    }
}
