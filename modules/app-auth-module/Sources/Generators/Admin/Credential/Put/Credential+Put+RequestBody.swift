import FeatherOpenAPI
import OpenAPIKit30

struct AuthCredentialUpdateRequestBody: RequestBodyRepresentable {
    var contentMap: ContentMap {
        [.json: Content(AuthCredentialCreateSchema().reference())]
    }
}
