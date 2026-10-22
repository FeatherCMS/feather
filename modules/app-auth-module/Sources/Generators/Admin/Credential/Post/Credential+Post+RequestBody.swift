import FeatherOpenAPI
import OpenAPIKit30

struct AuthCredentialRequestBody: RequestBodyRepresentable {
    var contentMap: ContentMap {
        [.json: Content(AuthCredentialCreateSchema().reference())]
    }
}
