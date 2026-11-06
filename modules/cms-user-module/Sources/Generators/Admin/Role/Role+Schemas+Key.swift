import FeatherOpenAPI

extension Role.Schemas {
    struct Key: StringSchemaRepresentable {
        var openAPIIdentifier: String { "UserRoleKeyField" }
        var example: String? = "editor"
    }
}
