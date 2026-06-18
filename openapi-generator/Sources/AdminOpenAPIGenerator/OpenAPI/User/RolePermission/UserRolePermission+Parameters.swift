import FeatherOpenAPI

struct UserRolePermissionRoleIdParameter: PathParameterRepresentable {
    var name: String { "userRoleId" }
    var description: String? { "User role id" }
    var schema: any OpenAPISchemaRepresentable {
        UserRolePermissionRoleIdField().reference()
    }
}

struct UserRolePermissionPermissionIdParameter: PathParameterRepresentable {
    var name: String { "systemPermissionId" }
    var description: String? { "System permission id" }
    var schema: any OpenAPISchemaRepresentable {
        UserRolePermissionPermissionIdField().reference()
    }
}
