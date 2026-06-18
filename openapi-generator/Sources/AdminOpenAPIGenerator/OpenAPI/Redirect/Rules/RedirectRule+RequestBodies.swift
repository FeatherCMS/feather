import FeatherOpenAPI
import OpenAPIKit30

struct RedirectRuleRequestBody: RequestBodyRepresentable {
    var contentMap: ContentMap {
        [
            .json: Content(RedirectRuleCreateSchema().reference())
        ]
    }
}

struct RedirectRuleUpdateRequestBody: RequestBodyRepresentable {
    var contentMap: ContentMap {
        [
            .json: Content(RedirectRuleCreateSchema().reference())
        ]
    }
}

struct RedirectRulePatchRequestBody: RequestBodyRepresentable {
    var contentMap: ContentMap {
        [
            .json: Content(RedirectRulePatchSchema().reference())
        ]
    }
}
