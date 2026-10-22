import FeatherOpenAPI
import OpenAPIKit30

extension Credential.Patch {
    struct Schema: ObjectSchemaRepresentable {
        var openAPIIdentifier: String { "AuthCredentialPatchSchema" }
        var propertyMap: SchemaMap {
            [
                "userId": Credential.Schemas.UserID()
                    .reference(required: false),
                "email": Credential.Schemas.Email()
                    .reference(required: false),
                "password": Credential.Schemas.Password()
                    .reference(required: false),
            ]
        }
    }
}
