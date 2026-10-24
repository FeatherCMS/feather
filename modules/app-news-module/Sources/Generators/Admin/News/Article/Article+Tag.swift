import FeatherOpenAPI

extension Article {
    struct Tag: TagRepresentable {
        var name: String = "NewsArticles"
        var description: String? = "Manage news articles."
    }
}
