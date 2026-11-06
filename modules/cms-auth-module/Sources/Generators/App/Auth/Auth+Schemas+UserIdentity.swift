import FeatherOpenAPI
import FeatherOpenAPIGenerator

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
