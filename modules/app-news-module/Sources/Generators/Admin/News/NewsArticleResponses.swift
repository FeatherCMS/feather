import FeatherOpenAPI
import FeatherOpenAPIGenerator

struct NewsArticleDetailResponse: JSONResponseRepresentable {
    var description: String = "News article response"
    var schema = NewsArticleDetailSchema().reference()
}

struct NewsArticleListResponse: JSONResponseRepresentable {
    var description: String = "News article list response"
    var schema = NewsArticleListSchema().reference()
}
