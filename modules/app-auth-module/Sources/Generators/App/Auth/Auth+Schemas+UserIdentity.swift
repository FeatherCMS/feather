import FeatherOpenAPI
import FeatherOpenAPIGenerator
import UserOpenAPIGeneratorSupport

extension Auth.Schemas {
    struct UserIdentity: ObjectSchemaRepresentable {
        var propertyMap: SchemaMap {
            [
                "id": IdentityIDField().reference(),
                "status": IdentityStatusField().reference(),
            ]
        }
    }
}
