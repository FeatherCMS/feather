import FeatherOpenAPI

extension News {
    struct Tag: TagRepresentable {
        var name: String = "News"
        var description: String? = "News public content"
    }
}
