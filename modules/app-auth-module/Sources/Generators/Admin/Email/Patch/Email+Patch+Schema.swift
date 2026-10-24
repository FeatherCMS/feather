import FeatherOpenAPI
import OpenAPIKit30

extension Email.Patch {
    struct Schema: ObjectSchemaRepresentable {
        var openAPIIdentifier: String { "AuthEmailSchemasPatch" }
        var propertyMap: SchemaMap {
            [
                "identityId": Email.Schemas.IdentityIDField()
                    .reference(required: false),
                "email": Email.Schemas.EmailField()
                    .reference(required: false),
            ]
        }
    }
}
