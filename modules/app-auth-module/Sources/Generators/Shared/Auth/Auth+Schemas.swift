import FeatherOpenAPI
import FeatherOpenAPIGenerator
import OpenAPIKit30
import UserSharedOpenAPIGenerator

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

struct UserAuthEmailField: StringSchemaRepresentable {
    var example: String? = "admin@example.com"
}

struct UserAuthPasswordField: StringSchemaRepresentable {
    var example: String? = "password"
}

public struct UserAuthSessionIdField: StringSchemaRepresentable {
    public var example: String? = "sess_3XbY..."

    public init() {}
}

// MARK: - objects

public struct AuthLoginRequestSchema: ObjectSchemaRepresentable {
    public var propertyMap: SchemaMap {
        [
            "email": UserAuthEmailField().reference(),
            "password": UserAuthPasswordField().reference(),
            "isPersistent": UserAuthIsPersistentField().reference(),
        ]
    }
}

public struct AuthUserIdentityDetailSchema: ObjectSchemaRepresentable {
    public var propertyMap: SchemaMap {
        [
            "id": UserIdentityIDField().reference(),
            "status": UserIdentityStatusField().reference(),
        ]
    }
}

public struct AuthResponseSchema: ObjectSchemaRepresentable {
    public var propertyMap: SchemaMap {
        [
            "user": AuthUserIdentityDetailSchema().reference(),
            "roles": UserIdentityRoleIDListSchema(),
            "permissions": UserIdentityPermissionIDListSchema(),
            "token": UserAuthTokenField().reference(),
        ]
    }
}

struct AuthMagicLinkRequestSchema: ObjectSchemaRepresentable {
    var propertyMap: SchemaMap {
        [
            "email": UserAuthEmailField(),
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
