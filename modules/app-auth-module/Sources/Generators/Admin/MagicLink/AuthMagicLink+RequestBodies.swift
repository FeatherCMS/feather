import FeatherOpenAPI
import OpenAPIKit30

struct AuthMagicLinkManagementRequestBody: RequestBodyRepresentable {
    var contentMap: ContentMap {
        [
            .json: Content(AuthMagicLinkCreateSchema().reference())
        ]
    }
}

struct AuthMagicLinkUpdateRequestBody: RequestBodyRepresentable {
    var contentMap: ContentMap {
        [
            .json: Content(AuthMagicLinkCreateSchema().reference())
        ]
    }
}

struct AuthMagicLinkPatchRequestBody: RequestBodyRepresentable {
    var contentMap: ContentMap {
        [
            .json: Content(AuthMagicLinkPatchSchema().reference())
        ]
    }
}
