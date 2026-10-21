import FeatherOpenAPI
import UserOpenAPIGeneratorSupport

extension Identity.Put {
    struct Schema: ObjectSchemaRepresentable {
        var openAPIIdentifier: String { "UserIdentityUpdateSchema" }
        var propertyMap: SchemaMap {
            [
                "name": UserIdentityNameField().reference(required: false),
                "status": UserIdentityStatusField().reference(required: false),
                "roleIds": Identity.Schemas.RoleIDs()
                    .reference(
                        required: false
                    ),
            ]
        }
    }
}
