import FeatherOpenAPI
import SharedOpenAPIComponents

struct UserCredentialDetailResponse: JSONResponseRepresentable {
    var description: String = "User credential response"
    var schema = UserCredentialDetailSchema().reference()
}

struct UserCredentialListResponse: JSONResponseRepresentable {
    var description: String = "List user credentials response"
    var schema = UserCredentialListSchema().reference()
}

struct UserCredentialFiltersResponse: JSONResponseRepresentable {
    var description: String = "UserCredential filter response"
    var schema = SearchFilterSchema().reference()
}
