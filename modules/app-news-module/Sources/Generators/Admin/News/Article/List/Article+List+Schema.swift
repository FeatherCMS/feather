import FeatherOpenAPI
import OpenAPIKit30

extension Article.List {
    struct Schema: ArraySchemaRepresentable {
        var openAPIIdentifier: String { "NewsArticleListSchema" }
        var items: (any SchemaRepresentable)? { ItemSchema().reference() }
    }
}
