import FeatherOpenAPI
import FeatherOpenAPIGenerator

extension Credential.Get {

    struct Response: JSONResponseRepresentable {
        var openAPIIdentifier: String { "AuthCredentialDetailResponse" }
        var description: String = "User credential response"
        var schema = Schema().reference()
    }
}
