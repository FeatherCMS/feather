import AuthSharedOpenAPIGenerator
import FeatherOpenAPI
import FeatherOpenAPIGenerator
import UserSharedOpenAPIGenerator

struct AuthCredentialDetailResponse: JSONResponseRepresentable {
    var description: String = "User credential response"
    var schema = AuthCredentialDetailSchema().reference()
}

struct AuthCredentialListResponse: JSONResponseRepresentable {
    var description: String = "List user credentials response"
    var schema = AuthCredentialListSchema().reference()
}

struct AuthCredentialFiltersResponse: JSONResponseRepresentable {
    var description: String = "AuthCredential filter response"
    var schema = AuthCredentialSearchFilterSchema().reference()
}
