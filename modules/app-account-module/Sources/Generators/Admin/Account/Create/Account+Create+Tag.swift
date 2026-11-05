import FeatherOpenAPI

extension Account.Create {
    struct Tag: TagRepresentable {
        var name: String = "Accounts"
        var description: String? = "Create user accounts."
    }
}
