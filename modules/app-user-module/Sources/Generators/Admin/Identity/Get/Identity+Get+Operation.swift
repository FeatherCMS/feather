import FeatherOpenAPI
import FeatherOpenAPIGenerator

extension Identity.Get {
    struct Operation: Identity.IdentifiableOperation {
        var operationId: String? { "userIdentityGet" }
        var responseMap: ResponseMap {
            [
                200: Identity.Get.Response().reference(),
                404: DefaultHTTPErrorContentResponse(
                    description: "UserIdentity not found"
                ),
            ]
        }
    }
}
