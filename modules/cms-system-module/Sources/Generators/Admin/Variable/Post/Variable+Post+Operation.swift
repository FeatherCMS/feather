import FeatherOpenAPI
import FeatherOpenAPIGenerator

extension Variable.Post {
    struct Operation: Variable.Operation, BearerProtectedOperation {
        var operationId: String? { "systemVariablePost" }
        var requestBody: (any RequestBodyRepresentable)? {
            RequestBody().reference()
        }
        var responseMap: ResponseMap {
            [
                201: Variable.Get.Response().reference(),
                400: DefaultHTTPErrorContentResponse(
                    description: "Bad Request"
                ),
                409: DefaultHTTPErrorContentResponse(
                    description: "Variable key already exists"
                ),
            ]
        }
    }
}
