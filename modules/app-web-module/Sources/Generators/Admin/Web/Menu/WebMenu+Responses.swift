import FeatherOpenAPI
import FeatherOpenAPIGenerator
import WebSharedOpenAPIGenerator

struct WebMenuDetailResponse: JSONResponseRepresentable {
    var description: String = "WebMenu response"
    var schema = WebMenuDetailSchema().reference()
}

struct WebMenuListResponse: JSONResponseRepresentable {
    var description: String = "WebMenu list response"
    var schema = WebMenuListSchema().reference()
}
