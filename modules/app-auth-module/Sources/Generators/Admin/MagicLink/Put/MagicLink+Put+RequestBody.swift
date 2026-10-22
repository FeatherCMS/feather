import FeatherOpenAPI
import OpenAPIKit30

extension MagicLink.Put {

    struct AuthMagicLinkUpdateRequestBody: RequestBodyRepresentable {
        var openAPIIdentifier: String { "AuthMagicLinkUpdateRequestBody" }
        var contentMap: ContentMap {
            [
                .json: Content(
                    MagicLink.Schemas.AuthMagicLinkCreateSchema().reference()
                )
            ]
        }
    }
}
