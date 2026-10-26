import FeatherOpenAPI

extension Role.Schemas {
    struct UpdateMask: StringSchemaRepresentable {
        var openAPIIdentifier: String { "UserRoleUpdateMask" }
        var example: String? = "name,notes"
    }
}
