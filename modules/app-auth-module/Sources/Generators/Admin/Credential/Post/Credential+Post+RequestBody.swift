import FeatherOpenAPI

extension Credential.Post {

    struct RequestBody: RequestBodyRepresentable {
        var openAPIIdentifier: String { "AuthCredentialRequestBody" }
        var contentMap: ContentMap {
            [
                .json: Content(
                    Schema().reference()
                )
            ]
        }
    }
}
