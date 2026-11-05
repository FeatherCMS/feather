import FeatherOpenAPI

extension Account.Create {
    struct UserIDField: StringSchemaRepresentable {
        var openAPIIdentifier: String { "AccountCreateUserIDField" }
    }
}
