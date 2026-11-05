import FeatherOpenAPI

extension Role.Schemas {
    struct Name: StringSchemaRepresentable {
        var openAPIIdentifier: String { "UserRoleNameField" }
        var example: String? = "manager"
    }
}
