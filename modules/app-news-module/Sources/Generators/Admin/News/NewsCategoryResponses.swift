import FeatherOpenAPI
import FeatherOpenAPIGenerator

struct NewsCategoryDetailResponse: JSONResponseRepresentable {
    var description: String = "News category response"
    var schema = NewsCategoryDetailSchema().reference()
}

struct NewsCategoryListResponse: JSONResponseRepresentable {
    var description: String = "News category list response"
    var schema = NewsCategoryListSchema().reference()
}
