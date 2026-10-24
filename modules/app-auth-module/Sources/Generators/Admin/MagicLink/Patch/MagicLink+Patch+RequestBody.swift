import FeatherOpenAPI

extension MagicLink.Patch {

    struct RequestBody: RequestBodyRepresentable {
        var openAPIIdentifier: String { "AuthMagicLinkPatchRequestBody" }
        var contentMap: ContentMap {
            [
                .json: Content(
                    MagicLink.Patch.Schema().reference()
                )
            ]
        }
    }
}
