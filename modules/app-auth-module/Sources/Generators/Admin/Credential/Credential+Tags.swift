import FeatherOpenAPI

extension Credential {

    struct Tag: TagRepresentable {
        var name: String = "AuthCredentials"
        var description: String? = "Manage user credentials."
    }
}
