import FeatherOpenAPI
import FeatherOpenAPIGenerator

extension Role.Post {
    struct Operation: Role.Operation {
        var operationId: String? { "userRolePost" }
        var requestBody: (any RequestBodyRepresentable)? {
            Role.Post.RequestBody().reference()
        }
        var responseMap: ResponseMap {
            [
                201: Role.Get.Response().reference(),
                400: DefaultHTTPErrorContentResponse(
                    description: "Bad Request"
                ),
            ]
        }
    }
}
