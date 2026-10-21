public import FeatherOpenAPI
import FeatherOpenAPIGenerator

public protocol RedirectRuleOperation: OperationRepresentable {}

struct RedirectRuleGetOperation: RedirectRuleOperation {
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
