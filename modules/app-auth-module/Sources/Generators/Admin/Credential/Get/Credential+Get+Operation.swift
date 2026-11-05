import FeatherOpenAPI
import FeatherOpenAPIGenerator

extension Credential.Get {

    struct Operation: Credential.IdentifiableOperation {
        var operationId: String? { "authCredentialGet" }

        var responseMap: ResponseMap {
            [
                200: Response().reference(),
                404: CustomResponse(description: "AuthCredential not found"),
            ]
        }
    }
}
