import FeatherOpenAPI

extension Invitation.Schemas {
    struct RoleIDs: ArraySchemaRepresentable {
        var items: (any SchemaRepresentable)? { RoleID() }
    }
}
