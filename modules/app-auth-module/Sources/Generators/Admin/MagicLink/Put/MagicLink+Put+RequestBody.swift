import FeatherOpenAPI

extension MagicLink.Put {

    struct RequestBody: RequestBodyRepresentable {
        var openAPIIdentifier: String { "AuthMagicLinkUpdateRequestBody" }
        var contentMap: ContentMap {
            [
                .json: Content(
                    MagicLink.Post.Schema().reference()
                )
            ]
        }
    }
}
