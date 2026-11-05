import FeatherOpenAPI

extension Identity.Schemas {
    struct UpdateMask: StringSchemaRepresentable {
        var openAPIIdentifier: String { "UserIdentityUpdateMask" }
        var example: String? = "name,status,roleIds"
    }
}
