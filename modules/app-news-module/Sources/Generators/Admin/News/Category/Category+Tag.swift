import FeatherOpenAPI

extension Category {
    struct Tag: TagRepresentable {
        var name: String = "NewsCategories"
        var description: String? = "Manage news categories."
    }
}
