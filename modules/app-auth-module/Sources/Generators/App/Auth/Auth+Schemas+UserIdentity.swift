import FeatherOpenAPI
import FeatherOpenAPIGenerator
import OpenAPIKit30
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
