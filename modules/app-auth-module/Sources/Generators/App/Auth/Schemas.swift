import FeatherOpenAPI
import FeatherOpenAPIGenerator
import OpenAPIKit30
import UserOpenAPIGeneratorSupport

extension Auth {
    enum Schemas {}
}

extension Auth.Schemas {
    struct EmailField: StringSchemaRepresentable {
        var example: String? = "admin@example.com"
    }

    struct PasswordField: StringSchemaRepresentable {
        var example: String? = "password"
    }

    struct IsPersistentField: BoolSchemaRepresentable {
        var example: Bool? = true
    }

    struct MagicLinkTokenField: StringSchemaRepresentable {
        var example: String? = "mgl_3XbY..."
    }

    struct UserIdentity: ObjectSchemaRepresentable {
        var propertyMap: SchemaMap {
            [
                "id": IdentityIDField().reference(),
                "status": IdentityStatusField().reference(),
            ]
        }
    }

    struct Response: ObjectSchemaRepresentable {
        var propertyMap: SchemaMap {
            [
                "user": UserIdentity().reference(),
                "roles": IdentityRoleIDListSchema(),
                "permissions": IdentityPermissionIDListSchema(),
                "token": TokenField().reference(),
            ]
        }
    }

    struct TokenField: StringSchemaRepresentable {
        var example: String? =
            "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9..."
    }
}
