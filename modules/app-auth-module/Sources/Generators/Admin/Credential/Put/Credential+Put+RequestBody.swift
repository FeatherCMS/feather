import FeatherOpenAPI

extension Credential.Put {

    struct RequestBody: RequestBodyRepresentable {
        var openAPIIdentifier: String { "AuthCredentialUpdateRequestBody" }
        var contentMap: ContentMap {
            [
                .json: Content(
                    Credential.Post.Schema().reference()
                )
            ]
        }
    }
}
