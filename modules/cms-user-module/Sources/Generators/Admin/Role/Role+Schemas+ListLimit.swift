import FeatherOpenAPI

extension Role.Schemas {
    struct ListLimit: IntSchemaRepresentable {
        var openAPIIdentifier: String { "UserRoleListLimit" }
        var description: String? {
            "Maximum number of roles. Defaults to 20; values are clamped to 1-100."
        }
        var defaultValue: Int? = 20
        var example: Int? = 100
    }
}
