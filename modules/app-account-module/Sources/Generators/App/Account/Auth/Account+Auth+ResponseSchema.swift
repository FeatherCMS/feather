import FeatherOpenAPI

extension Account.Auth {
    public struct ResponseSchema: ObjectSchemaRepresentable {
        public var openAPIIdentifier: String { "AccountAuthResponseSchema" }
        public var propertyMap: SchemaMap {
            [
                "user": IdentityDetailSchema().reference(),
                "roles": IdentityRoleIDListSchema(),
                "permissions": IdentityPermissionIDListSchema(),
                "token": TokenField().reference(),
            ]
        }

        public init() {}
    }
}
