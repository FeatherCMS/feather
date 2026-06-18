import FeatherOpenAPI
import OpenAPIKit30

// MARK: - fields
struct UserAuthIsPersistentField: BoolSchemaRepresentable {
    var example: Bool? = true
}

struct UserAuthTokenField: StringSchemaRepresentable {
    var example: String? = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9..."
}

struct UserAuthMagicLinkTokenField: StringSchemaRepresentable {
    var example: String? = "mgl_3XbY..."
}

public struct UserAuthSessionIDField: StringSchemaRepresentable {
    public var example: String? = "sess_3XbY..."

    public init() {}
}

// MARK: - objects

public struct AuthLoginRequestSchema: ObjectSchemaRepresentable {
    public var propertyMap: SchemaMap {
        [
            "email": UserAccountEmailField().reference(),
            "password": UserAccountPasswordField().reference(),
            "isPersistent": UserAuthIsPersistentField().reference(),
        ]
    }
}

public struct AuthResponseSchema: ObjectSchemaRepresentable {
    public var propertyMap: SchemaMap {
        [
            "user": UserAccountDetailSchema().reference(),
            "roles": UserAccountRoleIDListSchema(),
            "permissions": UserAccountPermissionIDListSchema(),
            "token": UserAuthTokenField().reference(),
        ]
    }
}

struct AuthMagicLinkRequestSchema: ObjectSchemaRepresentable {
    var propertyMap: SchemaMap {
        [
            "email": UserAccountEmailField(),
            "isPersistent": UserAuthIsPersistentField(),
        ]
    }
}

struct AuthMagicLinkVerifyRequestSchema: ObjectSchemaRepresentable {
    var propertyMap: SchemaMap {
        [
            "token": UserAuthMagicLinkTokenField()
        ]
    }
}
