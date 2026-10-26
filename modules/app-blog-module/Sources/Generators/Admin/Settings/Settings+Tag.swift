import FeatherOpenAPI

extension Settings {
    struct Tag: TagRepresentable {
        var name: String = "BlogSettings"
        var description: String? = "Manage blog settings."
    }
}
