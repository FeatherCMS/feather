import FeatherOpenAPI

extension Menu {
    struct Tag: TagRepresentable {
        var name: String = "Menus"
        var description: String? = "Manage web menus."
    }
}
