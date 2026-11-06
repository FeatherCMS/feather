import FeatherOpenAPI

extension Permission.Parameters {
    struct ID: PathParameterRepresentable {
        var openAPIIdentifier: String { "SystemPermissionIDParameter" }
        var name: String { "systemPermissionId" }
        var description: String? { "SystemPermission ID" }
        var schema: any OpenAPISchemaRepresentable {
            Permission.Schemas.ID().reference()
        }
    }
}
