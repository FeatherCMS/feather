import FeatherOpenAPI
import FeatherOpenAPIGenerator
import UserOpenAPIGeneratorSupport

extension Credential.Get {

    struct AuthCredentialDetailResponse: JSONResponseRepresentable {
        var openAPIIdentifier: String { "AuthCredentialDetailResponse" }
        var description: String = "User credential response"
        var schema = Credential.Schemas.AuthCredentialDetailSchema().reference()
    }
}
