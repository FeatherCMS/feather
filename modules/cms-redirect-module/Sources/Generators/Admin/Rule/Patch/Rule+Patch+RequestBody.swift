import FeatherOpenAPI

extension Rule.Patch {
    struct RequestBody: RequestBodyRepresentable {
        var openAPIIdentifier: String { "RedirectRulePatchRequestBody" }
        var contentMap: ContentMap {
            [.json: Content(Schema().reference())]
        }
    }
}
