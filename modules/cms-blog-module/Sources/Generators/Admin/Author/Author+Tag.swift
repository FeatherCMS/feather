import FeatherOpenAPI

extension Author {
    struct Tag: TagRepresentable {
        var name: String = "BlogAuthors"
        var description: String? = "Manage blog authors."
    }
}
