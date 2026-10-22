import FeatherOpenAPI
import UserOpenAPIGeneratorSupport

extension Identity.Put {
    struct Schema: ObjectSchemaRepresentable {
        var openAPIIdentifier: String { "UserIdentityUpdateSchema" }
        var propertyMap: SchemaMap {
            [
                "name": IdentityNameField().reference(required: false),
                "status": IdentityStatusField().reference(required: false),
                "roleIds": Identity.Schemas.RoleIDs()
                    .reference(
                        required: false
                    ),
            ]
        }
    }
}
