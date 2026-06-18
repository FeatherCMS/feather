import FeatherOpenAPI
import OpenAPIKit30

struct UserMagicLinkRequestBody: RequestBodyRepresentable {
    var contentMap: ContentMap {
        [
            .json: Content(UserMagicLinkCreateSchema().reference())
        ]
    }
}

struct UserMagicLinkUpdateRequestBody: RequestBodyRepresentable {
    var contentMap: ContentMap {
        [
            .json: Content(UserMagicLinkCreateSchema().reference())
        ]
    }
}

struct UserMagicLinkPatchRequestBody: RequestBodyRepresentable {
    var contentMap: ContentMap {
        [
            .json: Content(UserMagicLinkPatchSchema().reference())
        ]
    }
}
