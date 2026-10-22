import FeatherOpenAPI
import OpenAPIKit30

extension Credential.Patch {

    struct RequestBody: RequestBodyRepresentable {
        var openAPIIdentifier: String { "AuthCredentialPatchRequestBody" }
        var contentMap: ContentMap {
            [
                .json: Content(
                    Credential.Patch.Schema().reference()
                )
            ]
        }
    }
}
