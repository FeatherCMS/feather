import FeatherOpenAPI

extension Account {
    struct Tag: TagRepresentable {
        var name: String = "Account"
        var description: String? = "Account endpoints."
    }
}
