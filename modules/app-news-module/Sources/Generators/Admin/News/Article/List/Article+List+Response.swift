import FeatherOpenAPI
import FeatherOpenAPIGenerator

extension Article.List {
    struct Response: JSONResponseRepresentable {
        var openAPIIdentifier: String { "NewsArticleListResponse" }
        var description: String = "News article list response"
        var schema = Schema().reference()
    }
}
