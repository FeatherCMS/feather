import FeatherOpenAPI
import OpenAPIKit30

extension Credential.Post {

    struct AuthCredentialRequestBody: RequestBodyRepresentable {
        var openAPIIdentifier: String { "AuthCredentialRequestBody" }
        var contentMap: ContentMap {
            [
                .json: Content(
                    Credential.Schemas.AuthCredentialCreateSchema().reference()
                )
            ]
        }
    }
}
