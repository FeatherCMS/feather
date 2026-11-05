import FeatherOpenAPI

extension Identity.Session.List {
    struct Items: ArraySchemaRepresentable {
        var openAPIIdentifier: String { "UserAuthSessionListItemsField" }

        var items: (any SchemaRepresentable)? {
            Item().reference()
        }
    }

    struct Item: ObjectSchemaRepresentable {
        var openAPIIdentifier: String { "UserAuthSessionListItemSchema" }

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

    struct Schema: ObjectSchemaRepresentable {
        var openAPIIdentifier: String { "UserAuthSessionListSchema" }

        var propertyMap: SchemaMap {
            ["items": Items().reference()]
        }
    }
}
