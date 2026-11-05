import FeatherOpenAPI

extension Invitation {
    struct Tag: TagRepresentable {
        var name: String = "AccountInvitations"
        var description: String? = "Manage user invitations."
    }
}
