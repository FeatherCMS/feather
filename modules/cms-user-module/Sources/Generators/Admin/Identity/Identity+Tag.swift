import FeatherOpenAPI

extension Identity {
    struct Tag: TagRepresentable {
        var name: String { "UserIdentities" }
        var description: String? { "User identities related endpoints." }
    }
}
