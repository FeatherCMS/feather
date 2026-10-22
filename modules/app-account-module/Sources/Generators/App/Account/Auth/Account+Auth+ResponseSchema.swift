import FeatherOpenAPI
import UserOpenAPIGeneratorSupport

extension Account.Auth {
    public struct ResponseSchema: ObjectSchemaRepresentable {
        public var openAPIIdentifier: String { "AccountAuthResponseSchema" }
        public var propertyMap: SchemaMap {
            [
                "user": UserIdentityDetailSchema().reference(),
                "roles": UserIdentityRoleIDListSchema(),
                "permissions": UserIdentityPermissionIDListSchema(),
                "token": TokenField().reference(),
            ]
        }

        public init() {}
    }
}
