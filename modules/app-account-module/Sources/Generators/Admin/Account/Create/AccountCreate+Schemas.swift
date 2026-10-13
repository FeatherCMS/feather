import FeatherOpenAPI
import OpenAPIKit30

struct AccountCreateEmailField: StringSchemaRepresentable {}

struct AccountCreatePasswordField: StringSchemaRepresentable {}

struct AccountCreateUserIDField: StringSchemaRepresentable {}

struct AccountCreateSchema: ObjectSchemaRepresentable {
    var propertyMap: SchemaMap {
        [
            "email": AccountCreateEmailField().reference(),
            "password": AccountCreatePasswordField().reference(),
        ]
    }
}

struct AccountCreateResponseSchema: ObjectSchemaRepresentable {
    var propertyMap: SchemaMap {
        [
            "userId": AccountCreateUserIDField(),
            "email": AccountCreateEmailField(),
        ]
    }
}
