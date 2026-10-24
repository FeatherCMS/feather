import FeatherOpenAPI

extension MagicLink.Post {

    struct RequestBody: RequestBodyRepresentable {
        var openAPIIdentifier: String { "AuthMagicLinkManagementRequestBody" }
        var contentMap: ContentMap {
            [
                .json: Content(
                    MagicLink.Post.Schema().reference()
                )
            ]
        }
    }
}
