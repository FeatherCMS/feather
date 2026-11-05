import FeatherOpenAPI
import FeatherOpenAPIGenerator

extension Auth.Schemas {
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
}
