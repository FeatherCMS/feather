import FeatherOpenAPI
import FeatherOpenAPIGenerator

extension Variable.Put {

    struct Operation: Variable.IdentifiableOperation, BearerProtectedOperation {
        var operationId: String? { "systemVariablePut" }
        var requestBody: (any RequestBodyRepresentable)? {
            RequestBody().reference()
        }
        var responseMap: ResponseMap {
            [
                200: Variable.Get.Response().reference(),
                400: DefaultHTTPErrorContentResponse(
                    description: "Bad Request"
                ),
                404: DefaultHTTPErrorContentResponse(
                    description: "SystemVariable not found"
                ),
                409: DefaultHTTPErrorContentResponse(
                    description: "Variable key already exists"
                ),
            ]
        }
    }

    struct RequestBody: RequestBodyRepresentable {
        var openAPIIdentifier: String { "SystemVariablePutRequestBody" }
        var contentMap: ContentMap {
            [.json: Content(Variable.Post.Schema().reference())]
        }
    }
}
