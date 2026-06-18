import FeatherOpenAPI
import SharedOpenAPIComponents

struct UserMagicLinkDetailResponse: JSONResponseRepresentable {
    var description: String = "User magic link response"
    var schema = UserMagicLinkDetailSchema().reference()
}

struct UserMagicLinkListResponse: JSONResponseRepresentable {
    var description: String = "List user magic links response"
    var schema = UserMagicLinkListSchema().reference()
}

struct UserMagicLinkFiltersResponse: JSONResponseRepresentable {
    var description: String = "UserMagicLink filter response"
    var schema = SearchFilterSchema().reference()
}
