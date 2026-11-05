import FeatherOpenAPI
import FeatherOpenAPIGenerator

extension Article.Get {
    struct Response: JSONResponseRepresentable {
        var openAPIIdentifier: String { "NewsArticleDetailResponse" }
        var description: String = "News article response"
        var schema = Schema().reference()
    }
}
