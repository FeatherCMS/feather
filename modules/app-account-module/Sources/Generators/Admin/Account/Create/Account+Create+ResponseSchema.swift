import FeatherOpenAPI

extension Account.Create {
    struct ResponseSchema: ObjectSchemaRepresentable {
        var openAPIIdentifier: String { "AccountCreateResponseSchema" }
        var propertyMap: SchemaMap {
            [
                "userId": UserIDField(),
                "email": EmailField(),
            ]
        }
    }
}
