import FeatherOpenAPI

extension AuthorLink {
    struct Tag: TagRepresentable {
        var name: String = "BlogAuthorLinks"
        var description: String? = "Manage blog author links."
    }
}
