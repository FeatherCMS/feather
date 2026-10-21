import FeatherOpenAPI
import FeatherOpenAPIGenerator

struct RedirectRuleDetailResponse: JSONResponseRepresentable {
    var description: String = "RedirectRule response"
    var schema = RedirectRuleDetailSchema().reference()
}

struct RedirectRuleListResponse: JSONResponseRepresentable {
    var description: String = "RedirectRule list response"
    var schema = RedirectRuleListSchema().reference()
}
