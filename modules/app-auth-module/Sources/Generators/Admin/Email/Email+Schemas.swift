import FeatherOpenAPI
import FeatherOpenAPIGenerator
import OpenAPIKit30

extension Email.Schemas {
    struct IDField: StringSchemaRepresentable {
        var example: String? = "email_7nL3xQ2v"
    }

    struct IdentityIDField: StringSchemaRepresentable {
        var example: String? = "user_7nL3xQ2v"
    }

    struct EmailField: StringSchemaRepresentable {
        var example: String? = "john.doe@example.com"
        var format: String? = "email"
    }

    struct UpdateMask: StringSchemaRepresentable {
        var example: String? = "identityId,email"
    }

    struct Create: ObjectSchemaRepresentable {
        var propertyMap: SchemaMap {
            [
                "identityId": IdentityIDField().reference(),
                "email": EmailField().reference(),
            ]
        }
    }

    struct Patch: ObjectSchemaRepresentable {
        var propertyMap: SchemaMap {
            [
                "identityId": IdentityIDField().reference(required: false),
                "email": EmailField().reference(required: false),
            ]
        }
    }

    struct Detail: ObjectSchemaRepresentable {
        var propertyMap: SchemaMap {
            [
                "id": IDField().reference(),
                "identityId": IdentityIDField().reference(),
                "email": EmailField().reference(),
            ]
        }
    }

    struct List: ArraySchemaRepresentable {
        var items: (any SchemaRepresentable)? { Detail().reference() }
    }
}

extension Email.Query.Schemas {
    struct Item: ObjectSchemaRepresentable {
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
