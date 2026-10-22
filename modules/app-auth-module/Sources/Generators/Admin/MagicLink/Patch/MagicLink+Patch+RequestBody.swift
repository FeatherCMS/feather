import FeatherOpenAPI
import OpenAPIKit30

extension MagicLink.Patch {

    struct AuthMagicLinkPatchRequestBody: RequestBodyRepresentable {
        var openAPIIdentifier: String { "AuthMagicLinkPatchRequestBody" }
        var contentMap: ContentMap {
            [
                .json: Content(
                    MagicLink.Schemas.AuthMagicLinkPatchSchema().reference()
                )
            ]
        }
    }
}
