import FeatherOpenAPI

struct UserRoleIdParameter: PathParameterRepresentable {
    var name: String { "userRoleId" }
    var description: String? { "UserRole id" }
    var schema: any OpenAPISchemaRepresentable { UserRoleIdField().reference() }
}
