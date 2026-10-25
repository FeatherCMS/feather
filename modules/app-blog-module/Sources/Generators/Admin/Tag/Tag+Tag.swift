import FeatherOpenAPI

extension Tag {
    struct Tag: TagRepresentable {
        var name: String = "BlogTags"
        var description: String? = "Manage blog tags."
    }
}
