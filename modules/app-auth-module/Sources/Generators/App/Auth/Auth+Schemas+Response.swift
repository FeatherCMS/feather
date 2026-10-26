import FeatherOpenAPI
import FeatherOpenAPIGenerator
import UserOpenAPIGeneratorSupport

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
