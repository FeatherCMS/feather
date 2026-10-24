import FeatherOpenAPI
import FeatherOpenAPIGenerator

extension Rule.Get {
    struct Operation: Rule.Operation {
        var operationId: String? { "redirectRuleGet" }

        var parameters: [any ParameterRepresentable] {
            [RedirectSourceParameter().reference()]
        }

        var responseMap: ResponseMap {
            [
                200: RedirectRuleResponse().reference(),
                404: CustomResponse(description: "Redirect rule not found"),
            ]
        }
    }
}
