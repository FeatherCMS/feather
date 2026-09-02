import FeatherOpenAPI
import FeatherOpenAPIGenerator
import WebSharedOpenAPIGenerator

struct WebPageDetailResponse: JSONResponseRepresentable {
    var description: String = "WebPage response"
    var schema = WebPageDetailSchema().reference()
}

struct WebPageListResponse: JSONResponseRepresentable {
    var description: String = "WebPage list response"
    var schema = WebPageListSchema().reference()
}
