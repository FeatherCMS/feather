public import FeatherOpenAPI
import FeatherOpenAPIGenerator
import WebSharedOpenAPIGenerator

struct PageDetailResponse: JSONResponseRepresentable {
    var description: String = "Page response"
    var schema = PageDetailSchema().reference()
}

struct PageListResponse: JSONResponseRepresentable {
    var description: String = "Page list response"
    var schema = PageListSchema().reference()
}
