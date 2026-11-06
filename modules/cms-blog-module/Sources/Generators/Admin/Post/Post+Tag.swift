import FeatherOpenAPI

extension Post {
    struct Tag: TagRepresentable {
        var name: String = "BlogPosts"
        var description: String? = "Manage blog posts."
    }
}
