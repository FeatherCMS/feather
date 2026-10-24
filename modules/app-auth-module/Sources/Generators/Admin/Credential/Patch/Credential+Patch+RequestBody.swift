import FeatherOpenAPI

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
