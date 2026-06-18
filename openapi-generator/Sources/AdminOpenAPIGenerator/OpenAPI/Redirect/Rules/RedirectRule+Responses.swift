import FeatherOpenAPI
import SharedOpenAPIComponents

struct RedirectRuleDetailResponse: JSONResponseRepresentable {
    var description: String = "RedirectRule response"
    var schema = RedirectRuleDetailSchema().reference()
}

struct RedirectRuleListResponse: JSONResponseRepresentable {
    var description: String = "RedirectRule list response"
    var schema = RedirectRuleListSchema().reference()
}

struct RedirectRuleFiltersResponse: JSONResponseRepresentable {
    var description: String = "RedirectRule filter response"
    var schema = SearchFilterSchema().reference()
}
