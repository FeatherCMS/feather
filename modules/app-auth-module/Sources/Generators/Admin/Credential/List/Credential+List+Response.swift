import FeatherOpenAPI
import FeatherOpenAPIGenerator
import UserOpenAPIGeneratorSupport

extension Credential.List {

    struct AuthCredentialListResponse: JSONResponseRepresentable {
        var openAPIIdentifier: String { "AuthCredentialListResponse" }
        var description: String = "AuthCredential list response"
        var schema = Credential.Schemas.AuthCredentialListSchema().reference()
    }
}
