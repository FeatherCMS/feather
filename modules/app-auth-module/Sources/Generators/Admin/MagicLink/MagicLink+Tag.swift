import FeatherOpenAPI

extension MagicLink {

    struct Tag: TagRepresentable {
        var name: String = "AuthMagicLinks"
        var description: String? = "Manage user magic links."
    }
}
