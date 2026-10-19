import FeatherOpenAPI
import FeatherOpenAPIGenerator
import OpenAPIKit30

extension Permission.Post {
    struct Operation: Permission.Operation, BearerProtectedOperation {
        var operationId: String? { "systemPermissionPost" }
        var requestBody: (any RequestBodyRepresentable)? {
            RequestBody().reference()
        }
        var responseMap: ResponseMap {
            [
                201: Permission.Get.Response().reference(),
                400: DefaultHTTPErrorContentResponse(
                    description: "Bad Request"
                ),
                409: DefaultHTTPErrorContentResponse(
                    description: "Permission key already exists"
                ),
            ]
        }
    }
}
