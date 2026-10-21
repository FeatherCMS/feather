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
                404: CustomResponse(description: "UserRole not found"),
            ]
        }
    }
}
