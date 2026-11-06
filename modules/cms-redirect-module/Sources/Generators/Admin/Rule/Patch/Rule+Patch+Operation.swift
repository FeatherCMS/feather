import FeatherOpenAPI
import FeatherOpenAPIGenerator

extension Rule.Patch {
    struct Operation: Rule.IDOperation {
        var operationId: String? { "redirectRulePatch" }
        var parameters: [any ParameterRepresentable] {
            [
                Rule.Parameters.ID().reference(),
                Rule.Parameters.UpdateMask().reference(),
            ]
        }
        var requestBody: (any RequestBodyRepresentable)? {
            RequestBody().reference()
        }
        var responseMap: ResponseMap {
            [
                200: Rule.Get.Response().reference(),
                400: DefaultHTTPErrorContentResponse(
                    description: "Invalid update mask or field value"
                ),
                404: CustomResponse(description: "Redirect rule not found"),
            ]
        }
    }
}
