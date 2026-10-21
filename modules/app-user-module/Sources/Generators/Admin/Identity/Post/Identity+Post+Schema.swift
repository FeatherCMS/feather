import FeatherOpenAPI
import UserOpenAPIGeneratorSupport

extension Identity.Post {
    struct Schema: ObjectSchemaRepresentable {
        var openAPIIdentifier: String { "UserIdentityCreateSchema" }
        var propertyMap: SchemaMap {
            [
                "name": UserIdentityNameField().reference(),
                "status": UserIdentityStatusField().reference(required: false),
                "roleIds": Identity.Schemas.RoleIDs()
                    .reference(
                        required: false
                    ),
            ]
        }
    }
}
