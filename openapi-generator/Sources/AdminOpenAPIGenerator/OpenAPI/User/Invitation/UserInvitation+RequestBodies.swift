import FeatherOpenAPI
import OpenAPIKit30

struct UserInvitationRequestBody: RequestBodyRepresentable {
    var contentMap: ContentMap {
        [
            .json: Content(UserInvitationCreateSchema().reference())
        ]
    }
}

struct UserInvitationUpdateRequestBody: RequestBodyRepresentable {
    var contentMap: ContentMap {
        [
            .json: Content(UserInvitationCreateSchema().reference())
        ]
    }
}

struct UserInvitationPatchRequestBody: RequestBodyRepresentable {
    var contentMap: ContentMap {
        [
            .json: Content(UserInvitationPatchSchema().reference())
        ]
    }
}
