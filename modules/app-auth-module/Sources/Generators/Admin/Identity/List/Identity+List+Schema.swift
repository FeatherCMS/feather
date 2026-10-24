import FeatherOpenAPI
import OpenAPIKit30
import UserOpenAPIGeneratorSupport

extension Identity.Session.List {
    struct Timestamp: DoubleSchemaRepresentable {
        var openAPIIdentifier: String { "UserAuthSessionTimestampField" }
    }

    struct Persistent: BoolSchemaRepresentable {
        var openAPIIdentifier: String { "UserAuthSessionPersistentField" }
    }

    struct AuthenticationType: StringSchemaRepresentable {
        var openAPIIdentifier: String {
            "UserAuthSessionAuthenticationTypeField"
        }
    }

    struct AuthenticationReference: StringSchemaRepresentable {
        var openAPIIdentifier: String {
            "UserAuthSessionAuthenticationReferenceField"
        }
    }

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
                "authenticationType": AuthenticationType().reference(),
                "authenticationReference": AuthenticationReference()
                    .reference(),
                "expiresAt": Timestamp().reference(),
                "isPersistent": Persistent().reference(),
                "createdAt": Timestamp().reference(),
                "updatedAt": Timestamp().reference(),
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
