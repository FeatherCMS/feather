import FeatherOpenAPI
import FeatherOpenAPIGenerator

extension Auth.Schemas {
    struct SignInResponse: ObjectSchemaRepresentable {
        var propertyMap: SchemaMap {
            [
                "user": UserIdentity().reference(),
                "roles": IdentityRoleIDListSchema(),
                "permissions": IdentityPermissionIDListSchema(),
                "token": TokenField().reference(),
                "isPersistent": IsPersistentField(),
                "expiresAt": SessionExpiresAtField(),
            ]
        }
    }
}
