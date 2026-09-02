import FeatherOpenAPI
import FeatherOpenAPIGenerator
import WebSharedOpenAPIGenerator

struct WebMenuItemDetailResponse: JSONResponseRepresentable {
    var description: String = "WebMenuItem response"
    var schema = WebMenuItemDetailSchema().reference()
}

struct WebMenuItemListResponse: JSONResponseRepresentable {
    var description: String = "WebMenuItem list response"
    var schema = WebMenuItemListSchema().reference()
}
