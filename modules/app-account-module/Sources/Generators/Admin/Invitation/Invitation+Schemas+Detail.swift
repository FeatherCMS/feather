import FeatherOpenAPI
import OpenAPIKit30

extension Invitation.Schemas {
    struct Detail: ObjectSchemaRepresentable {
        var propertyMap: SchemaMap {
            [
                "id": ID(),
                "email": Email(),
                "token": Token(),
                "roleIds": RoleIDs(),
                "expiresAt": ExpiresAt(),
            ]
        }
    }
}
