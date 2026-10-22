import FeatherOpenAPI
import OpenAPIKit30

struct AuthMagicLinkManagementRequestBody: RequestBodyRepresentable {
    var contentMap: ContentMap {
        [.json: Content(AuthMagicLinkCreateSchema().reference())]
    }
}
