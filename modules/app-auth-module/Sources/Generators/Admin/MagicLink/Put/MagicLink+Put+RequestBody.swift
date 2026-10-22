import FeatherOpenAPI
import OpenAPIKit30

struct AuthMagicLinkUpdateRequestBody: RequestBodyRepresentable {
    var contentMap: ContentMap {
        [.json: Content(AuthMagicLinkCreateSchema().reference())]
    }
}
