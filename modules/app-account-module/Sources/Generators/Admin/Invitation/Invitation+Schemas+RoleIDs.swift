import FeatherOpenAPI
import OpenAPIKit30

extension Invitation.Schemas {
    struct RoleIDs: ArraySchemaRepresentable {
        var items: (any SchemaRepresentable)? { RoleID() }
    }
}
