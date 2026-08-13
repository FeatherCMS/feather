import FeatherOpenAPI

struct BlogPostTag: TagRepresentable {
    var name: String = "BlogPosts"
    var description: String? = "Manage blog posts."
}
