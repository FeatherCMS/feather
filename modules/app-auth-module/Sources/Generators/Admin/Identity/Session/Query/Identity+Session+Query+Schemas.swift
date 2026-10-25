import FeatherOpenAPI
import UserOpenAPIGeneratorSupport

extension Identity.Session.Query {
    enum Schemas {}
}

extension Identity.Session.Query.Schemas {
    struct Item: ObjectSchemaRepresentable {
        var openAPIIdentifier: String {
            "UserIdentitySessionQueryItem"
        }

        var propertyMap: SchemaMap {
            [
                "id": IdentityIDField().reference(),
                "authenticationType": Identity.Session.Schemas
                    .AuthenticationType().reference(),
                "authenticationReference": Identity.Session.Schemas
                    .AuthenticationReference().reference(),
                "expiresAt": Identity.Session.Schemas.Timestamp().reference(),
                "isPersistent": Identity.Session.Schemas.Persistent()
                    .reference(),
                "createdAt": Identity.Session.Schemas.Timestamp().reference(),
                "updatedAt": Identity.Session.Schemas.Timestamp().reference(),
            ]
        }
    }
}
