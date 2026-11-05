import FeatherOpenAPI

extension Role.Schemas {
    struct ID: StringSchemaRepresentable {
        var openAPIIdentifier: String { "UserRoleIdField" }
        var example: String? = "role_manager"
    }
}
