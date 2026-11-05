import FeatherOpenAPI

extension Account.Create {
    struct PasswordField: StringSchemaRepresentable {
        var openAPIIdentifier: String { "AccountCreatePasswordField" }
    }
}
