import FeatherOpenAPI
import FeatherOpenAPIGenerator
import OpenAPIKit30

public struct UserAuthTokenField: StringSchemaRepresentable {
    public var example: String? = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9..."
    public init() {}
}

public struct UserAuthResponseSchema: ObjectSchemaRepresentable {
    public var propertyMap: SchemaMap {
        [
            "user": UserIdentityDetailSchema().reference(),
            "roles": UserIdentityRoleIDListSchema(),
            "permissions": UserIdentityPermissionIDListSchema(),
            "token": UserAuthTokenField().reference(),
        ]
    }

    public init() {}
}

public struct AuthMeResponse: JSONResponseRepresentable {
    public var description: String = "Auth response"
    public var schema = UserAuthResponseSchema().reference()
    public init() {}
}

public struct AuthTag: TagRepresentable {
    public var name: String = "Auth"
    public var description: String? = "Authentication endpoints."
    public init() {}
}
