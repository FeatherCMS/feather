import FeatherOpenAPI
import FeatherOpenAPIGenerator
import OpenAPIKit30
import UserOpenAPIGeneratorSupport

extension Identity.Session.Schemas {
    struct UserAuthSessionTimestampField: DoubleSchemaRepresentable {
        var openAPIIdentifier: String { "UserAuthSessionTimestampField" }
    }

    struct UserAuthSessionPersistentField: BoolSchemaRepresentable {
        var openAPIIdentifier: String { "UserAuthSessionPersistentField" }
    }

    struct UserAuthSessionAuthenticationTypeField: StringSchemaRepresentable {
        var openAPIIdentifier: String {
            "UserAuthSessionAuthenticationTypeField"
        }
    }

    struct UserAuthSessionAuthenticationReferenceField:
        StringSchemaRepresentable
    {
        var openAPIIdentifier: String {
            "UserAuthSessionAuthenticationReferenceField"
        }
    }

    struct UserAuthSessionListItemsField: ArraySchemaRepresentable {
        var openAPIIdentifier: String { "UserAuthSessionListItemsField" }

        var items: (any SchemaRepresentable)? {
            UserAuthSessionListItemSchema().reference()
        }
    }

    struct UserAuthSessionListItemSchema: ObjectSchemaRepresentable {
        var openAPIIdentifier: String { "UserAuthSessionListItemSchema" }

        var propertyMap: SchemaMap {
            [
                "id": UserIdentityIDField().reference(),
                "authenticationType":
                    UserAuthSessionAuthenticationTypeField().reference(),
                "authenticationReference":
                    UserAuthSessionAuthenticationReferenceField().reference(),
                "expiresAt": UserAuthSessionTimestampField().reference(),
                "isPersistent": UserAuthSessionPersistentField().reference(),
                "createdAt": UserAuthSessionTimestampField().reference(),
                "updatedAt": UserAuthSessionTimestampField().reference(),
            ]
        }
    }

    struct UserAuthSessionListSchema: ObjectSchemaRepresentable {
        var openAPIIdentifier: String { "UserAuthSessionListSchema" }

        var propertyMap: SchemaMap {
            [
                "items": UserAuthSessionListItemsField().reference()
            ]
        }
    }
}
