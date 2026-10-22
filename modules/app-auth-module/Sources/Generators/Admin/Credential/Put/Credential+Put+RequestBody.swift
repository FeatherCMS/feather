import FeatherOpenAPI
import OpenAPIKit30

extension Credential.Put {

    struct AuthCredentialUpdateRequestBody: RequestBodyRepresentable {
        var openAPIIdentifier: String { "AuthCredentialUpdateRequestBody" }
        var contentMap: ContentMap {
            [
                .json: Content(
                    Credential.Schemas.AuthCredentialCreateSchema().reference()
                )
            ]
        }
    }
}
