import FeatherOpenAPI

extension Account.Create {
    struct EmailField: StringSchemaRepresentable {
        var openAPIIdentifier: String { "AccountCreateEmailField" }
    }
}
