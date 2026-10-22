import FeatherOpenAPI

extension Settings {
    struct Tag: TagRepresentable {
        var name: String = "AccountSettings"
        var description: String? = "Manage account settings."
    }
}
