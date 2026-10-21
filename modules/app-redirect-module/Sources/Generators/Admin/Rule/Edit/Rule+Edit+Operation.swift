import FeatherOpenAPI
import FeatherOpenAPIGenerator

struct RedirectRuleUpdateOperation: RedirectRuleIDOperation {
    var operationId: String? { "redirectRuleUpdate" }

    var requestBody: (any RequestBodyRepresentable)? {
        RedirectRuleUpdateRequestBody().reference()
    }

    var responseMap: ResponseMap {
        [
            200: RedirectRuleDetailResponse().reference(),
            404: CustomResponse(description: "Redirect rule not found"),
        ]
    }
}

struct RedirectRulePatchOperation: RedirectRuleIDOperation {
    var operationId: String? { "redirectRulePatch" }

    var parameters: [any ParameterRepresentable] {
        [
            RedirectRuleIdParameter().reference(),
            RedirectRuleUpdateMaskParameter().reference(),
        ]
    }

    var requestBody: (any RequestBodyRepresentable)? {
        RedirectRulePatchRequestBody().reference()
    }

    var responseMap: ResponseMap {
        [
            200: RedirectRuleDetailResponse().reference(),
            400: DefaultHTTPErrorContentResponse(
                description: "Invalid update mask or field value"
            ),
            404: CustomResponse(description: "Redirect rule not found"),
        ]
    }
}
