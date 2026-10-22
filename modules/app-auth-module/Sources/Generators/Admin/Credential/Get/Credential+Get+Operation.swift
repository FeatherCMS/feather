import FeatherOpenAPI
import FeatherOpenAPIGenerator
import UserOpenAPIGeneratorSupport

extension Credential.Get {

    struct Operation: Credential.IdentifiableOperation {
        var operationId: String? { "authCredentialGet" }

        var responseMap: ResponseMap {
            [
                200: Credential.Get.AuthCredentialDetailResponse().reference(),
                404: CustomResponse(description: "AuthCredential not found"),
            ]
        }
    }
}
