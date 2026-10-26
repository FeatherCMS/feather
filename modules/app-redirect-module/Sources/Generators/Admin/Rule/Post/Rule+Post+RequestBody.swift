import FeatherOpenAPI

extension Rule.Post {
    struct RequestBody: RequestBodyRepresentable {
        var openAPIIdentifier: String { "RedirectRuleRequestBody" }
        var contentMap: ContentMap {
            [.json: Content(Rule.Schemas.Create().reference())]
        }
    }
}
