public import FeatherOpenAPI
import FeatherOpenAPIGenerator
import WebSharedOpenAPIGenerator

struct MenuItemDetailResponse: JSONResponseRepresentable {
    var description: String = "MenuItem response"
    var schema = MenuItemDetailSchema().reference()
}

struct MenuItemListResponse: JSONResponseRepresentable {
    var description: String = "MenuItem list response"
    var schema = MenuItemListSchema().reference()
}
