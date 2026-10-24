import FeatherOpenAPI
import FeatherOpenAPIGenerator
import UserOpenAPIGeneratorSupport

extension Credential.Get {

    struct Response: JSONResponseRepresentable {
        var openAPIIdentifier: String { "AuthCredentialDetailResponse" }
        var description: String = "User credential response"
        var schema = Credential.Get.Schema().reference()
    }
}
