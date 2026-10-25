import FeatherOpenAPI

extension MenuItem {
    struct Tag: TagRepresentable {
        var name: String = "MenuItems"
        var description: String? = "Manage web menu items."
    }
}
