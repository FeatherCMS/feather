import FeatherOpenAPI
import FeatherOpenAPIGenerator

extension Role.Put {
    struct Operation: Role.IdentifiableOperation {
        var operationId: String? { "userRolePut" }
        var requestBody: (any RequestBodyRepresentable)? {
            Role.Put.RequestBody().reference()
        }
        var responseMap: ResponseMap {
            [
                200: Role.Get.Response().reference(),
                400: DefaultHTTPErrorContentResponse(
                    description: "Bad Request"
                ),
                404: DefaultHTTPErrorContentResponse(
                    description: "UserRole not found"
                ),
            ]
        }
    }
}
