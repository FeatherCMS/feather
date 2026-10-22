import FeatherOpenAPI
import OpenAPIKit30

struct AuthCredentialPatchRequestBody: RequestBodyRepresentable {
    var contentMap: ContentMap {
        [.json: Content(AuthCredentialPatchSchema().reference())]
    }
}
