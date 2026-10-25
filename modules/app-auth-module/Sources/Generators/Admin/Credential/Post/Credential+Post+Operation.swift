import FeatherOpenAPI
import FeatherOpenAPIGenerator
import UserOpenAPIGeneratorSupport

extension Credential.Post {

    struct Operation: Credential.Operation {
        var operationId: String? { "authCredentialCreate" }

        var requestBody: (any RequestBodyRepresentable)? {
            RequestBody().reference()
        }

        var responseMap: ResponseMap {
            [201: Credential.Get.Response().reference()]
        }
    }
}
