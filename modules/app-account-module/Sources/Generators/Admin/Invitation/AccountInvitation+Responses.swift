import AccountSharedOpenAPIGenerator
import FeatherOpenAPI
import FeatherOpenAPIGenerator

struct AccountInvitationDetailResponse: JSONResponseRepresentable {
    var description: String = "AccountInvitation response"
    var schema = AccountInvitationDetailSchema().reference()
}

struct AccountInvitationListResponse: JSONResponseRepresentable {
    var description: String = "AccountInvitation list response"
    var schema = AccountInvitationListSchema().reference()
}

struct AccountInvitationFiltersResponse: JSONResponseRepresentable {
    var description: String = "AccountInvitation filter response"
    var schema = SearchFilterSchema().reference()
}
