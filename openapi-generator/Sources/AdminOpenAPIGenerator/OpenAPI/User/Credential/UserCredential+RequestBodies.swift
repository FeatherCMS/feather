import FeatherOpenAPI
import OpenAPIKit30

struct UserCredentialRequestBody: RequestBodyRepresentable {
    var contentMap: ContentMap {
        [
            .json: Content(UserCredentialCreateSchema().reference())
        ]
    }
}

struct UserCredentialUpdateRequestBody: RequestBodyRepresentable {
    var contentMap: ContentMap {
        [
            .json: Content(UserCredentialCreateSchema().reference())
        ]
    }
}

struct UserCredentialPatchRequestBody: RequestBodyRepresentable {
    var contentMap: ContentMap {
        [
            .json: Content(UserCredentialPatchSchema().reference())
        ]
    }
}
