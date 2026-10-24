public import FeatherOpenAPI
import FeatherOpenAPIGenerator
import WebOpenAPIGeneratorSupport

struct MenuDetailResponse: JSONResponseRepresentable {
    var description: String = "Menu response"
    var schema = MenuDetailSchema().reference()
}

struct MenuListResponse: JSONResponseRepresentable {
    var description: String = "Menu list response"
    var schema = MenuListSchema().reference()
}
