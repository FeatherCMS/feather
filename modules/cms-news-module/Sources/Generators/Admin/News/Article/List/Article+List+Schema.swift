import FeatherOpenAPI

extension Article.List {
    struct Schema: ArraySchemaRepresentable {
        var openAPIIdentifier: String { "NewsArticleListSchema" }
        var items: (any SchemaRepresentable)? { ItemSchema().reference() }
    }
}
