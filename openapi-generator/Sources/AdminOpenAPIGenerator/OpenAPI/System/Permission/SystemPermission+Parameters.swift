import FeatherOpenAPI

struct SystemPermissionIdParameter: PathParameterRepresentable {
    var name: String { "systemPermissionId" }
    var description: String? { "SystemPermission id" }
    var schema: any OpenAPISchemaRepresentable {
        SystemPermissionIdField().reference()
    }
}
