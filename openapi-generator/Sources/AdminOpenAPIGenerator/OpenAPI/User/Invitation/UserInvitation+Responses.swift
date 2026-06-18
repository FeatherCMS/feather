import FeatherOpenAPI
import SharedOpenAPIComponents

struct UserInvitationDetailResponse: JSONResponseRepresentable {
    var description: String = "UserInvitation response"
    var schema = UserInvitationDetailSchema().reference()
}

struct UserInvitationListResponse: JSONResponseRepresentable {
    var description: String = "UserInvitation list response"
    var schema = UserInvitationListSchema().reference()
}

struct UserInvitationFiltersResponse: JSONResponseRepresentable {
    var description: String = "UserInvitation filter response"
    var schema = SearchFilterSchema().reference()
}
