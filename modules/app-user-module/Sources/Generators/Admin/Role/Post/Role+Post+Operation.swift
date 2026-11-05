import FeatherOpenAPI
import FeatherOpenAPIGenerator

extension Role.Post {
    struct Operation: Role.Operation {
        var operationId: String? { "userRolePost" }
        var requestBody: (any RequestBodyRepresentable)? {
            RequestBody().reference()
        }
        var responseMap: ResponseMap {
            [
                201: Role.Get.Response().reference(),
                400: DefaultHTTPErrorContentResponse(
                    description: "Bad Request"
                ),
                409: DefaultHTTPErrorContentResponse(
                    description: "Role key already exists"
                ),
            ]
        }
    }
}
