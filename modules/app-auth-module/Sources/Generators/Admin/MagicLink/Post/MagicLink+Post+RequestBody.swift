import FeatherOpenAPI
import OpenAPIKit30

extension MagicLink.Post {

    struct AuthMagicLinkManagementRequestBody: RequestBodyRepresentable {
        var openAPIIdentifier: String { "AuthMagicLinkManagementRequestBody" }
        var contentMap: ContentMap {
            [
                .json: Content(
                    MagicLink.Schemas.AuthMagicLinkCreateSchema().reference()
                )
            ]
        }
    }
}
