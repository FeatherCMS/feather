import FeatherOpenAPI
import FeatherOpenAPIGenerator
import UserOpenAPIGeneratorSupport

extension Credential.Put {

    struct Operation: Credential.IdentifiableOperation {
        var operationId: String? { "authCredentialUpdate" }

        var requestBody: (any RequestBodyRepresentable)? {
            Credential.Put.AuthCredentialUpdateRequestBody().reference()
        }

        var responseMap: ResponseMap {
            [
                200: Credential.Get.AuthCredentialDetailResponse().reference(),
                404: CustomResponse(description: "AuthCredential not found"),
            ]
        }
    }
}
