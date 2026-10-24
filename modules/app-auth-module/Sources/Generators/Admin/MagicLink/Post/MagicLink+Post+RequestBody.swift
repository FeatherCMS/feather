import FeatherOpenAPI
import OpenAPIKit30

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
