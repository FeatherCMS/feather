import FeatherOpenAPI
import OpenAPIKit30

struct AccountInvitationRequestBody: RequestBodyRepresentable {
    var contentMap: ContentMap {
        [
            .json: Content(AccountInvitationCreateSchema().reference())
        ]
    }
}

struct AccountInvitationUpdateRequestBody: RequestBodyRepresentable {
    var contentMap: ContentMap {
        [
            .json: Content(AccountInvitationCreateSchema().reference())
        ]
    }
}

struct AccountInvitationPatchRequestBody: RequestBodyRepresentable {
    var contentMap: ContentMap {
        [
            .json: Content(AccountInvitationPatchSchema().reference())
        ]
    }
}
