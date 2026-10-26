import FeatherOpenAPI
import FeatherOpenAPIGenerator

extension Rule.Get {
    struct Operation: Rule.IDOperation {
        var operationId: String? { "redirectRuleGet" }
        var responseMap: ResponseMap {
            [
                200: Response().reference(),
                404: CustomResponse(description: "Redirect rule not found"),
            ]
        }
    }
}
