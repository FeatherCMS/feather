import FeatherOpenAPI
import OpenAPIKit30

struct AuthCredentialRequestBody: RequestBodyRepresentable {
    var contentMap: ContentMap {
        [
            .json: Content(AuthCredentialCreateSchema().reference())
        ]
    }
}

struct AuthCredentialUpdateRequestBody: RequestBodyRepresentable {
    var contentMap: ContentMap {
        [
            .json: Content(AuthCredentialCreateSchema().reference())
        ]
    }
}

struct AuthCredentialPatchRequestBody: RequestBodyRepresentable {
    var contentMap: ContentMap {
        [
            .json: Content(AuthCredentialPatchSchema().reference())
        ]
    }
}
