import FeatherOpenAPI
import FeatherOpenAPIGenerator

extension Rule.Get {
    struct Operation: Rule.Operation {
        var operationId: String? { "redirectRuleGet" }

        var parameters: [any ParameterRepresentable] {
            [Rule.Parameters.Source().reference()]
        }

        var responseMap: ResponseMap {
            [
                200: Response().reference(),
                404: CustomResponse(description: "Redirect rule not found"),
            ]
        }
    }
}
