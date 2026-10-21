import FeatherOpenAPI

extension Identity.Schemas {
    struct RoleIDs: ArraySchemaRepresentable {
        var openAPIIdentifier: String { "UserIdentityRoleIdsField" }
        var items: (any SchemaRepresentable)? {
            Role.Schemas.ID().reference()
        }
    }

    struct RoleNames: ArraySchemaRepresentable {
        var openAPIIdentifier: String { "UserIdentityRoleNamesField" }
        var items: (any SchemaRepresentable)? {
            Role.Schemas.Name().reference()
        }
    }
}
