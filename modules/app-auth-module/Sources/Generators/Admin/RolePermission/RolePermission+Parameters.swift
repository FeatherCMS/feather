import FeatherOpenAPI

extension RolePermission.Parameters {

    struct AuthRolePermissionRoleIdParameter: PathParameterRepresentable {
        var openAPIIdentifier: String { "AuthRolePermissionRoleIdParameter" }
        var name: String { "userRoleId" }
        var description: String? { "User role id" }
        var schema: any OpenAPISchemaRepresentable {
            RolePermission.Schemas.AuthRolePermissionRoleIdField().reference()
        }
    }
}

extension RolePermission.Parameters {

    struct AuthRolePermissionPermissionIdParameter: PathParameterRepresentable {
        var openAPIIdentifier: String {
            "AuthRolePermissionPermissionIdParameter"
        }
        var name: String { "systemPermissionId" }
        var description: String? { "System permission id" }
        var schema: any OpenAPISchemaRepresentable {
            RolePermission.Schemas.AuthRolePermissionPermissionIdField()
                .reference()
        }
    }
}
