public import FeatherOpenAPI

extension Page {
    struct Tag: TagRepresentable {
        var name: String = "Pages"
        var description: String? = "Manage web pages."
    }
}
