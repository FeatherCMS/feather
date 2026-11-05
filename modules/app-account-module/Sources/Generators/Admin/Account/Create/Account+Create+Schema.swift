import FeatherOpenAPI

extension Account.Create {
    struct Schema: ObjectSchemaRepresentable {
        var openAPIIdentifier: String { "AccountCreateSchema" }
        var propertyMap: SchemaMap {
            [
                "email": EmailField().reference(),
                "password": PasswordField().reference(),
            ]
        }
    }
}
