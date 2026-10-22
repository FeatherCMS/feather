import FeatherOpenAPI
import FeatherOpenAPIGenerator
import OpenAPIKit30

extension Email.Schemas {
    struct IDField: StringSchemaRepresentable {
        var openAPIIdentifier: String { "AuthEmailSchemasIDField" }
        var example: String? = "email_7nL3xQ2v"
    }

    struct IdentityIDField: StringSchemaRepresentable {
        var openAPIIdentifier: String { "AuthEmailSchemasIdentityIDField" }
        var example: String? = "user_7nL3xQ2v"
    }

    struct EmailField: StringSchemaRepresentable {
        var openAPIIdentifier: String { "AuthEmailSchemasEmailField" }
        var example: String? = "john.doe@example.com"
        var format: String? = "email"
    }

    struct UpdateMask: StringSchemaRepresentable {
        var openAPIIdentifier: String { "AuthEmailSchemasUpdateMask" }
        var example: String? = "identityId,email"
    }

    struct Create: ObjectSchemaRepresentable {
        var openAPIIdentifier: String { "AuthEmailSchemasCreate" }
        var propertyMap: SchemaMap {
            [
                "identityId": IdentityIDField().reference(),
                "email": EmailField().reference(),
            ]
        }
    }

    struct Patch: ObjectSchemaRepresentable {
        var openAPIIdentifier: String { "AuthEmailSchemasPatch" }
        var propertyMap: SchemaMap {
            [
                "identityId": IdentityIDField().reference(required: false),
                "email": EmailField().reference(required: false),
            ]
        }
    }

    struct Detail: ObjectSchemaRepresentable {
        var openAPIIdentifier: String { "AuthEmailSchemasDetail" }
        var propertyMap: SchemaMap {
            [
                "id": IDField().reference(),
                "identityId": IdentityIDField().reference(),
                "email": EmailField().reference(),
            ]
        }
    }

    struct List: ArraySchemaRepresentable {
        var openAPIIdentifier: String { "AuthEmailSchemasList" }
        var items: (any SchemaRepresentable)? { Detail().reference() }
    }
}

extension Email.Query.Schemas {
    struct Item: ObjectSchemaRepresentable {
        var openAPIIdentifier: String { "AuthEmailQuerySchemasItem" }
        var propertyMap: SchemaMap {
            [
                "id": Email.Schemas.IDField().reference(),
                "identityId": Email.Schemas.IdentityIDField()
                    .reference(),
                "email": Email.Schemas.EmailField().reference(),
            ]
        }
    }

}
