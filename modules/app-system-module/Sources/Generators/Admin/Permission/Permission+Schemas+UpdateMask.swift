import FeatherOpenAPI

extension Permission.Schemas {
    struct UpdateMask: StringSchemaRepresentable {
        var openAPIIdentifier: String { "SystemPermissionUpdateMask" }
        var example: String? = "key,name,notes"
    }
}
