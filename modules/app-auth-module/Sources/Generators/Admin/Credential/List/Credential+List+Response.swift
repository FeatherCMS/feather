import FeatherOpenAPI
import FeatherOpenAPIGenerator
import UserOpenAPIGeneratorSupport

extension Credential.List {

    struct Response: JSONResponseRepresentable {
        var openAPIIdentifier: String { "AuthCredentialListResponse" }
        var description: String = "AuthCredential list response"
        var schema = Credential.List.Schema().reference()
    }
}
