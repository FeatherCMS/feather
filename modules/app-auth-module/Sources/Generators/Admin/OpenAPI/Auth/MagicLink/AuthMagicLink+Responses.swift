import AuthSharedOpenAPIGenerator
import FeatherOpenAPI
import FeatherOpenAPIGenerator
import UserSharedOpenAPIGenerator

struct AuthMagicLinkDetailResponse: JSONResponseRepresentable {
    var description: String = "User magic link response"
    var schema = AuthMagicLinkDetailSchema().reference()
}

struct AuthMagicLinkListResponse: JSONResponseRepresentable {
    var description: String = "AuthMagicLink list response"
    var schema = AuthMagicLinkListSchema().reference()
}
