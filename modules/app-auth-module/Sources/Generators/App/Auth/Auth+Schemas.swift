import FeatherOpenAPI
import FeatherOpenAPIGenerator
import OpenAPIKit30

struct AuthEmailField: StringSchemaRepresentable {
    var example: String? = "admin@example.com"
}

struct AuthPasswordField: StringSchemaRepresentable {
    var example: String? = "password"
}

struct AuthIsPersistentField: BoolSchemaRepresentable {
    var example: Bool? = true
}

struct AuthMagicLinkTokenField: StringSchemaRepresentable {
    var example: String? = "mgl_3XbY..."
}

struct AuthLoginRequestSchema: ObjectSchemaRepresentable {
    var propertyMap: SchemaMap {
        [
            "email": AuthEmailField().reference(),
            "password": AuthPasswordField().reference(),
            "isPersistent": AuthIsPersistentField().reference(),
        ]
    }
}

struct AuthMagicLinkRequestSchema: ObjectSchemaRepresentable {
    var propertyMap: SchemaMap {
        [
            "email": AuthEmailField(),
            "isPersistent": AuthIsPersistentField(),
        ]
    }
}

struct AuthMagicLinkVerifyRequestSchema: ObjectSchemaRepresentable {
    var propertyMap: SchemaMap {
        [
            "token": AuthMagicLinkTokenField()
        ]
    }
}
