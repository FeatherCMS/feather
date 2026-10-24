import FeatherOpenAPI

extension Identity.Schemas {
    struct RoleIDList: ArraySchemaRepresentable {
        var openAPIIdentifier: String { "UserIdentityRoleIDListSchema" }
        var items: (any SchemaRepresentable)? { RoleID() }
    }
}
