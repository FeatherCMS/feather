import FeatherOpenAPI

extension Identity.Schemas {
    struct RoleNames: ArraySchemaRepresentable {
        var openAPIIdentifier: String { "UserIdentityRoleNamesField" }
        var items: (any SchemaRepresentable)? {
            Role.Schemas.Name().reference()
        }
    }
}
