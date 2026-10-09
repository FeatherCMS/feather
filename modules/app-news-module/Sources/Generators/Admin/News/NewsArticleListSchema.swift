import FeatherOpenAPI
import OpenAPIKit30

struct NewsArticleListSchema: ArraySchemaRepresentable {
    var items: (any SchemaRepresentable)? {
        NewsArticleListItemSchema().reference()
    }
}
