import FeatherOpenAPI
import FeatherOpenAPIGenerator

extension Role.Get {
    struct Operation: Role.IdentifiableOperation {
        var operationId: String? { "userRoleGet" }
        var responseMap: ResponseMap {
            [
                200: Role.Get.Response().reference(),
                404: DefaultHTTPErrorContentResponse(
                    description: "UserRole not found"
                ),
            ]
        }
    }
}
