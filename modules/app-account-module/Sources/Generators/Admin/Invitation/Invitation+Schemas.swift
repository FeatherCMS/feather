import FeatherOpenAPI
import OpenAPIKit30

extension Invitation.Schemas {
    struct ID: StringSchemaRepresentable {
        var example: String? = "inv_7nL3xQ2v"
    }

    struct Email: StringSchemaRepresentable {
        var example: String? = "john.doe@example.com"
    }

    struct Token: StringSchemaRepresentable {
        var example: String? = "eyJhbGciOi..."
    }

    struct RoleIDs: ArraySchemaRepresentable {
        var items: (any SchemaRepresentable)? { RoleID() }
    }

    struct RoleID: StringSchemaRepresentable {}

    struct ExpiresAt: DoubleSchemaRepresentable {
        var example: Double? { 1_760_000_000 }
    }

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
