import FeatherOpenAPI

struct SystemPermissionIDParameter: PathParameterRepresentable {
    var name: String { "systemPermissionId" }
    var description: String? { "SystemPermission id" }
    var schema: any OpenAPISchemaRepresentable {
        SystemPermissionIDField().reference()
    }
}
