import FeatherOpenAPI

struct AuthRolePermissionRoleIdParameter: PathParameterRepresentable {
    var name: String { "userRoleId" }
    var description: String? { "User role id" }
    var schema: any OpenAPISchemaRepresentable {
        AuthRolePermissionRoleIdField().reference()
    }
}

struct AuthRolePermissionPermissionIdParameter: PathParameterRepresentable {
    var name: String { "systemPermissionId" }
    var description: String? { "System permission id" }
    var schema: any OpenAPISchemaRepresentable {
        AuthRolePermissionPermissionIdField().reference()
    }
}
