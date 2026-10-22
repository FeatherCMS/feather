import FeatherOpenAPI
import OpenAPIKit30

extension Credential.Patch {

    struct AuthCredentialPatchRequestBody: RequestBodyRepresentable {
        var openAPIIdentifier: String { "AuthCredentialPatchRequestBody" }
        var contentMap: ContentMap {
            [
                .json: Content(
                    Credential.Schemas.AuthCredentialPatchSchema().reference()
                )
            ]
        }
    }
}
