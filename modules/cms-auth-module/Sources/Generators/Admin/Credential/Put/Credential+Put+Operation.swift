import FeatherOpenAPI
import FeatherOpenAPIGenerator

extension Credential.Put {

    struct Operation: Credential.IdentifiableOperation {
        var operationId: String? { "authCredentialUpdate" }

        var requestBody: (any RequestBodyRepresentable)? {
            RequestBody().reference()
        }

        var responseMap: ResponseMap {
            [
                200: Credential.Get.Response().reference(),
                404: CustomResponse(description: "AuthCredential not found"),
            ]
        }
    }
}
