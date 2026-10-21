import FeatherOpenAPI
import FeatherOpenAPIGenerator
import UserOpenAPIGeneratorSupport

extension Identity.Put {
    struct Operation: Identity.IdentifiableOperation {
        var operationId: String? { "userIdentityPut" }
        var requestBody: (any RequestBodyRepresentable)? {
            Identity.Put.RequestBody().reference()
        }
        var responseMap: ResponseMap {
            [
                200: Identity.Get.Response().reference(),
                404: CustomResponse(description: "UserIdentity not found"),
            ]
        }
    }
}
