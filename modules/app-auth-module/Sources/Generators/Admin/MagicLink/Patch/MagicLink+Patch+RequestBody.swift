import FeatherOpenAPI
import OpenAPIKit30

struct AuthMagicLinkPatchRequestBody: RequestBodyRepresentable {
    var contentMap: ContentMap {
        [.json: Content(AuthMagicLinkPatchSchema().reference())]
    }
}
